package cn.cz.atcrowdfunding.service;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.PageInfo;

import cn.cz.atcrowdfunding.bean.TRole;

public interface TRoleService {

	PageInfo<TRole> getRoleAll(Map<String, Object> paramMap);

	void saveRole(String addName);

	void updateRole(TRole role);

	TRole getTRoleById(Integer id);

	void deleteRoleById(Integer id);

	List<TRole> getAllRole();

	List<Integer> getAssignRoleAdminId(String id);

	void saveAdminAndRole(Integer[] roleId, Integer adminId);

	void updateAdminAndRole(Integer[] roleId, Integer adminId);

	List<Integer> listPermissionIdByRoleId(Integer roleId);

	void doAssignPermissionToRole(Integer roleId, List<Integer> ids);

}
