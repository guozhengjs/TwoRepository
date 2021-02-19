package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
@RequestMapping("/workbench/contacts")
public class ContactsController extends HttpServlet {

    @Resource
    private ContactsService contactsService;

    @Resource
    private CustomerService customerService;

    @RequestMapping("/detail.do")
    private void detail(String id, HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("跳转到联系人详细信息页");

        Contacts c = contactsService.detail(id);

        String customerId=c.getCustomerId();

        String customerName = customerService.getCustomerNameById(customerId);

        request.setAttribute("customerName",customerName);
        request.setAttribute("c", c);

        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request, response);


    }

}
