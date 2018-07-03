package com.example.myact.controller;

import com.example.myact.common.util.Page;
import com.example.myact.common.util.PageUtil;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.runtime.ProcessInstanceQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workflow/processinstance")
public class ProcessInstanceController {
    private static final Logger logger = LoggerFactory.getLogger(ProcessInstanceController.class);

    @Autowired
    private RuntimeService runtimeService;

    @RequestMapping(value = "running")
    public ModelAndView running(Model model, HttpServletRequest request) {
        ModelAndView mav = new ModelAndView("/workflow/running-manage");
        Page<ProcessInstance> page = new Page<ProcessInstance>(PageUtil.PAGE_SIZE);
        int[] pageParams = PageUtil.init(page, request);

        ProcessInstanceQuery processInstanceQuery = runtimeService.createProcessInstanceQuery();
        List<ProcessInstance> list = processInstanceQuery.listPage(pageParams[0], pageParams[1]);
        page.setResult(list);
        page.setTotalCount(processInstanceQuery.count());
        mav.addObject("page", page);
        return mav;
    }

    /**
     * 挂起、激活、删除流程实例
     */
    @RequestMapping(value = "update/{state}/{processInstanceId}")
    public ResponseEntity updateState(@PathVariable("state") String state, @PathVariable("processInstanceId") String processInstanceId,
                                      String describe) {
        Map<String,Object> map = new HashMap<>();
        switch (state) {
            case "active":
                map.put("message", "已激活ID为[" + processInstanceId + "]的流程实例。");
                logger.info("已激活ID为[" + processInstanceId + "]的流程实例。");
                runtimeService.activateProcessInstanceById(processInstanceId);
                break;
            case "suspend":
                runtimeService.suspendProcessInstanceById(processInstanceId);
                map.put("message", "已挂起ID为[" + processInstanceId + "]的流程实例。");
                logger.info("已挂起ID为[" + processInstanceId + "]的流程实例。");
                break;
            case "delete":
                runtimeService.deleteProcessInstance(processInstanceId, describe);
                map.put("message", "已删除ID为[" + processInstanceId + "]的流程实例。");
                logger.info("已删除ID为[" + processInstanceId + "]的流程实例。");
                break;
            default:
                logger.error("操作参数异常！");
                map.put("message","操作失败！");
                map.put("status",false);
                return ResponseEntity.ok(map);
        }

        map.put("status",true);
        return ResponseEntity.ok(map);
    }
}
