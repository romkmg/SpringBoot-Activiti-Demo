package com.example.myact.common.model;

public class DeploymentModel {

    private String processName;
    private String processDescriptor;
    private String processVariables;

    public String getProcessName() {
        return processName;
    }

    public void setProcessName(String processName) {
        this.processName = processName;
    }

    public String getProcessDescriptor() {
        return processDescriptor;
    }

    public void setProcessDescriptor(String processDescriptor) {
        this.processDescriptor = processDescriptor;
    }

    public String getProcessVariables() {
        return processVariables;
    }

    public void setProcessVariables(String processVariables) {
        this.processVariables = processVariables;
    }

    @Override
    public String toString() {
        return "Deployment [processName=" + processName + ", processDescriptor=" + processDescriptor + ", processVariables=" + processVariables + "]";
    }

}