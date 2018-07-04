package com.example.myact.controller;

import com.example.myact.common.util.UserUtil;
import org.activiti.engine.IdentityService;
import org.activiti.engine.identity.Group;
import org.activiti.engine.identity.User;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class BaseController {

    @Autowired
    private IdentityService identityService;

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
    public String login(HttpServletRequest request,
                        @RequestParam("username") String username,@RequestParam("password") String password){
        List<User> users = identityService.createUserQuery().userFirstName(username).list();
        User user = null;
        boolean checkLogin = false;
        if(users==null || users.isEmpty()){
            return "false";
        }else if(users.size()==1){
            user = users.get(0);
            checkLogin = identityService.checkPassword(user.getId(),password);
        }else {
            for(User user1 : users){
                checkLogin = identityService.checkPassword(user1.getId(),password);
                if (checkLogin) {break;}
            }
        }

        if(checkLogin){
            UserUtil.saveUserToSession(request.getSession(),user);
            List<Group> groupList = identityService.createGroupQuery().groupMember(username).list();
            request.getSession().setAttribute("groups", groupList);

            String[] groupNames = new String[groupList.size()];
            for (int i = 0; i < groupNames.length; i++) {
                System.out.println(groupList.get(i).getName());
                groupNames[i] = groupList.get(i).getName();
            }

            request.getSession().setAttribute("groupNames", ArrayUtils.toString(groupNames));
            return "true";
        }else {
            return "false";
        }
    }

    @RequestMapping("/logout")
    public String logout(HttpServletRequest request){
        UserUtil.removeUserSession(request.getSession());
        return "true";
    }

}
