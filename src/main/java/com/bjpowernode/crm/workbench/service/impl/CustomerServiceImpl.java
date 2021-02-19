package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.ContactsDao;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.CustomerRemarkDao;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author 北京动力节点
 */
@Service
public class CustomerServiceImpl implements CustomerService {

    @Resource
    private CustomerDao customerDao ;

    @Resource
    private UserDao userDao;

    @Autowired
    private CustomerRemarkDao customerRemarkDao;

    @Autowired
    private ContactsDao contactsDao;

    @Resource
    private TranDao tranDao;

    public PaginationVO<Customer> pageList(Map<String, Object> map) {

        //取得total
        int total = customerDao.getTotalByCondition(map);

        //取得dataList
        List<Customer> dataList = customerDao.getCustomerListByCondition(map);

        //创建一个vo对象，将total和dataList封装到vo中
        PaginationVO<Customer> vo = new PaginationVO<Customer>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        //将vo返回
        return vo;


    }

    public List<String> getCustomerName(String name) {

        List<String> sList = customerDao.getCustomerName(name);

        return sList;
    }


    public boolean save(Customer c) {

        boolean flag = true;

        int count = customerDao.save(c);

        if(count!=1){
            flag=false;
        }
        return flag;
    }


    public Map<String, Object> getUserListAndCustomer(String id) {

        List<User> uList =userDao.getUserList();

        Customer c = customerDao.getById(id);

        Map<String,Object> map = new HashMap<>();

        map.put("uList",uList);
        map.put("c",c);

        return map;
    }

    @Override
    public boolean update(Customer customer) {

        boolean flag = true;

        int count = customerDao.update(customer);

        if(count!=1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;

        //查询出需要删除的备注的数量
        int count1 = customerRemarkDao.countRemarkByCids(ids);

        //删除备注，返回受到影响的条数（实际删除的数量）
        int count2 = customerRemarkDao.deleteRemarkByCids(ids);

        if(count1!=count2){
            flag = false;
        }
        //删除线索记录
        int count3 = customerDao.deleteCustomers(ids);
        if(count3!=ids.length){

            flag = false;

        }
        return flag;
    }

    @Override
    public Customer detail(String id) {

        Customer c = customerDao.detailById(id);

        return c;
    }

    @Override
    public Map<String,Object> getRemarkListAndContactsByCid(String customerId) {

        Map<String,Object> map = new HashMap<>();

        List<CustomerRemark> cList= customerRemarkDao.getRemarkListByCid(customerId);

        String contactsName = contactsDao.getContactsByCid(customerId);

        map.put("cList",cList);
        map.put("contactsName",contactsName);

        return map;
    }

    @Override
    public boolean deleteRemark(String id) {

        boolean flag = true;

        int count = customerRemarkDao.deleteRemarkByid(id);

        if(count!=1){
            flag=false;
        }

        return flag;
    }

    @Override
    public boolean saveRemark(CustomerRemark cr) {
        boolean flag = true;

        int count = customerRemarkDao.save(cr);

        if(count!=1){
            flag = false;

        }


        return flag;
    }

    @Override
    public String getContactsNamebyCid(String customerId) {

        String contactsName = contactsDao.getContactsByCid(customerId);

        return contactsName;
    }

    @Override
    public boolean updateRemark(CustomerRemark cr) {

        boolean flag = true;

        int count = customerRemarkDao.update(cr);

        if(count!=1){
            flag = false;
        }

        return flag;
    }

    @Override
    public List<Tran> getTranByCid(String customerId) {

        List<Tran> tranList = tranDao.getTranList(customerId);

        return tranList;
    }

    @Override
    public List<Contacts> getContactsByCid(String customerId) {

        List<Contacts> contactsList = contactsDao.getContactsListByCid(customerId);

        return contactsList;
    }

    @Override
    public String getCustomerNameById(String customerId) {

        String customerName = customerDao.getCustomerNameById(customerId);

        return customerName;

    }

}




