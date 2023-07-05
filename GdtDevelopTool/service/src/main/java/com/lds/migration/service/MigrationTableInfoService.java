package com.lds.migration.service;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface MigrationTableInfoService {
    /**
     * 迁移表数据
     */
    public boolean migrationTableData();

}
