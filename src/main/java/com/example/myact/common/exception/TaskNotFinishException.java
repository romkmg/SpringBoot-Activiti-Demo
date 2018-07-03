package com.example.myact.common.exception;

/**
 *
 * @Author @MG
 * @Date 2018/7/3 15:59
 */
public class TaskNotFinishException extends RuntimeException{

    private static final long serialVersionUID = 2758511855067937404L;

    public TaskNotFinishException() {
        super();
        // TODO Auto-generated constructor stub
    }

    public TaskNotFinishException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
        // TODO Auto-generated constructor stub
    }

    public TaskNotFinishException(String message, Throwable cause) {
        super(message, cause);
        // TODO Auto-generated constructor stub
    }

    public TaskNotFinishException(String message) {
        super(message);
        // TODO Auto-generated constructor stub
    }

    public TaskNotFinishException(Throwable cause) {
        super(cause);
        // TODO Auto-generated constructor stub
    }

}