package com.lds.tool.service;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface TemplateService {

    /**
     * 获取逻辑类模板
     */
    String getLogicClass(String dataSource, String tableName, List<String> checkedList);
}
