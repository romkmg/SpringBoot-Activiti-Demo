package com.example.myact.convert;

import com.example.myact.common.util.Page;

/**
 * 分页数据转换
 *
 **/
public class PageDataConvert {

    /**
     * 转换为Layui的数据格式
     * @param page
     * @param statusCode
     * @param msg
     * @return
     */
    public static final LayuiTableData convertToLayuiData(Page page, Integer statusCode, String msg) {
        LayuiTableData<Object> objectLayuiTableData = new LayuiTableData<>();
        objectLayuiTableData.setData(page.getResult());
        objectLayuiTableData.setPageNum(page.getPageNo());
        objectLayuiTableData.setPages(page.getTotalPages());
        objectLayuiTableData.setPageSize(page.getPageSize());
        objectLayuiTableData.setStatusCode(statusCode);
        objectLayuiTableData.setMsg(msg);
        objectLayuiTableData.setTotal(page.getTotalCount());
        return objectLayuiTableData;
    }

    public static final LayuiTableData convertToLayuiData(Page page) {
        LayuiTableData<Object> objectLayuiTableData = new LayuiTableData<>();
        objectLayuiTableData.setData(page.getResult());
        objectLayuiTableData.setPageNum(page.getPageNo());
        objectLayuiTableData.setPages(page.getTotalPages());
        objectLayuiTableData.setPageSize(page.getPageSize());
        objectLayuiTableData.setStatusCode(200);
        objectLayuiTableData.setMsg("获取数据成功！");
        objectLayuiTableData.setTotal(page.getTotalCount());
        return objectLayuiTableData;
    }
}
