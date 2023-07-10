package com.lds.tool.service;

import com.lds.tool.util.Result;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Service
public interface JointDebugService {

    /**
     * 获取联调数据
     */
    Map jointDebugData(String dataSource, String tableName, String checkedItems);
}
