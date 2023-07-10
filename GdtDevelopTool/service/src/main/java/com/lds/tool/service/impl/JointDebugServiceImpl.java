package com.lds.tool.service.impl;

import com.lds.tool.service.JointDebugService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import java.sql.*;
import java.util.*;

@Service
public class JointDebugServiceImpl implements JointDebugService {

    @Autowired
    private ApplicationContext applicationContext;

    @Autowired
    private Environment env;

    /**
     * 获取联调数据
     */
    @Override
    public Map jointDebugData(String dataSource, String tableName, String checkedItems) {
        Map<Object, Object> resultMap = new HashMap<>();
        if ("联调数据".equals(checkedItems)) {
            // 获取连调数据
            resultMap = this.getJointDebugData(dataSource, tableName);
        }else {
            // 传参字段
            resultMap = this.getArgFiled(dataSource, tableName);
        }
        return resultMap;
    }

    /**
     * 获取连调数据
     */
    private Map getJointDebugData(String dataSource, String tableName) {
        Map<Object, Object> tableData = new HashMap<>();
        List tableDataList = new ArrayList<>();
        List tableHearList = new ArrayList<>();
        tableData.put("data",tableDataList);
        tableData.put("head",tableHearList);
        JdbcTemplate jdbcTemplate;
        try {
            jdbcTemplate = applicationContext.getBean(dataSource, JdbcTemplate.class);
            jdbcTemplate.execute((Connection connection) -> {
                DatabaseMetaData metadata = connection.getMetaData();
                //获取表头
                ResultSet columns = metadata.getColumns(dataSource, null, tableName, null);
                while (columns.next()) {
                    Map<String, Object> filedMap = new HashMap<>();
                    String columnName = columns.getString("COLUMN_NAME");
                    String columnComment = columns.getString("REMARKS");
                    // 将字段名和注释保存到Map或其他数据结构中
                    filedMap.put("prop",columnName);
                    filedMap.put("label",columnComment);
                    tableHearList.add(filedMap);
                }
                //获取数据
                Statement statement = connection.createStatement();
                ResultSet rs = statement.executeQuery("SELECT * FROM " + tableName + " LIMIT 15  ");
                while (rs.next()) {
                    Map<String, Object> columnInfo = new HashMap<>();
                    ResultSetMetaData rsmd = rs.getMetaData();
                    for (int columnIndex = 1; columnIndex <= rsmd.getColumnCount(); columnIndex++) {
                        String columnName = rsmd.getColumnName(columnIndex);
                        Object value = rs.getObject(columnIndex);
                        columnInfo.put(columnName, value);
                    }
                    //汇总每列值
                    tableDataList.add(columnInfo);
                }
                rs.close();
                statement.close();
                return null;
            });
        } catch (Exception e) {
            throw new RuntimeException("获取连调数据异常,原因:" + e);
        }
        return tableData;
    }

    /**
     * 获取连调数据
     */
    private Map getArgFiled(String dataSource, String tableName) {
        Map<Object, Object> tableData = new HashMap<>();
        List tableDataList = new ArrayList<>();
        List tableHearList = new ArrayList<>();
        tableData.put("data",tableDataList);
        tableData.put("head",tableHearList);
        JdbcTemplate jdbcTemplate;
        try {
            jdbcTemplate = applicationContext.getBean(dataSource, JdbcTemplate.class);
            jdbcTemplate.execute((Connection connection) -> {
                DatabaseMetaData metadata = connection.getMetaData();
                // 获取主键
                ResultSet pKeys = metadata.getPrimaryKeys(dataSource, null, tableName);
                String keyName = "";
                while (pKeys.next()) {
                    keyName = pKeys.getString("COLUMN_NAME");
                }
                // 获取字段的名称值和类型
                ResultSet columns = metadata.getColumns(dataSource, null, tableName, "%");
                while (columns.next()) {
                    Map<String, String> fieldMap = new HashMap<>();
                    // 获取字段名
                    String columnName = columns.getString("COLUMN_NAME");
                    fieldMap.put("name", columnName);
                    // 获取注释
                    String columnRemark = columns.getString("REMARKS");
                    fieldMap.put("remark", columnRemark);
                    // 获取字段类型
                    String columnType = columns.getString("TYPE_NAME");
                    fieldMap.put("type", columnType);
                    // 字段长度
                    String length = columns.getString("COLUMN_SIZE");
                    fieldMap.put("length", length);
                    // 字段小数位数
                    String digits = columns.getString("DECIMAL_DIGITS");
                    fieldMap.put("digits", digits);
                    // 是否允许为空
                    String isNull = columns.getString("IS_NULLABLE");
                    fieldMap.put("isNull", isNull);
                    // 默认值
                    String def = columns.getString("COLUMN_DEF");
                    fieldMap.put("def", def);
                    // 接口参数类型
                    fieldMap.put("api", "新增,修改,查询条件");
                    // 修改接口参数类型
                    if(columnType.contains("DATE")){
                        fieldMap.put("api", "新增,修改");
                        // 开始时间，深拷贝
                        Map<String, String> startMap = new HashMap<>();
                        startMap.putAll(fieldMap);
                        startMap.put("name", columnName+"_start");
                        startMap.put("api", "查询条件");
                        startMap.put("remark", columnRemark+"开始时间");
                        tableDataList.add(startMap);
                        // 结束时间，深拷贝
                        Map<String, String> endMap = new HashMap<>();
                        endMap.putAll(fieldMap);
                        endMap.put("name", columnName+"_end");
                        endMap.put("api", "查询条件");
                        endMap.put("remark", columnRemark+"结束时间");
                        tableDataList.add(endMap);
                    }
                    // 合并信息
                    tableDataList.add(fieldMap);
                }
                // 获取表头
                String[] headFiled = {"name", "type", "remark", "api", "length", "digits", "isNull", "def"};
                String[] headInfo = {"字段名称", "字段类型", "字段注释", "接口传参类型", "字段长度", "小数点位数", "是否可以为空", "默认值"};
                for (int i = 0; i < headFiled.length; i++) {
                    Map<String, Object> headMap = new HashMap<>();
                    // 将字段名和注释保存到Map或其他数据结构中
                    headMap.put("prop",headFiled[i]);
                    headMap.put("label",headInfo[i]);
                    tableHearList.add(headMap);
                }
                return null;
            });
        } catch (Exception e) {
            throw new RuntimeException("获取连调数据异常,原因:" + e);
        }
        return tableData;
    }
}
