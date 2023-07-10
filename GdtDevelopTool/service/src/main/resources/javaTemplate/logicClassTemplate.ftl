<#--<#if package?has_content>-->
<#--package ${package};-->
<#--</#if>-->

<#--<#list imports as imp>-->
<#--    //12非常丰富-->
<#--    /**-->
<#--    * @Author-->
<#--    *-->
<#--    */-->
<#--import ${imp};-->
<#--</#list>-->

<#--public class ${className} {-->

<#--private void(String name){-->
<#--return "";-->
<#--}-->
<#--<#list fields as field>-->
<#--    ${field}-->
<#--</#list>-->

<#--<#list methods as method>-->
<#--    ${method}-->
<#--</#list>-->
<#--}-->


package ${package};

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sgitg.developer.annotation.data.QueryBean;
import com.sgitg.developer.annotation.data.ResponseResult;
import com.sgitg.developer.annotation.data.ResponseResultOpe.FormatType;
import com.sgitg.developer.backend.javaparse.imp.DataServiceTemplateJavaParse;
import com.sgitg.developer.backend.sqlparse.BackEndDataBean;
import com.sgitg.developer.configure.bean.IConfigData;
import com.sgitg.developer.dao.IBaseDao;
import com.sgitg.developer.log.PubLog;
import com.sgitg.developer.log.util.LogConstant.LoggerLevel;
import com.sgitg.developer.util.Guid;
import com.sgitg.hggl.util.JSONArray;

/**
 * @Description ${description}逻辑类
 * @Author ${author}
 * @Version ${version}
 * @Date ${date}
 */
@SuppressWarnings("unchecked")
public class ${className} extends DataServiceTemplateJavaParse {

    /**
     * @Description 默认方法
     */
    @Override
    public void defaultMethod(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                              QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
    }


    /**
     * @Description 接口方法:数据新增业务接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回数据新增接口是否成功新增数据的提示信息
     */
    public void createMethod(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                             QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 定义新增接口返回提示信息对象
        JSONObject resultJson = new JSONObject();

        // 执行新增数据库操作
        resultJson = this.insertMethod(queryBean, baseDao, pfDao);

        // 设置接口返回结果
        result.setFormatType(FormatType.MESSAGE);
        result.setMessage(JSON.toJSONString(resultJson));
    }
    <#list checkedList as checked>
    <#if checked == '新增方法'>


    /**
     * @Description 新增操作
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回新增数据的提示信息
     */
    private JSONObject insertMethod(QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao){
        // 定义数据库新增是否成功提示信息对象
        JSONObject resultJson = new JSONObject();

        // 获取系统参数
        String other_id = queryBean.getArgValue("other_id"); //当前登录人id
        String other_user_name = queryBean.getArgValue("other_user_name"); //当前登录人名称
        String other_busorg_id = queryBean.getArgValue("other_busorg_id"); //当前登录人单位id
        String other_orgname = queryBean.getArgValue("other_orgname"); //当前登录人单位名称

        // 获取业务参数
        // 请求参数
        <#list fields as field>
        <#if field.is_key == '0'>
        String ${field.name!''} = Guid.create(); //${field.remark!''}
        <#elseif field.is_pub == "1" && field.is_key == "1" && field.is_del == "1">
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        </#if>
        </#list>
        // 公共参数
        <#list fields as field>
        <#if field.is_pub == '0'>
        <#--create-->
        <#if field.name == 'pub_create_id'>
        String ${field.name} = other_id; //${field.remark!''}
        <#elseif field.name == 'pub_create_name'>
        String ${field.name} = other_user_name; //${field.remark!''}
        <#elseif field.name == 'pub_create_time'>
        String ${field.name} = this.getCurrDate(); //${field.remark!''}
        <#elseif field.name == 'pub_create_comp'>
        String ${field.name} = other_busorg_id; //${field.remark!''}
        <#elseif field.name == 'pub_comp_name'>
        String ${field.name} = other_orgname; //${field.remark!''}
        <#elseif field.name == 'pub_create_dept_id'>
        String ${field.name} = ""; //${field.remark!''}
        <#elseif field.name == 'pub_create_dept_name'>
        String ${field.name} = ""; //${field.remark!''}
        <#elseif field.name == 'pub_modified_id'>
        String ${field.name} = other_id; //${field.remark!''}
        <#elseif field.name == 'pub_modified_name'>
        String ${field.name} = other_user_name; //${field.remark!''}
        <#elseif field.name == 'pub_modified_time'>
        String ${field.name} = this.getCurrDate(); //${field.remark!''}
        <#--creater-->
        <#elseif field.name == 'pub_creater_id'>
        String ${field.name} = other_id; //${field.remark!''}
        <#elseif field.name == 'pub_creater_name'>
        String ${field.name} = other_user_name; //${field.remark!''}
        <#elseif field.name == 'pub_creater_time'>
        String ${field.name} = this.getCurrDate(); //${field.remark!''}
        <#elseif field.name == 'pub_creater_comp'>
        String ${field.name} = other_busorg_id; //${field.remark!''}
        <#elseif field.name == 'pub_creater_dept_id'>
        String ${field.name} = ""; //${field.remark!''}
        <#elseif field.name == 'pub_creater_dept_name'>
        String ${field.name} = ""; //${field.remark!''}
        </#if>
        <#--是否删除属性-->
        <#elseif field.is_del == '0'>
        String ${field.name} = "0"; //${field.remark!''}
        </#if>
        </#list>

        // 占位符注入参数
        // 注入请求参数
        List<Object> paramList = new ArrayList<>();
        <#list fields as field>
        <#if field.is_key == '0'>
        paramList.add(${field.name!''}); //${field.remark!''}
        <#elseif field.is_pub == "1" && field.is_key == "1" && field.is_del == "1">
        paramList.add(${field.name!''}); //${field.remark!''}
        </#if>
        </#list>
        // 注入公共参数
        <#list fields as field>
        <#if field.is_pub == '0'>
        paramList.add(${field.name!''}); //${field.remark!''}
        <#elseif field.is_del == '0'>
        paramList.add(${field.name!''}); //${field.remark!''}
        </#if>
        </#list>

        // 新增Sql
        StringBuffer insertSql = new StringBuffer();
        insertSql.append(" INSERT INTO ${tableName}( ");
        <#if fieldMap.pub != "">
        insertSql.append(" ${fieldMap.bus}, ");
        insertSql.append(" ${fieldMap.pub} ");
        <#else>
        insertSql.append(" ${fieldMap.bus} ");
        </#if>
        insertSql.append(" ) VALUES ( ${fieldMap.symbol} ) ");

        try{
            // 打印待执行SQL日志
            PubLog.logOptInfo(LoggerLevel.INFO, "新增操作SQL="+insertSql.toString(), false);
            PubLog.logOptInfo(LoggerLevel.INFO, "新增操作Params="+paramList.toString(), false);

            // 执行新增sql
            int changeLine = baseDao.executeSqlUpdate(insertSql.toString(), paramList.toArray());

            // 设置返回结果
            if(changeLine > 0){
                resultJson.put("result", "success");
                resultJson.put("message", "保存成功!");
            }else{
                resultJson.put("result", "error");
                resultJson.put("message", "保存失败!");
            }
        } catch (Exception e) {
            resultJson.put("result", "error");
            resultJson.put("message", "保存失败,后端接口异常!");
            PubLog.logOptInfo(LoggerLevel.ERROR, PubLog.getExceptionDetail(e), false);
        }
        return resultJson;
    }
    <#elseif checked == '分页查询'>


    /**
     * @Description 接口方法:分页列表查询接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回分页列表接口数据
     */
    public void queryPageList(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                              QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 分页查询操作
        this.selectPageList(queryBean, baseDao, pfDao, result);
    }


    /**
     * @Description 分页查询操作
     * @Author ${author}
     * @Version ${version}
     * @Datte ${date}
     * @return 返回分页列表数据
     */
    public void selectPageList(QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao, ResponseResult result) {
        // 定义分页查询结果对象
        List<Map<String, Object>> resultList = new ArrayList<>();

        // 获取查询条件参数
        List<Object> paramList = new ArrayList<>();
        <#list fields as field>
        <#if field.type?contains("DATE")>
        String ${field.name!''}_start = queryBean.getArgValue("${field.name!''}_start"); //${field.remark!''}开始时间
        String ${field.name!''}_end = queryBean.getArgValue("${field.name!''}_end"); //${field.remark!''}结束时间
        </#if>
        </#list>
        <#list fields as field>
        <#if field.is_key == "1" && field.is_del == "1" && field.is_pub == "1" && !field.type?contains("DATE")>
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        </#if>
        </#list>
        <#list fields as field>
        <#if field.is_key == "1" && field.is_del == "1" && field.is_pub == "0" && !field.type?contains("DATE")>
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        </#if>
        </#list>

        // 分页查询Sql
        StringBuffer querySql = new StringBuffer();
        querySql.append(" select ");
        <#if fieldMap.pub != "">
        querySql.append(" ${fieldMap.bus}, ");
        querySql.append(" ${fieldMap.pub} ");
        <#else>
        querySql.append(" ${fieldMap.bus} ");
        </#if>
        querySql.append(" from ${tableName} ");
        querySql.append(" where 1 = 1 ");
        querySql.append(" and <#list fields as field><#if field.is_del == "0">${field.name!''}</#if></#list> = '0' ");

        // 查询条件
        <#list fields as field>
        <#if field.type?contains("DATE")>
        // 查询条件-${field.remark!''}开始时间
        if(StringUtils.isNotBlank(${field.name!''}_start)){
            querySql.append(" AND ${field.name!''} >= ?");
            paramList.add(${field.name!''}_start);
        }
        // 查询条件-${field.remark!''}结束时间
        if(StringUtils.isNotBlank(${field.name!''}_end)){
            querySql.append(" AND ${field.name!''} <= ?");
            paramList.add(${field.name!''}_end);
        }
        </#if>
        </#list>
        <#list fields as field>
        <#if field.is_key == "1" && field.is_del == "1" && field.is_pub == "1" && !field.type?contains("DATE")>
        <#--精准查询-->
        <#if field.name?contains("id") || field.name?contains("status") || field.name?contains("key")>
        // 查询条件-${field.remark!''}
        if(StringUtils.isNotBlank(${field.name!''})){
            querySql.append(" AND ${field.name!''} = ?");
            paramList.add(${field.name!''});
        }
        <#else>
        <#--模糊匹配-->
        // 查询条件-${field.remark!''}
        if(StringUtils.isNotBlank(${field.name!''})){
            querySql.append(" AND ${field.name!''} LIKE ?");
            paramList.add("%"+${field.name!''}+"%");
        }
        </#if>
        </#if>
        </#list>
        <#list fields as field>
        <#if field.is_key == "1" && field.is_del == "1" && field.is_pub == "0" && !field.type?contains("DATE")>
        // 查询条件-${field.remark!''}
        if(StringUtils.isNotBlank(${field.name!''})){
            querySql.append(" AND ${field.name!''} = ?");
            paramList.add(${field.name!''});
        }
        </#if>
        </#list>

        // 结果总数统计sql
        StringBuffer countSql = new StringBuffer();
        countSql.append("SELECT COUNT(t.<#list fields as field><#if field.is_key == "0">${field.name!''}</#if></#list>) FROM (" + querySql.toString() + ") t");

        // 排序默认时间倒叙
        querySql.append(" order by pub_create_time desc");

        // 分页参数
        int start=queryBean.getExtParams().getStartInt();
        int limit=queryBean.getExtParams().getLimitInt();

        try{
            // 打印待执行SQL日志
            PubLog.logOptInfo(LoggerLevel.INFO, "分页查询SQL="+querySql.toString(), false);
            PubLog.logOptInfo(LoggerLevel.INFO, "分页查询Params="+paramList.toString(), false);

            // 执行分页sql
            resultList = baseDao.executeSqlQuery(querySql.toString(),paramList.toArray(),start,limit);

            // 执行统计sql
            int count = baseDao.findForCount(countSql.toString(), paramList.toArray());

            // 设置返回结果
            result.setFormatType(FormatType.LIST);
            result.setListData(resultList);
            result.setNumberData(count);
        } catch (Exception e) {
            PubLog.logOptInfo(LoggerLevel.ERROR, PubLog.getExceptionDetail(e), false);
        }
    }
    <#elseif checked == '修改方法'>


    /**
     * @Description 接口方法:数据修改业务接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回数据修改接口是否成功修改数据的提示信息
     */
    public void editMethod(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                           QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 定义接口返回对象
        JSONObject resultJson = new JSONObject();

        // 执行更新操作
        resultJson = this.updateMethod(queryBean, baseDao);

        // 设置接口返回结果
        result.setFormatType(FormatType.MESSAGE);
        result.setMessage(JSON.toJSONString(resultJson));
    }


    /**
     * @Description 数据修改操作
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回数据修改是否成功的提示信息
     */
    private JSONObject updateMethod(QueryBean queryBean, IBaseDao baseDao){
        // 返回结果
        JSONObject resultJson = new JSONObject();

        // 获取系统参数
        String other_id = queryBean.getArgValue("other_id"); //当前登录人id
        String other_user_name = queryBean.getArgValue("other_user_name"); //当前登录人名称

        // 获取修改参数
        // 请求参数
        <#list fields as field>
        <#if field.is_pub == "1" && field.is_del == "1">
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        </#if>
        </#list>
        // 公共参数
        <#list fields as field>
        <#if field.is_pub == '0' && field.name?contains("modified")>
        String ${field.name} = other_id; //${field.remark!''}
        </#if>
        </#list>

        // 占位符注入参数
        // 注入请求参数
        List<Object> paramList = new ArrayList<>();
        <#list fields as field>
        <#if field.is_pub == "1" && field.is_del == "1" && field.is_key == "1">
        paramList.add(${field.name}); //${field.remark!''}
        </#if>
        </#list>
        // 注入公共参数
        <#list fields as field>
        <#if field.is_pub == '0'>
        <#if field.name == 'pub_modified_id'>
        paramList.add(${field.name}); //${field.remark!''}
        <#elseif field.name == 'pub_modified_name'>
        paramList.add(${field.name}); //${field.remark!''}
        <#elseif field.name == 'pub_modified_time'>
        paramList.add(${field.name}); //${field.remark!''}
        </#if>
        </#if>
        </#list>
        // 注入修改条件参数
        <#list fields as field>
        <#if field.is_key == '0'>
        paramList.add(${field.name}); //${field.remark!''}
        </#if>
        </#list>

        // 数据修改Sql
        StringBuffer updateSql = new StringBuffer();
        updateSql.append(" UPDATE ${tableName} SET ");
        <#if fieldMap.edit_pub != "">
        updateSql.append(" ${fieldMap.edit_bus}, ");
        updateSql.append(" ${fieldMap.edit_pub} ");
        <#else>
        updateSql.append(" ${fieldMap.edit_bus} ");
        </#if>
        updateSql.append(" WHERE <#list fields as field><#if field.is_key == "0">${field.name!''}</#if></#list> = ? ");

        try{
            // 打印待执行SQL日志
            PubLog.logOptInfo(LoggerLevel.INFO, "修改操作SQL="+querySql.toString(), false);
            PubLog.logOptInfo(LoggerLevel.INFO, "修改查询Params="+paramList.toString(), false);

            // 执行sql
            int changeLine = baseDao.executeSqlUpdate(updateSql.toString(), paramList.toArray());

            // 设置返回结果
            if(changeLine > 0){
                resultJson.put("result", "success");
                resultJson.put("message", "更新成功!");
            }else{
                resultJson.put("result", "error");
                resultJson.put("message", "更新失败!");
            }
        } catch (Exception e) {
            resultJson.put("result", "error");
            resultJson.put("message", "更新失败!");
            PubLog.logOptInfo(LoggerLevel.ERROR, PubLog.getExceptionDetail(e), false);
        }
        return resultJson;
    }
    <#elseif checked == '获取详情'>


    /**
     * @Description 接口方法:根据传入ID获取数据详情接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回获取到的数据详情接口信息
     */
    public void queryDetail(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                            QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 根据ID查询数据详情操作
        this.selectDetail(queryBean, baseDao, pfDao, result);
    }


    /**
     * @Description 根据ID查询数据详情
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回查询到的数据详情信息
     */
    public void selectDetail(QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao, ResponseResult result) {
        // 定义详情查询结果对象
        List<Map<String, Object>> resultList = new ArrayList<>();
        Map<String,Object> resultMap = new HashMap<>();

        // 获取详情的ID参数
        List<Object> paramList = new ArrayList<>();
        <#list fields as field>
        <#if field.is_key == "0">
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        paramList.add(${field.name!''}); //${field.remark!''}
        </#if>
        </#list>

        // 查询详情Sql
        StringBuffer querySql = new StringBuffer();
        querySql.append(" select ");
        <#if fieldMap.pub != "">
        querySql.append(" ${fieldMap.bus}, ");
        querySql.append(" ${fieldMap.pub} ");
        <#else>
        querySql.append(" ${fieldMap.bus} ");
        </#if>
        querySql.append(" from ${tableName} ");
        querySql.append(" where 1 = 1 ");
        querySql.append(" and <#list fields as field><#if field.is_del == "0">${field.name!''}</#if></#list> = '0' ");
        querySql.append(" and <#list fields as field><#if field.is_key == "0">${field.name!''}</#if></#list> = ? ");

        try{
            // 打印待执行SQL日志
            PubLog.logOptInfo(LoggerLevel.INFO, "查询想清楚SQL="+querySql.toString(), false);
            PubLog.logOptInfo(LoggerLevel.INFO, "查询详情Params="+paramList.toString(), false);

            // 执行查询详情sql
            resultList = baseDao.executeSqlQuery(querySql.toString(),paramList.toArray());

            // 设置返回结果
            if(CollectionUtils.isNotEmpty(resultList)){
                resultMap = resultList.get(0);
                // 返回详情信息
                result.setFormatType(FormatType.MESSAGE);
                JSONObject resultJson = new JSONObject(resultMap);
                result.setMessage(JSON.toJSONString(resultJson));
            }else {
                // 接口出错走的分支
                result.setFormatType(FormatType.MESSAGE);
                result.setMessage("{\"success\":\"error\",\"message\":\"获取数据详情接口服务端异常\"}");
            }
        } catch (Exception e) {
            PubLog.logOptInfo(LoggerLevel.ERROR, PubLog.getExceptionDetail(e), false);
        }
    }
    <#elseif checked == '批量插入'>


    /**
     * @Description 接口方法:批量新增数据业务接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回接口新增数据提示信息
     */
    public void batchCreateMethod(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                                  QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 定义批量新增接口是否新增成功的提示信息对象
        JSONObject resultJson = new JSONObject();

        // 批量新增操作
        resultJson = this.batchInsertMethod(queryBean, baseDao, pfDao);

        // 设置批量新增提示信息返回结果
        result.setFormatType(FormatType.MESSAGE);
        result.setMessage(JSON.toJSONString(resultJson));
    }


    /**
     * @Description 批量新增操作
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回批量新增数据的提示信息
     */
    private JSONObject batchInsertMethod(QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 定义返回结果
        JSONObject resultJson = new JSONObject();

        // 获取系统参数
        String other_id = queryBean.getArgValue("other_id"); //当前登录人id
        String other_user_name = queryBean.getArgValue("other_user_name"); //当前登录人名称
        String other_busorg_id = queryBean.getArgValue("other_busorg_id"); //当前登录人单位id
        String other_orgname = queryBean.getArgValue("other_orgname"); //当前登录人单位名称

        // 获取业务参数
        // 请求参数
        String fileListStr = queryBean.getArgValue("fileListStr", false); //批量新增序列化字符串
        JSONArray jsonArray = JSONArray.parseArray(fileListStr);

        // 批量新增Sql
        StringBuffer batchInsertSql = new StringBuffer();
        batchInsertSql.append(" INSERT INTO ${tableName}( ");
        <#if fieldMap.pub != "">
        batchInsertSql.append(" ${fieldMap.bus}, ");
        batchInsertSql.append(" ${fieldMap.pub} ");
        <#else>
        batchInsertSql.append(" ${fieldMap.bus} ");
        </#if>
        batchInsertSql.append(" ) VALUES ( ${fieldMap.symbol} ) ");

        try{
            // 处理批量新增
            List<Map<String, Object>> fileList = JSONObject.parseArray(jsonArray.toJSONString(), Map.class);

            // 批量新增参数集合
            List<Object[]> paramList = new ArrayList<Object[]>();
            for (Map<String, Object> map : fileList) {
                // 获取新增参数
                // 业务参数
                <#list fields as field>
                <#if field.is_key == '0'>
                Object ${field.name!''} = Guid.create(); //${field.remark!''}
                <#elseif field.is_pub == "1" && field.is_key == "1" && field.is_del == "1">
                Object ${field.name!''} = map.get("${field.name!''}"); //${field.remark!''}
                </#if>
                </#list>
                // 公共参数
                <#list fields as field>
                <#if field.is_pub == '0'>
                <#--create-->
                <#if field.name == 'pub_create_id'>
                Object ${field.name} = other_id; //${field.remark!''}
                <#elseif field.name == 'pub_create_name'>
                Object ${field.name} = other_user_name; //${field.remark!''}
                <#elseif field.name == 'pub_create_time'>
                Object ${field.name} = this.getCurrDate(); //${field.remark!''}
                <#elseif field.name == 'pub_create_comp'>
                Object ${field.name} = other_busorg_id; //${field.remark!''}
                <#elseif field.name == 'pub_comp_name'>
                Object ${field.name} = other_orgname; //${field.remark!''}
                <#elseif field.name == 'pub_create_dept_id'>
                Object ${field.name} = ""; //${field.remark!''}
                <#elseif field.name == 'pub_create_dept_name'>
                Object ${field.name} = ""; //${field.remark!''}
                <#elseif field.name == 'pub_modified_id'>
                Object ${field.name} = other_id; //${field.remark!''}
                <#elseif field.name == 'pub_modified_name'>
                Object ${field.name} = other_user_name; //${field.remark!''}
                <#elseif field.name == 'pub_modified_time'>
                Object ${field.name} = this.getCurrDate(); //${field.remark!''}
                <#--creater-->
                <#elseif field.name == 'pub_creater_id'>
                Object ${field.name} = other_id; //${field.remark!''}
                <#elseif field.name == 'pub_creater_name'>
                Object ${field.name} = other_user_name; //${field.remark!''}
                <#elseif field.name == 'pub_creater_time'>
                Object ${field.name} = this.getCurrDate(); //${field.remark!''}
                <#elseif field.name == 'pub_creater_comp'>
                Object ${field.name} = other_busorg_id; //${field.remark!''}
                <#elseif field.name == 'pub_creater_dept_id'>
                Object ${field.name} = ""; //${field.remark!''}
                <#elseif field.name == 'pub_creater_dept_name'>
                Object ${field.name} = ""; //${field.remark!''}
                </#if>
                <#--是否删除属性-->
                <#elseif field.is_del == '0'>
                Object ${field.name} = "0"; //${field.remark!''}
                </#if>
                </#list>
                Object[] paramObjArr = new Object[]{${fieldMap.all}};
                paramList.add(paramObjArr);
            }

            // 打印待执行SQL日志
            PubLog.logOptInfo(LoggerLevel.INFO, "批量新增SQL="+batchInsertSql.toString(), false);
            PubLog.logOptInfo(LoggerLevel.INFO, "批量新增Params="+paramList.toString(), false);

            // 执行新增操作
            int[] changeLineArr = baseDao.executeSqlUpdateBatch(batchInsertSql.toString(), paramsList);

            // 设置返回结果
            if(changeLineArr.length > 0){
                resultJson.put("result", "success");
                resultJson.put("message", "批量插入成功!");
            }else{
                resultJson.put("result", "error");
                resultJson.put("message", "批量插入失败!");
            }

        } catch (Exception e) {
            resultJson.put("result", "error");
            resultJson.put("message", "批量插入失败!");
            PubLog.logOptInfo(LoggerLevel.ERROR, PubLog.getExceptionDetail(e), false);
        }
    }
    <#elseif checked == '非分页查询'>


    /**
     * @Description 接口方法:非分页列表查询接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回非分页列表接口数据
     */
    public void queryNoPageList(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                              QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 非分页查询操作
        this.selectNoPageList(queryBean, baseDao, pfDao, result);
    }


    /**
     * @Description 非分页查询操作
     * @Author ${author}
     * @Version ${version}
     * @Datte ${date}
     * @return 返回非分页列表数据
     */
    public void selectNoPageList(QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao, ResponseResult result) {
        // 定义非分页查询结果对象
        List<Map<String, Object>> resultList = new ArrayList<>();

        // 获取查询条件参数
        List<Object> paramList = new ArrayList<>();
        <#list fields as field>
        <#if field.type?contains("DATE")>
        String ${field.name!''}_start = queryBean.getArgValue("${field.name!''}_start"); //${field.remark!''}开始时间
        String ${field.name!''}_end = queryBean.getArgValue("${field.name!''}_end"); //${field.remark!''}结束时间
        </#if>
        </#list>
        <#list fields as field>
        <#if field.is_key == "1" && field.is_del == "1" && field.is_pub == "1" && !field.type?contains("DATE")>
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        </#if>
        </#list>
        <#list fields as field>
        <#if field.is_key == "1" && field.is_del == "1" && field.is_pub == "0" && !field.type?contains("DATE")>
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        </#if>
        </#list>

        // 非分页查询Sql
        StringBuffer querySql = new StringBuffer();
        querySql.append(" select ");
        <#if fieldMap.pub != "">
        querySql.append(" ${fieldMap.bus}, ");
        querySql.append(" ${fieldMap.pub} ");
        <#else>
        querySql.append(" ${fieldMap.bus} ");
        </#if>
        querySql.append(" from ${tableName} ");
        querySql.append(" where 1 = 1 ");
        querySql.append(" and <#list fields as field><#if field.is_del == "0">${field.name!''}</#if></#list> = '0' ");

        // 查询条件
        <#list fields as field>
        <#if field.type?contains("DATE")>
        // 查询条件-${field.remark!''}开始时间
        if(StringUtils.isNotBlank(${field.name!''}_start)){
            querySql.append(" AND ${field.name!''} >= ?");
            paramList.add(${field.name!''}_start);
        }
        // 查询条件-${field.remark!''}结束时间
        if(StringUtils.isNotBlank(${field.name!''}_end)){
            querySql.append(" AND ${field.name!''} <= ?");
            paramList.add(${field.name!''}_end);
        }
        </#if>
        </#list>
        <#list fields as field>
        <#if field.is_key == "1" && field.is_del == "1" && field.is_pub == "1" && !field.type?contains("DATE")>
        <#--精准查询-->
        <#if field.name?contains("id") || field.name?contains("status") || field.name?contains("key")>
        // 查询条件-${field.remark!''}
        if(StringUtils.isNotBlank(${field.name!''})){
            querySql.append(" AND ${field.name!''} = ?");
            paramList.add(${field.name!''});
        }
        <#else>
        <#--模糊匹配-->
        // 查询条件-${field.remark!''}
        if(StringUtils.isNotBlank(${field.name!''})){
            querySql.append(" AND ${field.name!''} LIKE ?");
            paramList.add("%"+${field.name!''}+"%");
        }
        </#if>
        </#if>
        </#list>
        <#list fields as field>
        <#if field.is_key == "1" && field.is_del == "1" && field.is_pub == "0" && !field.type?contains("DATE")>
        // 查询条件-${field.remark!''}
        if(StringUtils.isNotBlank(${field.name!''})){
            querySql.append(" AND ${field.name!''} = ?");
            paramList.add(${field.name!''});
        }
        </#if>
        </#list>

        // 排序默认时间倒叙
        querySql.append(" order by pub_create_time desc");

        try{
            // 打印待执行SQL日志
            PubLog.logOptInfo(LoggerLevel.INFO, "非分页查询SQL="+querySql.toString(), false);
            PubLog.logOptInfo(LoggerLevel.INFO, "非分页查询Params="+paramList.toString(), false);

            // 执行查询sql
            resultList = baseDao.executeSqlQuery(querySql.toString(),paramList.toArray());

            // 设置返回结果
            result.setFormatType(FormatType.LIST);
            result.setListData(resultList);
            result.setTplSuffix("nopage");
        } catch (Exception e) {
            PubLog.logOptInfo(LoggerLevel.ERROR, PubLog.getExceptionDetail(e), false);
        }
    }
    <#elseif checked == '自定义模板'>


    /**
    * @Description 接口方法:自定义模板接口
    * @Author ${author}
    * @Version ${version}
    * @Date ${date}
    * @return 自定义接口信息
    */
    public void customApi(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                          QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 定义接口返回对象
        JSONObject resultJson = new JSONObject();

        // 自定义数据操作
        resultJson = this.customMethod(queryBean, baseDao, pfDao, result);

        // 设置返回结果
        result.setFormatType(FormatType.MESSAGE);
        result.setMessage(JSON.toJSONString(resultJson));
    }


    /**
     * @Description 自定义操作
     * @Author ${author}
     * @Version ${version}
     * @Datte ${date}
     * @return 返回自定义操作信息
     */
    public void customMethod(QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao, ResponseResult result) {
        // 定义返回结果
        JSONObject resultJson = new JSONObject();

        try{
            // 打印日志
            PubLog.logOptInfo(LoggerLevel.INFO, "自定义模板", false);

            // 设置返回信息
            resultJson.put("result", "success");
            resultJson.put("message", "自定义模板!");
        } catch (Exception e) {
            PubLog.logOptInfo(LoggerLevel.ERROR, PubLog.getExceptionDetail(e), false);
        }
        return resultJson;
    }
    </#if>
    </#list>


    /**
     * @Description 传入查询结果和日期字段名称，对格式进行处理
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 将日期处理为yyyy-MM-dd的日期格式
     */
    private String handleDate(List<Map<String, Object>> resultList, String filedName){
        if(CollectionUtils.isNotEmpty(resultList)) {
            for (Map<String, Object> map : resultList) {
                String string = String.valueOf(map.get(filedName));
                DateTimeFormatter ofPattern = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDateTime time = LocalDateTime.parse(string, ofPattern);
                String date = time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                map.put(filedName, date);
            }
        }
    }


    /**
     * @Description 获取当前时间，为Gbase无法使用now函数做适配
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 获取当前时间
     */
    private String getCurrDate(){
        // 获取当前时间
        LocalDateTime currentDateTime = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String currDate = currentDateTime.format(formatter);
        return currDate;
    }

}