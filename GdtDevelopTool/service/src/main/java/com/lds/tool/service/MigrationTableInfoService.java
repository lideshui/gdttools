package com.lds.tool.service;

import org.springframework.stereotype.Service;

@Service
public interface MigrationTableInfoService {
    /**
     * 迁移表数据
     */
    public boolean migrationTableData();

}
