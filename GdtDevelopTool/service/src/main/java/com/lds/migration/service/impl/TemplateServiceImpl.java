package com.lds.migration.service.impl;

import com.lds.migration.service.TemplateService;
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
    public String getLogicClass(String dataSource, String tableName) {
        String logicClassCode;
        try {
            // 查询数据表字段
            List fieldList = this.queryField(dataSource, tableName);

            // 查询数据表注释
            String tableNotes = this.getTableRemark(dataSource, tableName);

            // 生成逻辑类模板
            logicClassCode = this.generateLogicClass(tableName, tableNotes, fieldList);
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
                // 获取字段的名称值和类型
                ResultSet columns = metadata.getColumns(null, null, tableName, "%");
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
                    // 是否为公共字段 1是0否
                    if (columnName.startsWith("pub_") || columnName.startsWith("is_delete")){
                        fieldMap.put("is_pub", "1");
                    } else {
                        fieldMap.put("is_pub", "0");
                    }
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
                ResultSet resultSet = metaData.getTables(null, null, tableName, new String[]{"TABLE"});
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
    private String generateLogicClass(String tableName, String tableNotes, List fieldList) {
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
            Map<String, StringBuilder> fieldMap = this.getField(fieldList);

            // 准备要填充的数据
            Map<String, Object> data = new HashMap<>();
            data.put("description", tableNotes); //注释-类描述
            data.put("author", env.getProperty("template.author")); //注释-作者
            data.put("version", env.getProperty("template.version")); //注释-版本
            data.put("date", currDate); //注释-创建时间
            data.put("package", env.getProperty("template.package") + this.getFirstWord(tableName)); //包名
            data.put("className", this.toCamelCase(tableName)); //驼峰类名
            data.put("fields", fieldList); //属性列表
            data.put("tableName", tableName); //表名
            data.put("fieldMap", fieldMap); //字段信息 业务bus 公共pub 全部all 占位符symbol





            data.put("imports", new String[]{"java.util.List"});

            data.put("methods", new String[]{
                    "public int getId() { return id; }",
                    "public void setId(int id) { this.id = id; }",
                    "public String getName() { return name; }",
                    "public void setName(String name) { this.name = name; }"
            });

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

        for (Map<String, Object> map : (List<Map<String, Object>>)filedList) {
            Object value = map.get("name"); // key为您想要获取的值对应的键名

            if (value != null) {
                String valueString = value.toString();
                // 拼接占位符
                if (symbols.length() > 0) {
                    symbols.append(", ");
                }
                symbols.append("?");
                // 拼接全字段
                if (allFields.length() > 0) {
                    allFields.append(",");
                }
                allFields.append(valueString);
                // 拼接公共字段
                if (valueString.startsWith("pub_") || valueString.startsWith("is_delete")) {
                    if (pubFields.length() > 0) {
                        pubFields.append(", ");
                    }
                    pubFields.append(valueString);
                } else {
                    // 拼接业务字段
                    if (busFields.length() > 0) {
                        busFields.append(", ");
                    }
                    busFields.append(valueString);
                }
            }
        }
        fieldMap.put("bus", busFields);
        fieldMap.put("pub", pubFields);
        fieldMap.put("all", allFields);
        fieldMap.put("symbol", symbols);
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
