package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;


public interface ContactsService {


    Contacts detail(String id);

    List<Contacts> getContactsListAndCustomerName();

    //String getCustomerNameById(String id);
}
