package cn.com.myproject.sysuser.service.impl;

import cn.com.myproject.sysuser.dao.BatchSysUserRoleDao;
import cn.com.myproject.sysuser.entity.PO.SysUser;
import cn.com.myproject.sysuser.entity.PO.SysUserRole;
import cn.com.myproject.sysuser.entity.VO.SysUserVO;
import cn.com.myproject.sysuser.mapper.SysRoleMapper;
import cn.com.myproject.sysuser.mapper.SysUserMapper;
import cn.com.myproject.sysuser.mapper.SysUserRoleMapper;
import cn.com.myproject.sysuser.service.ISysUserService;
import cn.com.myproject.user.entity.PO.User;
import cn.com.myproject.user.mapper.UserMapper;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.util.StringUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liyang-macbook on 2017/6/21.
 */
@Service
public class SysUserService implements ISysUserService {

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private SysRoleMapper sysRoleMapper;

    @Autowired
    private SysUserRoleMapper sysUserRoleMapper;

    @Autowired
    private BatchSysUserRoleDao batchSysUserRoleDao;

    @Autowired
    private UserMapper userMapper;

    @Override
    public SysUserVO getByLoginName(String loginName) {
        SysUser user =  sysUserMapper.selectByLoginName(loginName);
        SysUserVO vo = null;
        if(null != user){
            vo = new SysUserVO(user);
            vo.setRoleIds(sysRoleMapper.getRoleIds(user.getUserId()));
        }
        return vo;
    }

    @Override
    public SysUserVO getByUserName(String userName) {
        SysUser user =  sysUserMapper.selectByUserName(userName);
        SysUserVO vo = null;
        if(null != user){
            vo = new SysUserVO(user);
            vo.setRoleIds(sysRoleMapper.getRoleIds(user.getUserId()));
        }
        return vo;
    }

    @Override
    public List<SysUser> getAll() {
        return null;
    }

    @Override
    public PageInfo<SysUserVO> getPage(int pageNum, int pageSize,String keyword) {
        List<SysUser> list = this.sysUserMapper.getPage(pageNum,pageSize,keyword);
        return convert(list);
    }

    private PageInfo<SysUserVO> convert(List<SysUser> list) {
        PageInfo<SysUser> info = new PageInfo(list);

        List<SysUser> _list = info.getList();
        info.setList(null);
        List<SysUserVO> __list = new ArrayList<>(10);

        PageInfo<SysUserVO> _info = new PageInfo();
        BeanUtils.copyProperties(info,_info);
        if(null !=_list && _list.size() != 0) {
            for(SysUser user : _list) {
                __list.add(new SysUserVO(user));
            }
            _info.setList(__list);
        }

        return _info;
    }

    @Override
    public void addUsers(SysUser sysUser, List<SysUserRole> sysUserRoleList) {
        sysUserMapper.addUsers(sysUser);
        if(null != sysUserRoleList && sysUserRoleList.size()>0){
            batchSysUserRoleDao.saveBatch(sysUserRoleList);
        }
    }

    @Override
    public void updateUsers(SysUser sysUser, List<SysUserRole> sysUserRoleList) {
        sysUserMapper.updateUser(sysUser);
        if(StringUtil.isNotEmpty(sysUser.getUserId()) && StringUtil.isNotEmpty(sysUser.getUserName())){
            sysUserRoleMapper.deleteSysUserRole(sysUser.getUserId());
            batchSysUserRoleDao.saveBatch(sysUserRoleList);
        }
    }

    @Override
    public List<SysUser> findAll() {
        List<SysUser> findAllList =sysUserMapper .findAll();
        return findAllList;
    }

    @Override
    public SysUser findByUserId(String userId) {
        SysUser user = sysUserMapper.findByUserId(userId);
        return user;
    }

    @Override
    public Integer checkUsers(String userName) {
        return sysUserMapper.checkUsers(userName);
    }

    @Override
    public SysUser selectUsers(Integer id) {
        return sysUserMapper.selectUsers(id);
    }

    @Override
    public void delusers(Integer id) {
        sysUserMapper.delusers(id);
    }

    @Override
    public SysUser getSysUserByLoginName(String loginName){
        return sysUserMapper.selectByLoginName(loginName);
    }

    @Override
    public SysUser getSysUserByUserName(String userName){
        return sysUserMapper.selectByUserName(userName);
    }

    /**
     * 查询用户ID和用户名
     *
     * @return
     */
    @Override
    public List<User> searchUserIdAndName(){
        return userMapper.selectUserIdAndName();
    }

}