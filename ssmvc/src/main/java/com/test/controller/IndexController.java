package com.test.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {


    private static String prefix= "web/";

    @RequestMapping("/index")
    public String index(){
        return prefix+"index";
    }
    @RequestMapping("/loginTest")
    public String login(){
        return prefix+"login";
    }
    @RequestMapping("/error")
    public String error(){
        return prefix+"error";
    }

}
