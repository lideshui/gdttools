package com.lds.tool.service.impl;

import com.lds.tool.service.MigrationTableInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class MigrationTableInfoServiceImpl implements MigrationTableInfoService {

    @Autowired
    @Qualifier("pipe_hggl")
    private JdbcTemplate jdbcTemplate;

    /**
     * 迁移表数据
     */
    @Override
    public boolean migrationTableData() {
        return true;
    }

    /**
     * 根据数据查询内容
     */

    /**
     * 转存储BLOB文件到本地目录
     */

    /**
     * 生成insert语句
     */

    /**
     * 执行insert语句
     */

}
