package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author 北京动力节点
 */
@Controller
@RequestMapping("/workbench/activity")
public class ActivityController extends HttpServlet {
    @Autowired
    private ActivityService activityService;
    @Resource
    private UserService userService;
    //produces = "text/plain;charset=utf-8"

    @RequestMapping("/refresh.do")
    private void refresh(String id,HttpServletRequest request, HttpServletResponse response){
        Activity activity =  activityService.getActivityById(id);
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        activity.setEditBy(editBy);

        activity.setEditTime(editTime);

        PrintJson.printJsonObj(response,activity);
    }

    @RequestMapping(value= "/updateRemark.do")
    private void updateRemark(ActivityRemark ar,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行修改备注的操作");

        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        ar.setEditFlag(editFlag);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);

        //ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = activityService.updateRemark(ar);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("ar", ar);

        PrintJson.printJsonObj(response, map);

    }

    @RequestMapping("/saveRemark.do")
    private void saveRemark(ActivityRemark ar,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行添加备注操作");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        ar.setId(id);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setEditFlag(editFlag);

        boolean flag = activityService.saveRemark(ar);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("ar", ar);

        PrintJson.printJsonObj(response, map);


    }

    @RequestMapping("/deleteRemark.do")
    private void deleteRemark(String id ,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("删除备注操作");

        boolean flag = activityService.deleteRemark(id);

        PrintJson.printJsonFlag(response, flag);


    }

    @RequestMapping("/getRemarkListByAid.do")
    private void getRemarkListByAid(String activityId,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("根据市场活动id，取得备注信息列表");


        List<ActivityRemark> arList = activityService.getRemarkListByAid(activityId);

        PrintJson.printJsonObj(response, arList);



    }

    @RequestMapping("/detail.do")
    private void detail(String id,HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("进入到跳转到详细信息页的操作");

        Activity a = activityService.detail(id);

        request.setAttribute("a", a);

        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request, response);


    }

    @RequestMapping("/update.do")
    private void update(Activity a,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行市场活动修改操作");
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        a.setEditBy(editBy);
        a.setEditTime(editTime);

        //request.getSession().setAttribute("activity",a);

        boolean flag = activityService.update(a);

        PrintJson.printJsonFlag(response, flag);

    }

    @RequestMapping("/getUserListAndActivity.do")
    private void getUserListAndActivity(String id,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到查询用户信息列表和根据市场活动id查询单条记录的操作");

        /*

            总结：
                controller调用service的方法，返回值应该是什么
                你得想一想前端要什么，就要从service层取什么

            前端需要的，管业务层去要
            uList
            a

            以上两项信息，复用率不高，我们选择使用map打包这两项信息即可
            map

         */
        Map<String,Object> map = activityService.getUserListAndActivity(id);

        PrintJson.printJsonObj(response, map);


    }

    @RequestMapping("/delete.do")
    private void delete(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行市场活动的删除操作");

        String ids[] = request.getParameterValues("id");

       // ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = activityService.delete(ids);

        PrintJson.printJsonFlag(response, flag);


    }

    @RequestMapping("/pageList.do")
    private void pageList(String name,String owner,String startDate,String endDate,Integer pageNo, Integer pageSize,
                          HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到查询市场活动信息列表的操作（结合条件查询+分页查询）");
        //String pageNoStr = request.getParameter("pageNo");
        int skipCount = (pageNo-1)*pageSize;

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        PaginationVO<Activity> vo = activityService.pageList(map);
        PrintJson.printJsonObj(response, vo);




    }

    @RequestMapping("/save.do")
    private void save(Activity a,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行市场活动添加操作");
        String id = UUIDUtil.getUUID();
        //创建时间：当前系统时间
        String createTime = DateTimeUtil.getSysTime();
        //创建人：当前登录用户
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        a.setId(id);
        a.setCreateTime(createTime);
        a.setCreateBy(createBy);
        boolean flag = activityService.save(a);

        PrintJson.printJsonFlag(response, flag);

    }

    @RequestMapping("/getUserList.do")
    @ResponseBody
    private void getUserList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("取得用户信息列表");


        List<User> uList = userService.getUserList();

        PrintJson.printJsonObj(response, uList);

    }
}



