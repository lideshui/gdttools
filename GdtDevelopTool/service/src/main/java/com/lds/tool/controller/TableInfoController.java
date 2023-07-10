package com.lds.tool.controller;

import com.lds.tool.service.CreateTableInfoService;
import com.lds.tool.service.TableInfoService;
import com.lds.tool.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;


@RestController
@RequestMapping("/table")

public class TableInfoController {

    @Autowired
    private TableInfoService tableInfoService;

    @Autowired
    private CreateTableInfoService createTableInfoService;

    @Autowired
    @Qualifier("pipe_hggl")
    private JdbcTemplate jdbcTemplate;


    /**
     * 获取表数据
     */
    @GetMapping("/data")
    public Result getDataBaseData() {
        Map dataBaseData = tableInfoService.getDataBaseData(null);
        return Result.ok(dataBaseData);
    }

    /**
     * 获取表结构
     */
    @GetMapping("/str")
    public Result getDataBaseStructure(){
        Map dataBaseStructure = tableInfoService.getDataBaseStructure();
        return Result.ok(dataBaseStructure);
    }

    /**
     * 插入表数据
     */
    @GetMapping("/insert")
    public Result insertDataBaseInfo() {
        List list = createTableInfoService.insertTableData();
        return Result.ok(list);
    }


    /**
     * 创建表数据
     */
    @GetMapping("/create")
    public Result createTableStructure() {
        List list = createTableInfoService.createTableStructure();
        return Result.ok(list);
    }


    /**
     * 表数据迁移
     */
    @GetMapping("/migration")
    public Result migrationTable(String tableNames) {
        List list = createTableInfoService.createTableStructure();
        return Result.ok(tableNames);
    }


    /**
     * 获取数据源列表
     */
    @GetMapping("/datasource")
    public Result getDataSource() {
        List dataSourceList = tableInfoService.getDataSource();
        return Result.ok(dataSourceList);
    }

    /**
     * 获取表名称列表
     */
    @GetMapping("/tables")
    public Result getTableList(@RequestParam String dataSource) {
        List tablesList = tableInfoService.getTableList(dataSource);
        return Result.ok(tablesList);
    }


}
