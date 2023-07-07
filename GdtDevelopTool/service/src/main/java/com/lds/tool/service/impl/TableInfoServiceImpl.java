package com.lds.tool.service.impl;

import com.lds.tool.service.TableInfoService;
import com.mysql.cj.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.*;


@Service
public class TableInfoServiceImpl implements TableInfoService {

    @Autowired
    @Qualifier("pipe_hggl")
    private JdbcTemplate jdbcTemplate2;

    private final String charArr[] = {"DATE", "VARCHAR", "CHAR", "BINARY", "TIME", "DATETIME", "TIMESTAMP", "TINYTEXT", "TEXT", "MEDIUMTEXT",
            "LONGTEXT", "BLOB", "MEDIUMBLOB", "LONGBLOB", "ENUM"};


    /**
     * 获取表结构
     */
    @Override
    public Map getDataBaseStructure(){

        Map<String, List> dataBaseInfo = new HashMap<>();
        List<Map> dataBaseList = new ArrayList<>();
        String databaseName = null;

        try {
            //1获取数据库名
            databaseName = Objects.requireNonNull(jdbcTemplate2.getDataSource()).getConnection().getCatalog();
            dataBaseInfo.put(databaseName, dataBaseList);

            //2获取表结构
            jdbcTemplate2.execute((Connection connection) -> {
                DatabaseMetaData metadata = connection.getMetaData();
                ResultSet tableNames = metadata.getTables(null, null, "%", new String[] {"TABLE"});
                while (tableNames.next()) {
                    Map<String, List> tableInfo = new HashMap<>();
                    List<Map> columnList = new ArrayList<>();
                    //2.1获取表名
                    String tableName = tableNames.getString("TABLE_NAME");
                    tableInfo.put(tableName, columnList);
                    //2.2获取主键
                    ResultSet pKeys = metadata.getPrimaryKeys(null, null, tableName);
                    String keyName = "";
                    while (pKeys.next()) {
                        keyName = pKeys.getString("COLUMN_NAME");
                    }
                    //2.3获取列属性
                    ResultSet columns = metadata.getColumns(null, null, tableName, null);
                    while (columns.next()) {
                        Map<String, Object> columnInfo = new HashMap<>();
                        ResultSetMetaData rsmd = columns.getMetaData();
                        /**
                         * TABLE_CAT: 表所在的数据库名称。
                         * TABLE_NAME: 所属表的名称。
                         * COLUMN_NAME: 列的名称。
                         * DATA_TYPE: 列的数据类型代码，对应 java.sql.Types 中的常量值。
                         * TYPE_NAME: 列的数据类型名称。
                         * COLUMN_SIZE: 列的数据类型大小。
                         * BUFFER_LENGTH: 从序列化对象中读取该列数据需要的缓冲区长度（仅用于二进制数据类型）。
                         * DECIMAL_DIGITS: 数值型、十进制型或货币型列的小数部分的位数。对于其他类型的数据列，返回 null。
                         * NUM_PREC_RADIX: 这个指定了值的精度。（即数字中的位数）。对于其他类型的数据列，返回 null。
                         * NULLABLE: 列是否允许为空，0 表示不允许，1 表示允许。
                         * IS_NULLABLE: 列是否允许为空，"NO" 表示不允许，"YES" 表示允许。
                         * COLUMN_DEF: 默认值，如果该列没有默认值，则返回 null。
                         * SQL_DATA_TYPE: 对于UDT，ElementType或DistinctType，它是源数据类型的SQL类型；对于其他数据类型，返回null。
                         * SQL_DATETIME_SUB: 如果该字段为 dateTime，则返回此日期和时间分量的最大精度。对于其他数据类型，返回 null。
                         * CHAR_OCTET_LENGTH: 对于字符数据类型，这是列中 char 值的最大长度（以字节为单位）；对于二进制数据类型，这是列中的最大字节数。对于其他数据类型，返回 null。
                         * ORDINAL_POSITION: 列在表中的顺序。
                         * IS_AUTOINCREMENT: 列是否自动递增，"YES" 表示是，"NO" 表示否。
                         * IS_GENERATEDCOLUMN: 列是否生成，"YES" 表示是，"NO" 表示否。
                         * SCOPE_CATALOG, SCOPE_SCHEMA, SCOPE_TABLE, SOURCE_DATA_TYPE：仅用于 UDT（用户定义类型），返回 null。
                         */
                        for (int columnIndex = 1; columnIndex <= rsmd.getColumnCount(); columnIndex++) {
                            String columnName = rsmd.getColumnName(columnIndex);
                            Object value = columns.getObject(columnIndex);
                            columnInfo.put(columnName, value);
                        }
                        //汇总每列属性数据
                        columnList.add(columnInfo);
                    }
                    //汇总表结构数据
                    dataBaseList.add(tableInfo);
                }
                return null;
            });
        } catch (SQLException e) {
            throw new RuntimeException("获取表结构异常,原因:" + e);
        }
        return dataBaseInfo;
    }


    /**
     * 获取表数据
     */
    @Override
    public Map getDataBaseData(String tableNames) {

        Map<String, List> dataBaseInfo = new HashMap<>();
        List<Map> dataBaseList = new ArrayList<>();
        String databaseName = null;

        try {
            //1获取数据库名
            databaseName = Objects.requireNonNull(jdbcTemplate2.getDataSource()).getConnection().getCatalog();
            dataBaseInfo.put(databaseName, dataBaseList);

            //2获取表值
            jdbcTemplate2.execute((Connection connection) -> {
                DatabaseMetaData metadata = connection.getMetaData();
                ResultSet tables = metadata.getTables(null, null, "%", new String[]{"TABLE"});
                while (tables.next()) {
                    Map<String, List> tableInfo = new HashMap<>();
                    List<Map> columnList = new ArrayList<>();
                    //2.1获取表名
                    String tableName = tables.getString("TABLE_NAME");
                    if(!StringUtils.isNullOrEmpty(tableNames) && !Arrays.asList(tableNames.split(",")).contains(tableName)){
                        continue;
                    }
                    tableInfo.put(tableName, columnList);
                    //2.2获取表数据
                    Statement statement = connection.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM " + tableName);
                    while (rs.next()) {
                        Map<String, Object> columnInfo = new HashMap<>();
                        ResultSetMetaData rsmd = rs.getMetaData();
                        for (int columnIndex = 1; columnIndex <= rsmd.getColumnCount(); columnIndex++) {
                            String columnName = rsmd.getColumnName(columnIndex);
                            //根据类型拼接单引号
                            String columnTypeName = rsmd.getColumnTypeName(columnIndex);
                            boolean isInArray = Arrays.asList(charArr).contains(columnTypeName);
                            Object value = null;
                            if(isInArray){
                                switch (columnTypeName) {
                                    case "BLOB" :
                                        value = "'" + rs.getObject(columnIndex) + "'";
                                        break;
                                    case "CLOB" :
                                        value = "'" + rs.getObject(columnIndex) + "'";
                                        break;
                                    default:
                                        value = "'" + rs.getObject(columnIndex) + "'";
                                };
                            }else {
                                value = rs.getObject(columnIndex);
                            }
                            columnInfo.put(columnName, value);
                        }
                        //汇总每列值
                        columnList.add(columnInfo);
                    }
                    //汇总全表数据
                    dataBaseList.add(tableInfo);
                    rs.close();
                    statement.close();
                }
                return null;
            });


        } catch (SQLException e) {
            throw new RuntimeException("获取表数据异常,原因:" + e);
        }

        return dataBaseInfo;
    }





    @Autowired
    private ApplicationContext applicationContext;

    /**
     * 获取数据源列表
     */
    @Override
    public List getDataSource() {
        List<String> dataSourceList;

        try {
            String[] dataSourceNames = applicationContext.getBeanNamesForType(JdbcTemplate.class);
            dataSourceList = Arrays.asList(dataSourceNames);
        } catch (Exception e) {
            throw new RuntimeException("获取数据源列表异常,原因:" + e);
        }
        return dataSourceList;
    }

    /**
     * 获取表名列表
     */
    public List getTableList(String dataSource) {
        List<String> tableList = new ArrayList<>();
        JdbcTemplate jdbcTemplate;
        try {
            jdbcTemplate = applicationContext.getBean(dataSource, JdbcTemplate.class);
            jdbcTemplate.execute((Connection connection) -> {
                DatabaseMetaData metadata = connection.getMetaData();
                ResultSet tableNames = metadata.getTables(dataSource, null, "%", new String[] {"TABLE"});
                while (tableNames.next()) {
                    //获取表名
                    String tableName = tableNames.getString("TABLE_NAME");
                    tableList.add(tableName);
                }
                return null;
            });
        } catch (Exception e) {
            throw new RuntimeException("获取表名列表异常,原因:" + e);
        }
        return tableList;
    }


}
