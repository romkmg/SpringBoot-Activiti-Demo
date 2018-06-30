package com.example.myact.common.util;

import org.activiti.engine.identity.User;

import javax.servlet.http.HttpSession;

/**
 * 用户工具类
 * @Author @MG
 * @Date 2018/6/30 14:04
 */
public class UserUtil {

    public static final String USER = "user";

    /**
     * 设置用户到session
     *
     * @param session
     * @param user
     */
    public static void saveUserToSession(HttpSession session, User user) {
        session.setAttribute(USER, user);
    }

    /**
     * 从Session获取当前用户信息
     *
     * @param session
     * @return
     */
    public static User getUserFromSession(HttpSession session) {
        Object attribute = session.getAttribute(USER);
        return attribute == null ? null : (User) attribute;
    }

    /**
     * 移除用户session信息
     * @return
     */
    public static void removeUserSession(HttpSession session) {
        session.removeAttribute(USER);
    }

}
