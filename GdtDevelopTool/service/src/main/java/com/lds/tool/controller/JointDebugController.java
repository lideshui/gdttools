package com.lds.tool.controller;

import com.lds.tool.service.JointDebugService;
import com.lds.tool.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/joint")
public class JointDebugController {

    @Autowired
    JointDebugService jointDebugService;

    /**
     * 获取联调数据
     */
    @GetMapping("/data")
    public Result getLogicClass(@RequestParam String dataSource, @RequestParam String tableName, @RequestParam String checkedItems) {
        Map jointDebugData = jointDebugService.jointDebugData(dataSource, tableName, checkedItems);
        return Result.ok(jointDebugData);
    }

}
