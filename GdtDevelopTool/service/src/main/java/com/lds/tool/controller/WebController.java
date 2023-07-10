package com.lds.tool.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

    /**
     * 首页
     */
    @GetMapping({"/", "/index.html"})
    public String index(Model model) {
        return "index";
    }

    /**
     * 生成逻辑类页
     */
    @GetMapping({"/logicClass", "/logicClass.html"})
    public String logicClass(Model model) {
        return "logicClass";
    }

    /**
     * 多种java模板页
     */
    @GetMapping({"/javaTemplate", "/javaTemplate.html"})
    public String javaTemplate(Model model) {
        return "javaTemplate";
    }

    /**
     * 多种java模板页
     */
    @GetMapping({"/jointDebug", "/jointDebug.html"})
    public String jointDebug(Model model) {
        return "jointDebug";
    }
}
