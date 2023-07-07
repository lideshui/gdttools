package com.lds.tool.controller;

import com.lds.tool.service.TemplateService;
import com.lds.tool.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/template/")
public class TemplateController {

    @Autowired
    TemplateService templateService;

    /**
     * 获取逻辑类模板
     */
    @GetMapping("/logic")
    public Result getLogicClass(@RequestParam String dataSource, @RequestParam String tableName) {
        String logicClassCode = templateService.getLogicClass(dataSource, tableName);
        return Result.ok(logicClassCode);
    }

}
