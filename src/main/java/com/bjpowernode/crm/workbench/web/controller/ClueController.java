package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.ClueDao;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sound.midi.MidiSystem;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author 北京动力节点
 */
@Controller
@RequestMapping("/workbench/clue")
public class ClueController extends HttpServlet {

    @Resource
    private ActivityService activityService;
    @Resource
    private ClueService clueService;
    @Resource
    private UserService userService;



    @RequestMapping(value= "/updateRemark.do")
    private void updateRemark(ActivityRemark ar,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行修改备注的操作");

        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        ar.setEditFlag(editFlag);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);

        boolean flag = clueService.updateRemark(ar);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("ar", ar);

        PrintJson.printJsonObj(response, map);

    }

    @RequestMapping("/deleteRemark.do")
    private void deleteRemark(String id ,HttpServletRequest request, HttpServletResponse response) {

        System.out.println("删除线索备注操作");

        boolean flag = clueService.deleteRemark(id);

        PrintJson.printJsonFlag(response, flag);
    }

    @RequestMapping("/saveRemark.do")
    private void saveRemark(ClueRemark ar, HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行添加备注操作");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        ar.setId(id);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setEditFlag(editFlag);

        boolean flag = clueService.saveRemark(ar);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("ar", ar);

        PrintJson.printJsonObj(response, map);


    }

    @RequestMapping("/refresh.do")
    private void refresh(String id,HttpServletRequest request, HttpServletResponse response){
        //Activity activity =  activityService.getActivityById(id);
        Clue c = clueService.getClueById(id);
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        c.setEditBy(editBy);

        c.setEditTime(editTime);

        PrintJson.printJsonObj(response,c);
    }

    @RequestMapping("/update.do")
    private void update(Clue c,HttpServletRequest request,HttpServletResponse response){

        System.out.println("执行市场活动的修改操作");
        String editTime = DateTimeUtil.getSysTime();

        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        //System.out.println(editBy);

        boolean flag = true;
        c.setEditTime(editTime);
        c.setEditBy(editBy);

        flag = clueService.update(c);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping("/getUserListAndClue.do")
    private void getUserListAndClue(String id,HttpServletRequest request,HttpServletResponse response){

        System.out.println("进入到查询用户信息列表和根据线索id查询单条记录的操作");

        Map<String,Object> map = clueService.getUserListAndClue(id);

        PrintJson.printJsonObj(response, map);
    }

    @RequestMapping("/getClueRemarkListByClueId.do")
    private void getClueRemarkListByClueId(String clueId,HttpServletRequest request,HttpServletResponse response){

        System.out.println("获取线索备注111111");

        List<ClueRemark> clueRemarkList = clueService.getClueRemarkById(clueId);

        PrintJson.printJsonObj(response,clueRemarkList);
    }

    @RequestMapping("/delete.do")
    private void delete( HttpServletResponse response,HttpServletRequest request){
        System.out.println("执行潜在客户的删除操作");

        String ids[] = request.getParameterValues("id");


        boolean flag = clueService.delete(ids);

        PrintJson.printJsonFlag(response, flag);

    }

    @RequestMapping("/deleteTwo.do")
    private void deleteTwo(String id, HttpServletResponse response,HttpServletRequest request){

        System.out.println("执行潜在客户的删除操作two");

        boolean flag = clueService.deleteTwo(id);

        PrintJson.printJsonFlag(response, flag);

    }

    @RequestMapping("/pageList.do")
    private void pageList(String fullname,
                          String company,
                          String phone,
                          String source,
                          String owner,
                          String mphone,
                          String state,
                          Integer pageNo,Integer pageSize,HttpServletRequest request, HttpServletResponse response){
        System.out.println("线索页面的前端分页展示=====");

        int skipCount = (pageNo-1)*pageSize;

        Map<String,Object> map = new HashMap<String,Object>();

        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);

        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Clue> vo = clueService.pageList(map);
        PrintJson.printJsonObj(response,vo);

    }

    @RequestMapping("/convert.do")
    private void convert(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("执行线索转换的操作");

        String clueId = request.getParameter("clueId");

        //接收是否需要创建交易的标记
        String flag = request.getParameter("flag");

        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        Tran t = null;

        //如果需要创建交易
        if("a".equals(flag)){

            t = new Tran();

            //接收交易表单中的参数
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();


            t.setId(id);
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setActivityId(activityId);
            t.setCreateBy(createBy);
            t.setCreateTime(createTime);

        }

        //ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        /*

            为业务层传递的参数：

            1.必须传递的参数clueId，有了这个clueId之后我们才知道要转换哪条记录
            2.必须传递的参数t，因为在线索转换的过程中，有可能会临时创建一笔交易（业务层接收的t也有可能是个null）

         */
        boolean flag1 = clueService.convert(clueId,t,createBy);

        if(flag1){

            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");

        }

    }

    @RequestMapping("/getActivityListByName.do")
    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("查询市场活动列表（根据名称模糊查）");

        String aname = request.getParameter("aname");

       // ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<Activity> aList = activityService.getActivityListByName(aname);

        PrintJson.printJsonObj(response, aList);

    }

    @RequestMapping("/bund.do")
    private void bund(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行关联市场活动的操作");

        String cid = request.getParameter("cid");
        String aids[] = request.getParameterValues("aid");

        //ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        boolean flag = clueService.bund(cid,aids);

        PrintJson.printJsonFlag(response, flag);

    }
    @RequestMapping("/getActivityListByNameAndNotByClueId.do")

    private void getActivityListByNameAndNotByClueId(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("查询市场活动列表（根据名称模糊查+排除掉已经关联指定线索的列表）");

        String aname = request.getParameter("aname");
        String clueId = request.getParameter("clueId");

        Map<String,String> map = new HashMap<String,String>();
        map.put("aname", aname);
        map.put("clueId", clueId);

       // ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<Activity> aList = activityService.getActivityListByNameAndNotByClueId(map);

        PrintJson.printJsonObj(response, aList);



    }

    @RequestMapping("/unbund.do")
    private void unbund(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行解除关联操作");

        String id = request.getParameter("id");

        //ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        boolean flag = clueService.unbund(id);

        PrintJson.printJsonFlag(response, flag);

    }

    @RequestMapping("/getActivityListByClueId.do")
    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("根据线索id查询关联的市场活动列表");

        String clueId = request.getParameter("clueId");

        //ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<Activity> aList = activityService.getActivityListByClueId(clueId);

        PrintJson.printJsonObj(response, aList);


    }

    @RequestMapping("/detail.do")
    private void detail( String id,HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("跳转到线索详细信息页");

        Clue c = clueService.detail(id);

        request.setAttribute("c", c);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request, response);


    }

    @RequestMapping("/save.do")
    private void save( HttpServletRequest request, HttpServletResponse response, Clue c) {

        System.out.println("执行线索添加操作");

        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        c.setId(id);
        c.setCreateTime(createTime);
        c.setCreateBy(createBy);

        boolean flag = clueService.save(c);

        PrintJson.printJsonFlag(response, flag);

    }

    @RequestMapping("/getUserList.do")
    private void getUserList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("取得用户信息列表");

        List<User> uList = userService.getUserList();

        PrintJson.printJsonObj(response, uList);

    }

}




































