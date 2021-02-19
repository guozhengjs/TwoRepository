package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.PrintJson;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * Author 北京动力节点
 */
@Controller
@RequestMapping("/settings/user")
public class UserController extends HttpServlet {

    @Resource
    private UserService us ;
    @RequestMapping("/login.do")
    private void login(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到验证登录操作");
        //ModelAndView mv  = new ModelAndView();
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码的明文形式转换为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接收浏览器端的ip地址
        String ip = request.getRemoteAddr();
        System.out.println("--------------ip:"+ip);
        //未来业务层开发，统一使用代理类形态的接口对象

        try {

            User user = us.login(loginAct,loginPwd,ip);

            request.getSession().setAttribute("user", user);

            //如果程序执行到此处，说明业务层没有为controller抛出任何的异常
            //表示登录成功
            /*

                {"success":true}

             */
            PrintJson.printJsonFlag(response, true);
            System.out.println("验证完成，登录成功");
            //mv.setViewName("forward:/workbench/index.jsp");
           // return mv;
            //return "true";
            //return "workbench/index";
        }catch(Exception e){
            e.printStackTrace();
            String msg = e.getMessage();
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success", false);
            map.put("msg", msg);
            PrintJson.printJsonObj(response, map);
            //return "login";
            //return "登陆失败";
            //mv.setViewName("redirect:/login.jsp");
            //return mv;
        }


    }
}




































