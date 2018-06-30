package com.example.myact.convert;

import java.io.Serializable;
import java.util.List;

/**
 * Layui表格数据类型
 *
 **/
public class LayuiTableData<T> implements Serializable{
    /**
     * 响应状态
     */
    private Integer statusCode;
    /**
     * 总数据量
     */
    private Long total;
    /**
     * 数据列表
     */
    private List<T> data;
    /**
     * 当前页面
     */
    private int pageNum;
    /**
     * 页面大小
     */
    private int pageSize;
    /**
     * 总页数
     */
    private Long pages;

    /**
     * 状态消息
     */
    private String msg;

    public Integer getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(Integer statusCode) {
        this.statusCode = statusCode;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    public List<T> getData() {
        return data;
    }

    public void setData(List<T> data) {
        this.data = data;
    }

    public int getPageNum() {
        return pageNum;
    }

    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public Long getPages() {
        return pages;
    }

    public void setPages(Long pages) {
        this.pages = pages;
    }
}
