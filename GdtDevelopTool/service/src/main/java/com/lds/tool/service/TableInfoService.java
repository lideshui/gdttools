package com.lds.tool.service;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface TableInfoService {
    /**
     * 获取表结构
     */
    public Map getDataBaseStructure();

    /**
     * 获取表数据
     */
    public Map getDataBaseData(String tableNames);








    /**
     * 获取数据源列表
     */
    List getDataSource();

    /**
     * 获取表名称列表
     */
    List getTableList(String dataSource);
}
