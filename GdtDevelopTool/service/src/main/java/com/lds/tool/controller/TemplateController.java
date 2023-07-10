package com.lds.tool.controller;

import com.lds.tool.service.TemplateService;
import com.lds.tool.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/template/")
public class TemplateController {

    @Autowired
    TemplateService templateService;

    /**
     * 获取逻辑类模板
     */
    @PostMapping("/logic")
    public Result getLogicClass(@RequestParam String dataSource, @RequestParam String tableName, @RequestParam String checkedItems) {
        List<String> checkedList = Arrays.asList(checkedItems.split(","));
        String logicClassCode = templateService.getLogicClass(dataSource, tableName, checkedList);
        return Result.ok(logicClassCode);
    }

}
