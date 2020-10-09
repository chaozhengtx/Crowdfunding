package cn.cz.atcrowdfunding.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.cz.atcrowdfunding.bean.TPermission;
import cn.cz.atcrowdfunding.service.TPermissionService;

@Controller
public class TPermissionController {

	@Autowired
	TPermissionService permissionService;
	
	@ResponseBody
	@RequestMapping("/permission/toAdd")
	public String toAdd(TPermission permission) {
		
		permissionService.savePermission(permission);
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/permission/getAllPermission")
	public List<TPermission> getAllPermission() {
		
		return permissionService.getAllPermission();
	}
	
	@RequestMapping("/permission/index")
	public String index() {
		return "permission/index";
	}
}
