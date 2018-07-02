package com.example.myact.controller;

import com.example.myact.common.model.DeploymentModel;
import com.example.myact.common.util.Page;
import com.example.myact.common.util.UserUtil;
import com.example.myact.convert.LayuiTableData;
import com.example.myact.convert.PageDataConvert;
import com.example.myact.service.WorkFlowService;
import com.example.myact.service.WorkflowTraceService;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.engine.*;
import org.activiti.engine.form.FormProperty;
import org.activiti.engine.identity.User;
import org.activiti.engine.impl.cfg.ProcessEngineConfigurationImpl;
import org.activiti.engine.impl.context.Context;
import org.activiti.engine.impl.form.DateFormType;
import org.activiti.engine.impl.form.StartFormDataImpl;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.DeploymentBuilder;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.activiti.image.ProcessDiagramGenerator;
import org.activiti.spring.ProcessEngineFactoryBean;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;


@Controller
@RequestMapping("/workflow")
public class WorkFlowController {
    private static final Logger logger = LoggerFactory.getLogger(WorkFlowController.class);

    @Autowired
    private RuntimeService runtimeService;
    @Autowired
    private TaskService taskService;
    @Autowired
    private RepositoryService responsitorySercvie;
    @Autowired
    private HistoryService historyService;
    @Autowired
    private ManagementService managementService;
    @Autowired
    private FormService formService;
    @Autowired
    private IdentityService identityService;
    @Autowired
    private WorkFlowService workFlowService;
    @Autowired
    private ProcessEngineFactoryBean processEngine;
    @Autowired
    ProcessEngineConfiguration processEngineConfiguration;
    @Autowired
    private WorkflowTraceService traceService;


    /****
     * 流程部署
     */
    @RequestMapping(value = "deploy")
    @ResponseBody
    public ResponseEntity deploy(HttpServletRequest request, HttpServletResponse response, Model model, DeploymentModel deployment) {
        DeploymentBuilder builder = this.responsitorySercvie.createDeployment();
        builder.addString(deployment.getProcessName() + ".bpmn", deployment.getProcessDescriptor()).name(deployment.getProcessName());
        builder.deploy();
        return ResponseEntity.ok( "操作成功！");
    }

    /****
     * 删除流程定义
     */
    @RequestMapping(value = "unDeploy")
    @ResponseBody
    public ResponseEntity delete(HttpServletRequest request, HttpServletResponse response, Model model,String processDefinitionId) {
        Map<String,Object> map = new HashMap<>();
        List<ProcessDefinition> processDefinitions = this.responsitorySercvie.createProcessDefinitionQuery().processDefinitionId(processDefinitionId).list();

        processDefinitions.forEach(processDefinition -> {
            String deploymentId = processDefinition.getDeploymentId();
            responsitorySercvie.deleteDeployment(deploymentId,true);
        });

        map.put("status",true);
        map.put("message","操作成功!");
        return ResponseEntity.ok(map);
    }

    /****
     * 导出流程定义
     *
     * @param processDefinitionId
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "exportDefinition")
    @ResponseBody
    public ResponseEntity<InputStreamResource> exportDefinition(String processDefinitionId) throws IOException {
        ProcessDefinition processDefinition = this.responsitorySercvie.createProcessDefinitionQuery().processDefinitionId(processDefinitionId).singleResult();
        InputStream inputStream = this.responsitorySercvie.getProcessModel(processDefinitionId);
        InputStreamResource resource = new InputStreamResource(inputStream);
        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        responseHeaders.set("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(processDefinition.getName() + ".bpmn", "UTF-8") + "\"");
        return new ResponseEntity<InputStreamResource>(resource, responseHeaders, HttpStatus.OK);
    }

    /****
     * 上传流程程定义并部署
     *
     * @param file
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "importDefinition")
    @ResponseBody
    public ResponseEntity importDefinition(@RequestParam(value = "file") MultipartFile file) throws IOException {
        this.workFlowService.deploy(file.getOriginalFilename(), file.getInputStream());
        return ResponseEntity.ok(true);
    }

    /*****
     * 流程定义列表
     *
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping(value = "processDefinitionList")
    public String processDefinitionList(HttpServletRequest request, HttpServletResponse response, Model model) {
        return "workflow/processDefinitionList";
    }
    /**
     * 流程定义列表
     *
     * @return
     */
    @RequestMapping(value = "pagingProcessDefinition")
    @ResponseBody
    public LayuiTableData pagingProcessDefinition(Page page) {
        return PageDataConvert.convertToLayuiData(this.workFlowService.pagingProcessDefinition(page));
    }

    @RequestMapping(value = "taskList")
    public String taskList(){
        return "workflow/taskList";
    }
    /****
     * 分页查询任务
     *
     * @param model
     * @param page
     * @return
     */
    @RequestMapping(value = "pagingTask")
    @ResponseBody
    public LayuiTableData taskList(Model model,HttpServletRequest request, Page page, String keywords) {
        //TODO userId需要额外处理
        User user = UserUtil.getUserFromSession(request.getSession());
        String userId = user.getId();
        TaskQuery query = this.taskService.createTaskQuery().taskCandidateOrAssigned(userId);
        if (StringUtils.isNotBlank(keywords)) {
            String keywordsLike = '%' + keywords + '%';
            query.or().taskNameLikeIgnoreCase(keywordsLike).taskDescriptionLikeIgnoreCase(keywordsLike).endOr();
        }
        query.orderByTaskCreateTime().desc();
        page.setTotalCount(query.count());
        List<Task> q = query.listPage((page.getPageNo() - 1) * page.getPageSize(), (page.getPageNo() - 1) * page.getPageSize() + page.getPageSize());

        List<Map<String, Object>> list = new ArrayList<>();
        Map<String, Object> map;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (Task task : q) {
            map = new HashMap<>();
            map.put("taskId",task.getId());
            map.put("name", task.getName());
            map.put("description",task.getDescription());
            map.put("processDefinitionId", task.getId());
            map.put("createTime",simpleDateFormat.format(task.getCreateTime()));
            map.put("assignee",task.getAssignee());
            list.add(map);
        }

        if(list.size()>page.getPageSize()){
            page.setResult(list.subList(0, page.getPageSize()));
        }else{
            page.setResult(list);
        }
        return PageDataConvert.convertToLayuiData(page);
    }

    /****
     * 获取流程定义图片
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "processDefinitionImage")
    public ResponseEntity<InputStreamResource> processDefinitionImage(String processDefinitionId) throws IOException {
        ProcessDefinition processDefinition = this.responsitorySercvie.createProcessDefinitionQuery().processDefinitionId(processDefinitionId).singleResult();
        Deployment deployment = this.responsitorySercvie.createDeploymentQuery().deploymentId(processDefinition.getDeploymentId()).singleResult();
        List<String> names = this.responsitorySercvie.getDeploymentResourceNames(deployment.getId());
        String imageName = null;
        for (String name : names) {
            if (name.endsWith(".png")) {
                imageName = name;
            }
        }
        InputStream inputStream = this.responsitorySercvie.getResourceAsStream(deployment.getId(), imageName);
        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        responseHeaders.setContentDispositionFormData("attachment", imageName);
        return new ResponseEntity<InputStreamResource>(new InputStreamResource(inputStream), responseHeaders, HttpStatus.OK);
    }
    /**
     * 输出跟踪流程信息
     *
     * @param processInstanceId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/process/trace")
    @ResponseBody
    public List<Map<String, Object>> traceProcess(@RequestParam("pid") String processInstanceId) throws Exception {
        List<Map<String, Object>> activityInfos = traceService.traceProcess(processInstanceId);
        return activityInfos;
    }

    /**
     * 读取带跟踪的图片
     */
    @RequestMapping(value = "/process/trace/auto/{executionId}")
    public void readResource(@PathVariable("executionId") String executionId, HttpServletResponse response)
            throws Exception {
        ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processInstanceId(executionId).singleResult();
        BpmnModel bpmnModel = responsitorySercvie.getBpmnModel(processInstance.getProcessDefinitionId());
        List<String> activeActivityIds = runtimeService.getActiveActivityIds(executionId);
        // 不使用spring请使用下面的两行代码
//    ProcessEngineImpl defaultProcessEngine = (ProcessEngineImpl) ProcessEngines.getDefaultProcessEngine();
//    Context.setProcessEngineConfiguration(defaultProcessEngine.getProcessEngineConfiguration());

        // 使用spring注入引擎请使用下面的这行代码
        processEngineConfiguration = processEngine.getProcessEngineConfiguration();
        Context.setProcessEngineConfiguration((ProcessEngineConfigurationImpl) processEngineConfiguration);

        ProcessDiagramGenerator diagramGenerator = processEngineConfiguration.getProcessDiagramGenerator();
        InputStream imageStream = diagramGenerator.generateDiagram(bpmnModel, "png", activeActivityIds);

        // 输出资源内容到相应对象
        byte[] b = new byte[1024];
        int len;
        while ((len = imageStream.read(b, 0, 1024)) != -1) {
            response.getOutputStream().write(b, 0, len);
        }
    }

    /**
     * 通过流程Key读取启动流程的表单字段，并返回表单字段
     */
    @RequestMapping(value = "startFormByKey")
    @ResponseBody
    public ResponseEntity startFormByKey(String processDefinitionKey) throws Exception {
        ProcessDefinitionQuery query = this.responsitorySercvie.createProcessDefinitionQuery().latestVersion().processDefinitionKey(processDefinitionKey);
        return this.startFormById(query.singleResult().getId());
    }
    /**
     * 通过流程Id读取启动流程的表单字段，并返回表单字段
     */
    @RequestMapping(value = "startFormById")
    @ResponseBody
    public ResponseEntity startFormById(String processDefinitionId) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();
        StartFormDataImpl startFormData = (StartFormDataImpl) formService.getStartFormData(processDefinitionId);
        /*
         * 读取enum类型数据，用于下拉框
         */
        List<FormProperty> formProperties = startFormData.getFormProperties();
        for (FormProperty formProperty : formProperties) {
            Map<String, String> values = (Map<String, String>) formProperty.getType().getInformation("values");
            if (formProperty.getType() instanceof DateFormType) {
                String datePattern = (String) formProperty.getType().getInformation("datePattern");
                result.put("datePattern_" + formProperty.getId(), datePattern);
            }
            if (values != null) {
                for (Map.Entry<String, String> enumEntry : values.entrySet()) {
                    logger.debug("enum, key: {}, value: {}", enumEntry.getKey(), enumEntry.getValue());
                }
                result.put("enum_" + formProperty.getId(), values);
            }
        }
        for (FormProperty formProperty : formProperties) {
            String id = formProperty.getId();
            result.put(id, formProperty.getValue());
        }
        result.put("formProperties", startFormData.getFormProperties());
        result.put("name", startFormData.getProcessDefinition().getName());
        result.put("id", startFormData.getProcessDefinition().getId());
        return ResponseEntity.ok(result);
    }


    /**
     * 通过流程Key读取启动流程的表单字段,并跳转至页面
     */
    @RequestMapping(value = "startFormByKeyToView")
    public String startCustomFormByKey(Model model, String processDefinitionKey) throws Exception {
        ProcessDefinitionQuery query = this.responsitorySercvie.createProcessDefinitionQuery().latestVersion().processDefinitionKey(processDefinitionKey);
        return this.startCustomFormById(model, query.singleResult().getId());
    }

    /**
     * 通过流程Id读取启动流程的表单字段,并跳转至页面
     */
    @RequestMapping(value = "startFormByIdToView")
    public String startCustomFormById(Model model, String processDefinitionId) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();
        StartFormDataImpl startFormData = (StartFormDataImpl) formService.getStartFormData(processDefinitionId);
        String view = startFormData.getFormKey();
        /*
         * 读取enum类型数据，用于下拉框
         */
        List<FormProperty> formProperties = startFormData.getFormProperties();
        for (FormProperty formProperty : formProperties) {
            Map<String, String> values = (Map<String, String>) formProperty.getType().getInformation("values");
            if (formProperty.getType() instanceof DateFormType) {
                String datePattern = (String) formProperty.getType().getInformation("datePattern");
                result.put("datePattern_" + formProperty.getId(), datePattern);
            }
            if (values != null) {
                for (Map.Entry<String, String> enumEntry : values.entrySet()) {
                    logger.debug("enum, key: {}, value: {}", enumEntry.getKey(), enumEntry.getValue());
                }
                result.put("enum_" + formProperty.getId(), values);
            }
        }
        model.addAttribute("processDefinitionId", processDefinitionId);
        for (FormProperty formProperty : formProperties) {
            String id = formProperty.getId();
            model.addAttribute(id, formProperty.getValue());
        }
        return view;
    }

    /**
     * 启动流程
     * @return
     */
    @RequestMapping(value = "start")
    public String start(String processDefinitionId, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        //TODO  userId 需要额外处理
        User user = UserUtil.getUserFromSession(request.getSession());
        String userId = user.getId();
        Map<String, String> formProperties = new HashMap<String, String>();
        // 从request中读取参数然后转换
        Map<String, String[]> parameterMap = request.getParameterMap();
        Set<Map.Entry<String, String[]>> entrySet = parameterMap.entrySet();
        for (Map.Entry<String, String[]> entry : entrySet) {
            String key = entry.getKey();
            // fp_的意思是form paremeter
            for (FormProperty formProperty : formService.getStartFormData(processDefinitionId).getFormProperties()) {
                if (formProperty.getId().equals(key) && formProperty.isWritable()) {
                    formProperties.put(key, StringUtils.join(entry.getValue(), ","));
                }
            }
        }
        logger.debug("start form parameters: {}", formProperties);

        // 用户未登录不能操作，实际应用使用权限框架实现，例如Spring Security、Shiro等
        if (StringUtils.isBlank(userId)) {
            // return "redirect:/base/toLogin";
        }
        identityService.setAuthenticatedUserId(userId);
        ProcessInstance processInstance = formService.submitStartFormData(processDefinitionId, formProperties);
        logger.debug("start a processinstance: {}", processInstance);
        redirectAttributes.addFlashAttribute("message", "启动成功，流程ID：" + processInstance.getId());
        List<Task> list = this.taskService.createTaskQuery().processInstanceId(processInstance.getId()).taskAssignee(userId).list();
        if (list.size() == 1) {
            return "redirect:/workflow/customTaskForm?taskId=" + list.get(0).getId();
        } else {
            return "redirect:/workflow/taskList";
        }
        // return new Ajax(true, "操作成功！");
    }

    /**
     * 提交task的并保存form
     */
    @RequestMapping(value = "completeForm")
    public String completeForm(HttpServletRequest request, HttpServletResponse response, Map<String, Object> map, RedirectAttributes redirectAttributes, String taskId, Model model) {
        //TODO  userId 需要额外处理
        User user = UserUtil.getUserFromSession(request.getSession());
        String userId = user.getId();

        Task task = this.taskService.createTaskQuery().taskId(taskId).singleResult();
        String nextMessage = null;
        if (task == null || !userId.equals(task.getAssignee())) {
            System.out.println("任务找不到！！！！！！！！！！！！！！");
            return "workflow/taskNotFound";
        } else {
            String executionId = this.taskService.createTaskQuery().taskId(taskId).singleResult().getExecutionId();
            Map<String, String> formProperties = new HashMap<String, String>();
            // 从request中读取参数然后转换
            Map<String, String[]> parameterMap = request.getParameterMap();
            Set<Map.Entry<String, String[]>> entrySet = parameterMap.entrySet();

            for (Map.Entry<String, String[]> entry : entrySet) {
                String key = entry.getKey();
                // fp_的意思是form paremeter
                for (FormProperty formProperty : formService.getTaskFormData(taskId).getFormProperties()) {
                    if (formProperty.getId().equals(key) && formProperty.isWritable()) {
                        formProperties.put(key, StringUtils.join(entry.getValue(), ","));
                    }
                    if (formProperty.getId().equals("next_message")) {
                        nextMessage = formProperty.getValue();
                    }
                }
            }
            try {
                identityService.setAuthenticatedUserId(userId);
                formService.submitTaskFormData(taskId, formProperties);
            } catch (ActivitiException e) {
                logger.error(e.getMessage(), e);;
//                if (e.getCause() != null && e.getCause().getCause() != null && e.getCause().getCause().getCause() instanceof TaskNotFinishException) {
//                    redirectAttributes.addFlashAttribute("message", e.getCause().getCause().getCause().getMessage());
//                    return "redirect:/workflow/customTaskForm?taskId=" + taskId;
//                } else {
                    throw e;
//                }
            }
            List<Task> list = this.taskService.createTaskQuery().executionId(executionId).taskAssignee(userId).list();
            if (list.size() == 1) {
                return "redirect:/workflow/customTaskForm?taskId=" + list.get(0).getId();
            } else {
                System.out.println(nextMessage);
                if (StringUtils.isNotBlank(nextMessage)) {
                    map.put("nextMessage", nextMessage);
                    return "workflow/taskTipMessage";
                }
                return "redirect:/home";
            }
        }
    }

    /*****
     * 任务签收
     *
     * @param taskId
     * @return
     */
    @RequestMapping(value = "claim")
    @ResponseBody
    public ResponseEntity claim(HttpServletRequest request,String taskId) {
        //TODO  userId 需要额外处理
        User user = UserUtil.getUserFromSession(request.getSession());
        String userId = user.getId();
        this.identityService.setAuthenticatedUserId(userId);
        this.taskService.claim(taskId, userId);
        return ResponseEntity.ok("签收成功");
    }

    @RequestMapping(value = "unclaim")
    @ResponseBody
    public ResponseEntity unclaim(HttpServletRequest request,String taskId) {
        //TODO  userId 需要额外处理
        User user = UserUtil.getUserFromSession(request.getSession());
        String userId = user.getId();
        this.identityService.setAuthenticatedUserId(userId);
        this.taskService.claim(taskId, null);
        return ResponseEntity.ok("反签收成功");
    }

}
