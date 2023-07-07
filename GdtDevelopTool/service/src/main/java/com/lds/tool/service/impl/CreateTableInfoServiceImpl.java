package com.lds.tool.service.impl;

import com.lds.tool.service.CreateTableInfoService;
import com.lds.tool.service.TableInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @Describe 描述
 * @Author 作者姓名
 * @Version 版本号
 * @Date 时间
 */
@Service
public class CreateTableInfoServiceImpl implements CreateTableInfoService {

    @Autowired
    private TableInfoService getTableInfoService;

    private boolean is_first;


    /**
     * 插入表数据
     */
    @Override
    public List insertTableData() {
        List<Object> insertSqlList = new ArrayList<>();
        Map<String, List<Map<String, List<Map<String, Object>>>>> dataBaseInfo = getTableInfoService.getDataBaseData("t_department,t_job");

        dataBaseInfo.forEach((bk, bv) -> {
            bv.stream().forEach(table -> {
                //循环表
                table.forEach((tk, tv) -> {
                    StringBuffer insertSql = new StringBuffer();
                    insertSql.append("INSERT INTO " + bk + "." + tk + "(");
                    is_first = true;
                    //循环列
                    tv.stream().forEach(clo -> {
                        String keyStr = clo.keySet().stream().collect(Collectors.joining(", "));
                        String valueStr = clo.values().stream().map(value -> Optional.ofNullable(value).orElse(""))
                                .map(Object::toString).collect(Collectors.joining(", "));
                        //判断是否为首次遍历
                        if (is_first) {
                            insertSql.append(keyStr + ") VALUES(");
                            insertSql.append(valueStr + ")");
                            is_first = !is_first;
                        } else {
                            insertSql.append(",(" + valueStr + ")");
                        }
                    });
                    insertSqlList.add(insertSql.toString());
                });
            });
        });
        return insertSqlList;
    }


    /**
     * 创建表结构
     */
    @Override
    public List createTableStructure() {
        List<Object> insertSqlList = new ArrayList<>();
        Map<String, List<Map<String, List<Map<String, Object>>>>> dataBaseInfo = getTableInfoService.getDataBaseStructure();

        dataBaseInfo.forEach((bk, bv) -> {
            bv.stream().forEach(table -> {
                //循环表
                table.forEach((tk, tv) -> {
                    StringBuffer insertSql = new StringBuffer();
                    insertSql.append("CREATE TABLE " + bk + "." + tk + "(");
                    //循环列
                    tv.stream().forEach(clo -> {

                    });
                    insertSqlList.add(insertSql.toString());
                });
            });
        });
        return insertSqlList;
    }


}
