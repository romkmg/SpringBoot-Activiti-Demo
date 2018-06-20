package com.example.myact.service;

import java.util.List;
import java.util.Map;

public interface WorkflowTraceService {

    /**
     * 流程跟踪图
     *
     * @param processInstanceId 流程实例ID
     * @return 封装了各种节点信息
     */
    List<Map<String, Object>> traceProcess(String processInstanceId) throws Exception;
}
