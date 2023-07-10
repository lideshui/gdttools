package com.lds.tool.service.impl;

import com.lds.tool.service.TemplateService;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.ConnectionCallback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import java.io.StringWriter;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

@Service
public class TemplateServiceImpl implements TemplateService {

    @Autowired
    private ApplicationContext applicationContext;

    @Autowired
    private Environment env;

    /**
     * 获取逻辑类模板
     */
    @Override
    public String getLogicClass(String dataSource, String tableName, List<String> checkedList) {
        String logicClassCode;
        try {
            // 构建生成逻辑类数据对象
            Map<String, Object> structureMap = new HashMap<>();
            structureMap.put("tableName", tableName);
            structureMap.put("checkedList", checkedList);

            // 查询数据表字段
            List fieldList = this.queryField(dataSource, tableName);
            structureMap.put("fieldList", fieldList);

            // 查询数据表注释
            String tableNotes = this.getTableRemark(dataSource, tableName);
            structureMap.put("tableNotes", tableNotes);

            // 生成逻辑类模板
            logicClassCode = this.generateLogicClass(structureMap);
        } catch (Exception e) {
            throw new RuntimeException("获取逻辑类模板异常,原因:" + e);
        }
        return logicClassCode;
    }

    /**
     * 查询数据表字段
     */
    private List queryField(String dataSource, String tableName) {
        List<Map> fieldList = new ArrayList<>();
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
                    // 获取字段类型
                    String columnType = columns.getString("TYPE_NAME");
                    fieldMap.put("type", columnType);
                    // 获取注释
                    String columnRemark = columns.getString("REMARKS");
                    fieldMap.put("remark", columnRemark);
                    // 获取是否为主键
                    String is_key = columnName.equals(keyName) ? "0" : "1";
                    fieldMap.put("is_key", is_key);
                    // 获取是否为公共参数
                    String is_pub = columnName.contains("pub_") ? "0" : "1";
                    fieldMap.put("is_pub", is_pub);
                    // 获取是否为逻辑删除参数
                    String is_del = columnName.contains("is_del") ? "0" : "1";
                    fieldMap.put("is_del", is_del);
                    // 合并信息
                    fieldList.add(fieldMap);
                }
                return null;
            });
        } catch (Exception e) {
            throw new RuntimeException("查询数据表字段异常,原因:" + e);
        }
        return fieldList;
    }

    /**
     * 查询数据表注释
     */
    private String getTableRemark(String dataSource, String tableName) {
        JdbcTemplate jdbcTemplate;
        AtomicReference<String> tableRemark = new AtomicReference<>("");
        try {
            jdbcTemplate = applicationContext.getBean(dataSource, JdbcTemplate.class);
            jdbcTemplate.execute((ConnectionCallback<Object>) connection -> {
                DatabaseMetaData metaData = connection.getMetaData();
                ResultSet resultSet = metaData.getTables(dataSource, null, tableName, new String[]{"TABLE"});
                if (resultSet.next()) {
                    tableRemark.set(resultSet.getString("REMARKS")); // 获取表注释
                }
                return null;
            });
        } catch (Exception e) {
            throw new RuntimeException("查询数据表注释异常,原因:" + e);
        }
        return tableRemark.get();
    }

    /**
     * 生成逻辑类模板
     */
    private String generateLogicClass(Map structureMap) {
        String logicClassCode;
        try {
            // 加载模板配置
            Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
            cfg.setDefaultEncoding("UTF-8");

            // 指定模板文件的加载方式
            cfg.setClassForTemplateLoading(getClass(), "/javaTemplate/");

            // 读取模板文件
            Template template = cfg.getTemplate("logicClassTemplate.ftl");

            // 获取当前时间
            String currDate = this.getCurrDate();

            // 获取字段信息 业务bus 公共pub 全部all 占位符symbol
            Map<String, StringBuilder> fieldMap = this.getField((List)structureMap.get("fieldList"));

            // 准备要填充的数据
            // 模板基础数据
            Map<String, Object> data = new HashMap<>();
            data.put("description", structureMap.get("tableNotes")); //注释-类描述
            data.put("author", env.getProperty("template.author")); //注释-作者
            data.put("version", env.getProperty("template.version")); //注释-版本
            data.put("date", currDate); //注释-创建时间
            data.put("package", env.getProperty("template.package") + this.getFirstWord(String.valueOf(structureMap.get("tableName")))); //包名
            data.put("className", this.toCamelCase(String.valueOf(structureMap.get("tableName")))); //驼峰类名
            data.put("fields", structureMap.get("fieldList")); //属性列表
            data.put("tableName", structureMap.get("tableName")); //表名
            data.put("fieldMap", fieldMap); //字段信息 业务bus 公共pub 全部all 占位符symbol
            data.put("checkedList", structureMap.get("checkedList")); //已选择生成方法的列表

            // 将模板和数据合并，生成目标文本
            StringWriter out = new StringWriter();
            template.process(data, out);
            logicClassCode = out.toString();
        } catch (Exception e) {
            throw new RuntimeException("生成逻辑类模板异常,原因:" + e);
        }
        return logicClassCode;
    }

    /**
     * 将表名转换为大驼峰的形式
     */
    private String toCamelCase(String tableName) {
        String[] words = tableName.split("[_\\s]+");
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < words.length; i++) {
            String word = words[i];
            if (!word.isEmpty()) {
                // 如果是hg，则不进行大驼峰转换
                if ("hg".equals(word)) {
                    continue;
                }
                result.append(word.substring(0, 1).toUpperCase()).append(word.substring(1));
            }
        }
        return result.toString();
    }

    /**
     * 将表名首字母取出作为包名
     */
    private String getFirstWord(String tableName) {
        String[] words = tableName.split("[_\\s]+");
        String packageSuffix = "";
        // 如果第一个单词是以两个字母加下划线开头的形式，则取第二个单词作为首个单词
        if (words.length > 1 && words[0].length() == 2 && words[0].charAt(1) == '_') {
            packageSuffix =  words[1];
        } else {
            packageSuffix =  words[0];
        }
        packageSuffix = packageSuffix.isEmpty() ? packageSuffix : "." + packageSuffix;
        return packageSuffix;
    }

    /**
     * 获取业务字段公共字段全字段和占位符
     */
    private Map<String, StringBuilder> getField(List filedList) {
        Map<String, StringBuilder> fieldMap = new HashMap<>();
        // 业务字段
        StringBuilder busFields = new StringBuilder();
        // 公共字段
        StringBuilder pubFields = new StringBuilder();
        // 全字段
        StringBuilder allFields = new StringBuilder();
        // 占位符
        StringBuilder symbols = new StringBuilder();
        // 业务字段修改
        StringBuilder busEditFields = new StringBuilder();
        // 公共字段修改
        StringBuilder pubEditFields = new StringBuilder();

        for (Map<String, Object> map : (List<Map<String, Object>>)filedList) {
            String filed = String.valueOf(map.get("name")); // 获取字段名
            // 拼接占位符
            if (symbols.length() > 0) {
                symbols.append(", ");
            }
            symbols.append("?");

            // 拼接全字段
            if (allFields.length() > 0) {
                allFields.append(", ");
            }
            allFields.append(filed);

            // 拼接公共字段和逻辑删除字段
            if("0".equals(map.get("is_pub")) || "0".equals(map.get("is_del"))) {
                if (pubFields.length() > 0) {
                    pubFields.append(", ");
                }
                pubFields.append(filed);
            }

            // 拼接业务字段
            if("1".equals(map.get("is_pub")) && "1".equals(map.get("is_del"))) {
                if (busFields.length() > 0) {
                    busFields.append(", ");
                }
                busFields.append(filed);
            }

            // 拼接公共修改字段
            if("0".equals(map.get("is_pub")) && filed.contains("modified")) {
                if (pubEditFields.length() > 0) {
                    pubEditFields.append(", ");
                }
                pubEditFields.append(filed + " = ?");
            }
            // 拼接业务修改字段
            if("1".equals(map.get("is_key")) && "1".equals(map.get("is_pub")) && "1".equals(map.get("is_del"))) {
                if (busEditFields.length() > 0) {
                    busEditFields.append(", ");
                }
                busEditFields.append(filed + " = ?");
            }
        }
        fieldMap.put("bus", busFields);
        fieldMap.put("pub", pubFields);
        fieldMap.put("all", allFields);
        fieldMap.put("symbol", symbols);
        fieldMap.put("edit_bus", busEditFields);
        fieldMap.put("edit_pub", pubEditFields);
        return fieldMap;
    }
    

    /**
     * 获取当前时间
     */
    private String getCurrDate(){
        // 获取当前时间
        LocalDateTime currentDateTime = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String currDate = currentDateTime.format(formatter);
        return currDate;
    }

}
