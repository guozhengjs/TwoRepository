package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    List<Contacts> getContactsListAndCustomerName();

    int save(Contacts con);

    String getContactsByCid(String customerId);

    List<Contacts> getContactsListByCid(String customerId);

    Contacts getContactsById(String id);

    //String getCustomerNameByid(String id);
}
