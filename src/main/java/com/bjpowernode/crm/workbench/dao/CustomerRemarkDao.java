package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    List<CustomerRemark> getRemarkListByCid(String customerId);

    int save(CustomerRemark customerRemark);

    int countRemarkByCids(String[] ids);

    int deleteRemarkByCids(String[] ids);

    int deleteRemarkByid(String id);

    int update(CustomerRemark cr);

    //int saveRemark(CustomerRemark );
}
