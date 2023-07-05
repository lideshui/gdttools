package com.lds.migration.service;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

@Service
public interface TemplateService {

    /**
     * 获取逻辑类模板
     */
    String getLogicClass(String dataSource, String tableName);
}
