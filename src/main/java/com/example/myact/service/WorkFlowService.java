package com.example.myact.service;

import com.example.myact.common.util.Page;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.runtime.ProcessInstance;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

public interface WorkFlowService {

    /****
     * 发起流程
     *
     * @param processDefinitionKey
     */
    void startProcessInstanceByKey(String userId, String processDefinitionKey);

    /****
     * 发起流程
     *
     * @param processDefinitionKey
     * @param processBusinessKey
     */
    void startProcessInstanceByKey(String userId, String processDefinitionKey, String processBusinessKey);

    /****
     * 发起流程
     *
     * @param processDefinitionKey
     * @param processBusinessKey
     * @param variables
     */
    void startProcessInstanceByKey(String userId, String processDefinitionKey, String processBusinessKey, Map<String, Object> variables);

    /****
     * 发送信号
     *
     * @param signalName
     * @param executionId
     */
    void signalEventReceived(String signalName, String executionId);

    /****
     *
     * @param processInstanceId
     * @param closeReason
     */
    public void deleteProcessInstance(String processInstanceId, String closeReason);

    /****
     * 定时任务分页查询
     *
     * @param page
     * @return
     */
    Page pagingJob(Page page);

    /***
     * 执行任务
     *
     * @param id
     */
    void executeJob(String id);

    /****
     * 流程定义分页
     * @param page
     * @return
     */
    Page pagingProcessDefinition(Page page);

    /****
     * 部署流程文件
     * @param fileName
     * @param inputStream
     */
    void deploy(String fileName, InputStream inputStream);

    /****
     * 获取活动节点
     * @param processInstanceId
     * @return
     */
    List<ActivityImpl> getActivityListByProcessInstanceId(String processInstanceId);

    ProcessInstance getProcessInstance(String processInstanceId);

    void logWorkFlowInfo(String msg);

}
