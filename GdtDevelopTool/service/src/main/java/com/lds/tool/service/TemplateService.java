package com.lds.tool.service;

import org.springframework.stereotype.Service;

@Service
public interface TemplateService {

    /**
     * 获取逻辑类模板
     */
    String getLogicClass(String dataSource, String tableName);
}
