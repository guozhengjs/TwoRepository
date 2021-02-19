package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int update(Clue c) ;

    int save(Clue c);

    Clue detail(String id);

    Clue getById(String clueId);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    int delete(String clueId);

    int deleteClue(String[] ids);

    Clue getClueById(String id);

    int deleteClueTwo(String id);
}
