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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

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
     * @param backEndDataBean 后端数据对象
     * @param configData 数据配置对象
     * @param result 封装的响应对象
     * @param queryBean 封装的请求对象
     * @param baseDao 业务库操作对象
     * @param pfDao 系统库操作对象
     */
    @Override
    public void defaultMethod(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                              QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
    }

    /**
     * Describe 接口方法:数据新增业务接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回新增数据的提示信息
     */
    public void createMethod(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                             QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 定义接口返回对象
        JSONObject resultJson = new JSONObject();

        // 新增操作
        resultJson = this.insertMethod(queryBean, baseDao, pfDao);

        // 设置返回结果
        result.setFormatType(FormatType.MESSAGE);
        result.setMessage(JSON.toJSONString(resultJson));
    }


    /**
     * @Describe 新增操作
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回新增数据的提示信息
     */
    private JSONObject insertMethod(QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao){
        // 定义返回结果
        JSONObject resultJson = new JSONObject();

        // 获取系统参数
        String other_id = queryBean.getArgValue("other_id"); //当前登录人id
        String other_user_name = queryBean.getArgValue("other_user_name"); //当前登录人名称
        String other_busorg_id = queryBean.getArgValue("other_busorg_id"); //当前登录人单位id
        String other_orgname = queryBean.getArgValue("other_orgname"); //当前登录人单位名称
        String other_dept_name = queryBean.getArgValue("other_dept_name"); //当前登录人单位名称
        String other_dept_id = queryBean.getArgValue("other_dept_id"); //当前登录人单位名称

        // 获取业务参数
        // 请求参数
        <#list fields as field>
        <#if field.is_pub == '0'>
        <#if field.name == 'id'>
        String id = UUID.randomUUID().toString().replaceAll("-", ""); //${field.remark!''}
        <#else>
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        </#if>
        </#if>
        </#list>
        // 公共参数
        <#list fields as field>
        <#if field.is_pub == '1'>
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
        String ${field.name} = other_dept_id; //${field.remark!''}
        <#elseif field.name == 'pub_create_dept_name'>
        String ${field.name} = other_dept_name; //${field.remark!''}
        <#elseif field.name == 'pub_modified_id'>
        String ${field.name} = other_id; //${field.remark!''}
        <#elseif field.name == 'pub_modified_name'>
        String ${field.name} = other_user_name; //${field.remark!''}
        <#elseif field.name == 'pub_modified_time'>
        String ${field.name} = this.getCurrDate(); //${field.remark!''}
        <#elseif field.name?starts_with("is_delete")>
        String ${field.name} = "0"; //${field.remark!''}
        </#if>
        </#if>
        </#list>

        // 占位符注入参数
        // 注入请求参数
        List<Object> paramList = new ArrayList<>();
        <#list fields as field>
        <#if field.is_pub == '0'>
        paramList.add(${field.name!''}); //${field.remark!''}
        </#if>
        </#list>
        // 注入公共参数
        <#list fields as field>
        <#if field.is_pub == '1'>
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


    /**
     * Describe 接口方法:分页查询接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回分页查询结果
     */
    public void queryPageList(BackEndDataBean backEndDataBean, IConfigData configData, ResponseResult result,
                              QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao) {
        // 分页查询操作
        this.queryPageList(queryBean, baseDao, pfDao);
    }


    /**
     * @Describe 分页查询操作
     * @Author ${author}
     * @Version ${version}
     * @Datte ${date}
     * @return 返回分页查询结果或错误信息
     */
    public List<Map<String,Object>> selectPageList(QueryBean queryBean, IBaseDao baseDao, IBaseDao pfDao, ResponseResult result) {
        // 定义分页查询结果对象
        List<Map<String, Object>> resultList = new ArrayList<>();

        // 业务参数
        List<Object> paramList = new ArrayList<>();
        <#list fields as field>
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        <#assign is_delete = "">
        <#if field.name?starts_with("is_delete")>
        <#assign is_delete = field.name>
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
        <#if is_delete != "">
        querySql.append(" and ${is_delete} = 0 ");
        </#if>

        // 结果总数统计sql
        StringBuffer countSql = new StringBuffer();
        countSql.append("select count(id) from hg_question_inventory where is_deleted = 0");

        // 查询条件
        <#list fields as field>
        // 查询条件-${field.remark!''}
        if(StringUtils.isNotBlank(${field.name!''})){
            querySql.append(" AND ${field.name!''} = ?");
            countSql.append(" AND ${field.name!''} = ?");
            paramList.add(${field.name!''});
        }
        </#list>

        // 排序默认时间倒叙
        querySql.append(" order by q.pub_create_time desc");

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


    /**
     * Describe 接口方法:数据修改业务接口
     * @Author ${author}
     * @Version ${version}
     * @Date ${date}
     * @return 返回数据修改是否成功的提示信息
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
     * @Describe 数据修改操作
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

        // 获取业务参数
        // 请求参数
        <#list fields as field>
        <#if field.is_pub == '0'>
        String ${field.name!''} = queryBean.getArgValue("${field.name!''}"); //${field.remark!''}
        </#if>
        </#list>
        // 公共参数
        <#list fields as field>
        <#if field.is_pub == '1'>
        <#if field.name == 'pub_modified_id'>
        String ${field.name} = other_id; //${field.remark!''}
        <#elseif field.name == 'pub_modified_name'>
        String ${field.name} = other_user_name; //${field.remark!''}
        <#elseif field.name == 'pub_modified_time'>
        String ${field.name} = this.getCurrDate(); //${field.remark!''}
        </#if>
        </#if>
        </#list>

        // 占位符注入参数
        // 注入请求参数
        List<Object> paramList = new ArrayList<>();
        <#list fields as field>
        <#if field.is_pub == '0' && field.name != "id">
        paramList.add(${field.name!''}); //${field.remark!''}
        </#if>
        </#list>
        // 注入公共参数
        paramList.add(pub_modified_id); //修改人id
        paramList.add(pub_modified_name); //修改人姓名
        paramList.add(pub_modified_time); //修改时间
        // 注入修改条件参数
        paramList.add(id); //修改的数据id

        // 数据修改Sql
        StringBuffer updateSql = new StringBuffer();
        updateSql.append(" UPDATE ${tableName} SET ");
        updateSql.append(" <#list fields as field><#if field.is_pub == '0' && field.name != "id" >${field.name} = ?, </#if></#list> ");
        updateSql.append(" <#list fields as field><#if field.is_pub == '0' && field.name != "id" >${field.name} = ?, </#if></#list> ");
        updateSql.append(" WHERE id = ? ");

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