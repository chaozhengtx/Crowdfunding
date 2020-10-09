package cn.cz.atcrowdfunding.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.github.pagehelper.PageInfo;

import cn.cz.atcrowdfunding.bean.TRole;
import cn.cz.atcrowdfunding.bean.TRoleExample;
import cn.cz.atcrowdfunding.bean.TRolePermissionExample;
import cn.cz.atcrowdfunding.mapper.TAdminRoleMapper;
import cn.cz.atcrowdfunding.mapper.TRoleMapper;
import cn.cz.atcrowdfunding.mapper.TRolePermissionMapper;
import cn.cz.atcrowdfunding.service.TRoleService;

@Service
public class TRoleServiceImpl implements TRoleService {
	
	@Autowired
	TRoleMapper roleMapper;
	
	@Autowired
	TAdminRoleMapper adminRoleMapper;
	
	@Autowired
	TRolePermissionMapper rolePermissionMapper;

	@Override
	public PageInfo<TRole> getRoleAll(Map<String, Object> paramMap) {
		
//		String condition = (String) paramMap.get("condition");
//		
//		List<TRole> roleList = null;
//		
//		TRoleExample example = new TRoleExample();
//
//		if(!StringUtils.isEmpty(condition)) {
//			// 模糊查询，注意给condition两边加"%"
//			example.createCriteria().andNameLike("%"+condition+"%");
//		}
//
//		roleList = roleMapper.selectByExample(example);
//		
//		PageInfo<TRole> page = new PageInfo<TRole>(roleList,5);
//		
//		return page;
		
		String condition = (String)paramMap.get("condition");
		
		List<TRole> list = null ;
		
		if(StringUtils.isEmpty(condition)) {
			list = roleMapper.selectByExample(null);
		}else {
			
			TRoleExample example = new TRoleExample();
			example.createCriteria().andNameLike("%"+condition+"%");
			
			list = roleMapper.selectByExample(example);
		}
		
		PageInfo<TRole> page = new PageInfo<TRole>(list,5);
		
		return page;
	}

	@Override
	public void saveRole(String addName) {
		
		TRole role = new TRole();
		
		role.setName(addName);
		
		roleMapper.insertSelective(role);
	}

	@Override
	public void updateRole(TRole role) {
		roleMapper.updateByPrimaryKeySelective(role);
	}

	@Override
	public TRole getTRoleById(Integer id) {
		
		TRole role = roleMapper.selectByPrimaryKey(id);
		
		return role;
	}

	@Override
	public void deleteRoleById(Integer id) {
		roleMapper.deleteByPrimaryKey(id);
	}

	@Override
	public List<TRole> getAllRole() {

		
		
		return roleMapper.selectByExample(null);
	}

	@Override
	public List<Integer> getAssignRoleAdminId(String id) {
		return adminRoleMapper.getAssignRoleAdminId(id);
	}

	@Override
	public void saveAdminAndRole(Integer[] roleId, Integer adminId) {
		
		adminRoleMapper.saveAdminAndRole(roleId,adminId);
	}

	@Override
	public void updateAdminAndRole(Integer[] roleId, Integer adminId) {
		
		adminRoleMapper.deleteAdminAndRoleByAdminId(roleId,adminId);
	}

	@Override
	public List<Integer> listPermissionIdByRoleId(Integer roleId) {
		return rolePermissionMapper.listPermissionIdByRoleId(roleId);
	}

	@Override
	public void doAssignPermissionToRole(Integer roleId, List<Integer> ids) {

		//先删除之前分配过的，然后再重新分配所有打钩的
		TRolePermissionExample example = new TRolePermissionExample();
		example.createCriteria().andRoleidEqualTo(roleId);
		rolePermissionMapper.deleteByExample(example);
		
		rolePermissionMapper.saveRoleAndPermissionRelationship(roleId,ids);
	}

}
