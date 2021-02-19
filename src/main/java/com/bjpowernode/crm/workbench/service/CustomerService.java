package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;

import java.util.List;
import java.util.Map;

/**
 * Author 北京动力节点
 */
public interface CustomerService {
    List<String> getCustomerName(String name);

    PaginationVO<Customer> pageList(Map<String, Object> map);


    boolean save(Customer c);

    Map<String, Object> getUserListAndCustomer(String id);

    boolean update(Customer customer);

    boolean delete(String[] ids);

    Customer detail(String id);

    Map<String, Object> getRemarkListAndContactsByCid(String customerId);

    boolean deleteRemark(String id);

    boolean saveRemark(CustomerRemark cr);

    String getContactsNamebyCid(String customerId);

    boolean updateRemark(CustomerRemark cr);

    List<Tran> getTranByCid(String customerId);

    List<Contacts> getContactsByCid(String customerId);

    String getCustomerNameById(String customerId);
}
