package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    int deleteById(String id) ;

    List<ClueRemark> getListByClueId(String clueId);

    int delete(ClueRemark clueRemark);

    int countRemarkByCids(String[] ids);

    int deleteRemarkByCids(String[] ids);

    int countRemarkByCid(String id);

    int deleteRemarkByCid(String id);

    int saveRemark(ClueRemark ar);

    int updateRemark(ActivityRemark ar);
}
