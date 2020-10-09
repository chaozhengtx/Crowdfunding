package cn.cz.atcrowdfunding.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.cz.atcrowdfunding.bean.TPermission;
import cn.cz.atcrowdfunding.mapper.TPermissionMapper;
import cn.cz.atcrowdfunding.service.TPermissionService;

@Service
public class TPermissionServiceImpl implements TPermissionService {

	@Autowired
	TPermissionMapper permissionMapper;
	
	@Override
	public List<TPermission> getAllPermission() {
		return permissionMapper.selectByExample(null);
	}

	@Override
	public void savePermission(TPermission permission) {
		permissionMapper.insertSelective(permission);
	}

}
