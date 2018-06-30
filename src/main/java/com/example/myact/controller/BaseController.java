package com.example.myact.controller;

import com.example.myact.common.util.UserUtil;
import com.example.myact.entity.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
public class BaseController {

    @RequestMapping("/")
    public String demo(){
        return "login";
    }

    @RequestMapping("/index")
    public String index() {
        return "index";
    }

    @RequestMapping("/login")
    @ResponseBody
    public String login(HttpServletRequest request){
        User user = new User();
        user.setId("1");
        user.setFirstName(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));

        UserUtil.saveUserToSession(request.getSession(),user);
        return "true";
    }

    @RequestMapping("/logout")
    public String logout(HttpServletRequest request){
        UserUtil.removeUserSession(request.getSession());
        return "true";
    }

}
