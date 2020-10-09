package cn.cz.atcrowdfunding.service;

import java.util.List;

import cn.cz.atcrowdfunding.bean.TPermission;

public interface TPermissionService {

	List<TPermission> getAllPermission();

	void savePermission(TPermission permission);

}
