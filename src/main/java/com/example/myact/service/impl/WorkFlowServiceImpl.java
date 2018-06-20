package com.example.myact.service.impl;

import com.example.myact.common.util.Page;
import com.example.myact.service.WorkFlowService;
import org.activiti.engine.*;
import org.activiti.engine.impl.RepositoryServiceImpl;
import org.activiti.engine.impl.persistence.entity.ExecutionEntity;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.repository.DeploymentBuilder;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.activiti.engine.runtime.Job;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class WorkFlowServiceImpl implements WorkFlowService {
    @Resource
    private RuntimeService runtimeService;

    @Resource
    private IdentityService identityService;

    @Resource
    private ManagementService managementService;

    @Resource
    private RepositoryService responsitorySercvie;

    @Resource
    private TaskService taskService;

    @Autowired
    private FormService formService;

    private Logger logger = LoggerFactory.getLogger(WorkFlowService.class);

    @Override
    public void startProcessInstanceByKey(String userId, String processDefinitionKey) {
        this.identityService.setAuthenticatedUserId(userId);
        this.runtimeService.startProcessInstanceByKey(processDefinitionKey);

    }

    @Override
    public void startProcessInstanceByKey(String userId, String processDefinitionKey, String processBusinessKey) {
        this.identityService.setAuthenticatedUserId(userId);
        this.runtimeService.startProcessInstanceByKey(processDefinitionKey, processBusinessKey);
    }

    @Override
    public void startProcessInstanceByKey(String userId, String processDefinitionKey, String processBusinessKey, Map<String, Object> variables) {
        this.identityService.setAuthenticatedUserId(userId);
        this.runtimeService.startProcessInstanceByKey(processDefinitionKey, processBusinessKey, variables);

    }

    @Override
    public void signalEventReceived(String signalName, String executionId) {
        this.runtimeService.signalEventReceived(signalName, executionId);

    }

    @Override
    public void deleteProcessInstance(String processInstanceId, String deleteReason) {
        this.runtimeService.deleteProcessInstance(processInstanceId, deleteReason);
    }

    @Override
    public Page pagingJob(Page page){
        List<Job> jobList=this.managementService.createJobQuery().orderByJobDuedate().asc().listPage((page.getPageNo() - 1) * page.getPageSize(), (page.getPageNo() - 1) * page.getPageSize() + page.getPageSize());
        page.setResult(jobList);
        Long count = this.managementService.createJobQuery().count();
        page.setTotalCount(count);
        return page;
    }

    @Override
    public void executeJob(String jobId){
        this.managementService.executeJob(jobId);
    }

    @Override
    public Page pagingProcessDefinition(Page page) {
        ProcessDefinitionQuery query = this.responsitorySercvie.createProcessDefinitionQuery().orderByProcessDefinitionName().latestVersion().desc();
        page.setResult(query.listPage((page.getPageNo() - 1) * page.getPageSize(), (page.getPageNo() - 1) * page.getPageSize() + page.getPageSize()));
        page.setTotalCount(query.count());
        return page;
    }

    @Override
    public void deploy(String fileName,InputStream inputStream){
        DeploymentBuilder builder = this.responsitorySercvie.createDeployment();
        builder.addInputStream(fileName, inputStream);
        builder.deploy();
    }

    @Override
    public List<ActivityImpl> getActivityListByProcessInstanceId(String processInstanceId) {
        List<ActivityImpl> activityList =new ArrayList<ActivityImpl>();
        ProcessInstance processInstnace = this.runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult();
        String processDefinitionId=processInstnace.getProcessDefinitionId();
        ProcessDefinitionEntity definitionEntity = (ProcessDefinitionEntity) ((RepositoryServiceImpl) this.responsitorySercvie).getDeployedProcessDefinition(processDefinitionId);
        List<Task> taskList = this.taskService.createTaskQuery().processInstanceId(processInstanceId).list();
        List<ActivityImpl> activities = definitionEntity.getActivities();
        for (Task task : taskList) {
            ExecutionEntity executionEntity = (ExecutionEntity) runtimeService.createExecutionQuery().executionId(task.getExecutionId()).singleResult();
            String activitiId = executionEntity.getActivityId();
            for (ActivityImpl activity1 : activities) {
                if (activity1.getId().equals(activitiId)) {
                    activityList.add(activity1);
                    break;
                }
            }
        }
        return activityList;
    }

    @Override
    public ProcessInstance getProcessInstance(String processInstanceId){
        return this.runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult();
    }

    public void logWorkFlowInfo(String msg) {
        logger.info(msg);
    }

}
