package cn.com.myproject.sysuser.service;

import cn.com.myproject.sysuser.entity.PO.SysRegion;

import java.util.List;

/**
 * Created by CQC on 2017.9.1.
 */
public interface ISysRegionService {

    int deleteByPrimaryKey(String regionId);

    int insert(SysRegion record);

    int insertSelective(SysRegion record);

    SysRegion selectByPrimaryKey(String regionId);

    List<SysRegion> selectByPid(String pid);

    int updateByPrimaryKeySelective(SysRegion record);

    int updateByPrimaryKey(SysRegion record);

    List<SysRegion> select_countries_code();

}
