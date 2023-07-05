package com.lds.migration.service;

import org.springframework.stereotype.Service;
import java.util.List;

@Service
public interface CreateTableInfoService {
    /**
     * 插入表数据
     */
    public List insertTableData();

    /**
     * 创建表结构
     */
    public List createTableStructure();

}
