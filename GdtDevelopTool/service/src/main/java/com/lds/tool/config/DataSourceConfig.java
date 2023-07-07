package com.lds.tool.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import javax.sql.DataSource;

@Configuration
public class DataSourceConfig {
    @Autowired
    private Environment env;

    //配置数据源1
    @Bean(name = "pipe_hggl_datasource")
    @Primary
    public DataSource mysqlDataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(env.getProperty("spring.datasource.pipe_hggl.driver-class-name"));
        dataSource.setUrl(env.getProperty("spring.datasource.pipe_hggl.url"));
        dataSource.setUsername(env.getProperty("spring.datasource.pipe_hggl.username"));
        dataSource.setPassword(env.getProperty("spring.datasource.pipe_hggl.password"));
        return dataSource;
    }

    @Bean(name = "pipe_hggl")
    public JdbcTemplate mysqlJdbcTemplate(@Qualifier("pipe_hggl_datasource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    //配置数据源2
    @Bean(name = "pipe_platform_datasource")
    public DataSource gbaseDataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(env.getProperty("spring.datasource.pipe_platform.driver-class-name"));
        dataSource.setUrl(env.getProperty("spring.datasource.pipe_platform.url"));
        dataSource.setUsername(env.getProperty("spring.datasource.pipe_platform.username"));
        dataSource.setPassword(env.getProperty("spring.datasource.pipe_platform.password"));
        return dataSource;
    }

    @Bean(name = "pipe_platform")
    public JdbcTemplate gbaseJdbcTemplate(@Qualifier("pipe_platform_datasource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
}
