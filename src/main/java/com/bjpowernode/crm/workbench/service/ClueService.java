package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

/**
 * Author 北京动力节点
 */
public interface ClueService {
    boolean save(Clue c);

    Clue detail(String id);

    boolean unbund(String id);

    boolean bund(String cid, String[] aids);


    boolean convert(String clueId, Tran t, String createBy);

    PaginationVO<Clue> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    List<ClueRemark> getClueRemarkById(String id);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue c);

    Clue getClueById(String id);

    boolean deleteTwo(String id);

    boolean saveRemark(ClueRemark ar);

    boolean deleteRemark(String id);

    boolean updateRemark(ActivityRemark ar);
}
