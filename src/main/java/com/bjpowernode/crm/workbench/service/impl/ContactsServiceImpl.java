package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ContactsDao;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Resource
    private ContactsDao contactsDao;


    @Override
    public Contacts detail(String id) {

        Contacts contacts = contactsDao.getContactsById(id);

        return contacts;
    }


    /*public String getCustomerNameById(String id) {

        String customerName = contactsDao.getCustomerNameByid(id);

        return customerName;
    }*/
}
