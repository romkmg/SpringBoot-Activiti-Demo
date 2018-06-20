package com.example.myact.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ActController {

    @RequestMapping("/")
    @ResponseBody
    public String demo(){
        return "Hello Desktop!";
    }

    @RequestMapping("/index")
    public String index() {
        return "index_";
    }

}
