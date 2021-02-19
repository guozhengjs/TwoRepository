package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/customer")
public class CustomerController extends HttpServlet {

    @Resource
    private CustomerService customerService;

    @Resource
    private UserService userService;

   /* @Resource
    private ContactsService contactsService;*/


//=============================================================

    @RequestMapping("/getContactsListByCid.do")
    private void getContactsListByCid(String customerId,HttpServletResponse response){

        System.out.println("客户模块：获取联系人信息");

        List<Contacts> contactsList = customerService.getContactsByCid(customerId);

        PrintJson.printJsonObj(response,contactsList);
    }

    @RequestMapping("/getTranListByCid.do")
    private void getTranListByCid(String customerId,HttpServletResponse response){

        System.out.println("客户模块：获取交易信息");

        List<Tran> tranList = customerService.getTranByCid(customerId);

        PrintJson.printJsonObj(response,tranList);
    }


    @RequestMapping("/saveRemark.do")
    private void saveRemark(CustomerRemark cr, HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行添加备注操作");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        cr.setId(id);
        cr.setCreateBy(createBy);
        cr.setCreateTime(createTime);
        cr.setEditFlag(editFlag);

        String customerId = cr.getCustomerId();

        boolean flag = customerService.saveRemark(cr);

        String cName = customerService.getContactsNamebyCid(customerId);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("cr", cr);
        map.put("contactName",cName);

        PrintJson.printJsonObj(response, map);


    }


    @RequestMapping(value= "/updateRemark.do")
    private void updateRemark(CustomerRemark cr,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("客户模块：执行修改备注的操作");

        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        cr.setEditFlag(editFlag);
        cr.setEditBy(editBy);
        cr.setEditTime(editTime);

        boolean flag = customerService.updateRemark(cr);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("cr", cr);

        PrintJson.printJsonObj(response, map);

    }


    @RequestMapping("/deleteRemark.do")
    private void deleteRemark(String id ,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("删除线索备注操作");

        boolean flag = customerService.deleteRemark(id);

        PrintJson.printJsonFlag(response, flag);
    }


    @RequestMapping("/getRemarkListAndContactsByCid.do")
    private void getRemarkListAndContactByCid(String customerId,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("根据市场活动id，取得备注信息列表");

        Map<String,Object> map = customerService.getRemarkListAndContactsByCid(customerId);

        //List<CustomerRemark> arList = customerService.getRemarkListByCid(customerId);



        PrintJson.printJsonObj(response, map);



    }


    @RequestMapping("/delete.do")
    private void delete( HttpServletResponse response,HttpServletRequest request){
        System.out.println("执行潜在客户的删除操作");

        String ids[] = request.getParameterValues("id");


        boolean flag = customerService.delete(ids);

        PrintJson.printJsonFlag(response, flag);

    }

    @RequestMapping("/detail.do")
    private void detail( String id,HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("跳转到线索详细信息页");

        Customer c = customerService.detail(id);

        request.setAttribute("c", c);
        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request, response);


    }


    @RequestMapping("/update.do")
    private void update(Customer customer,HttpServletResponse response,HttpServletRequest request){

        System.out.println("更新客户信息");

        String editTime = DateTimeUtil.getSysTime();

        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        customer.setEditBy(editBy);

        customer.setEditTime(editTime);

        boolean flag = customerService.update(customer);

        PrintJson.printJsonFlag(response,flag);

    }

    @RequestMapping("/getUserListAndCustomer.do")
    private void getUserListAndCustomer(String id,HttpServletRequest request,HttpServletResponse response){

        System.out.println("客户模块：获取用户列表和客户列表！");

        Map<String,Object> map = customerService.getUserListAndCustomer(id);

        PrintJson.printJsonObj(response,map);

    }

    @RequestMapping("/save.do")
    private void save( HttpServletRequest request, HttpServletResponse response, Customer c) {

        System.out.println("执行线索添加操作");

        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        c.setId(id);
        c.setCreateTime(createTime);
        c.setCreateBy(createBy);

        boolean flag = customerService.save(c);

        PrintJson.printJsonFlag(response, flag);

    }



    @RequestMapping("/getUserList.do")
    private void getUserList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("取得用户信息列表");

        List<User> uList = userService.getUserList();

        PrintJson.printJsonObj(response, uList);

    }


    @RequestMapping("/pageList.do")
    private void pageList(String name,String owner,String phone,String website,
                          Integer pageNo,Integer pageSize,
                          HttpServletRequest request, HttpServletResponse response){
        System.out.println("客户页面的前端分页展示=====");

        int skipCount = (pageNo-1)*pageSize;

        Map<String,Object> map = new HashMap<String,Object>();

        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);

        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Customer> vo = customerService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }
}
