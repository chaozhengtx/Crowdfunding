package cn.cz.atcrowdfunding.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.cz.atcrowdfunding.bean.TRole;
import cn.cz.atcrowdfunding.service.TRoleService;
import cn.cz.atcrowdfunding.util.Datas;

@Controller
public class TRoleController {
	
	Logger log = LoggerFactory.getLogger(TRoleController.class);
	
	@Autowired
	TRoleService roleService;
	
	
	
	
	
	@ResponseBody
	@RequestMapping("/role/doAssignPermissionToRole")
	public String doAssignPermissionToRole(Integer roleId, Datas ds) {
		
		log.debug("****************角色id是-------------------》{}",roleId);
		
		roleService.doAssignPermissionToRole(roleId, ds.getIds());
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/role/listPermissionIdByRoleId")
	public List<Integer> listPermissionIdByRoleId(Integer roleId) {
		
		List<Integer> list = roleService.listPermissionIdByRoleId(roleId);
		
		return list;
	}
	
	@RequestMapping("/role/index")
	public String index() {
		
		return "role/index";
	}
	
	@ResponseBody
	@RequestMapping("/role/getRoleById")
	public TRole update(Integer id) {
		
		return roleService.getTRoleById(id);
	}
	
	@ResponseBody
	@RequestMapping("/role/delete")
	public String delete(Integer id) {
		
		roleService.deleteRoleById(id);
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/role/doUpdate")
	public String doUpdateBtn(TRole role) {
		
		roleService.updateRole(role);
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/role/doAdd")
	public String doAdd(String addName) {
		
		roleService.saveRole(addName);
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/role/loadData")
	public PageInfo<TRole> loadData(@RequestParam(value="pageNum", required=false, defaultValue="1") Integer pageNum,
									@RequestParam(value="pageSize", required=false, defaultValue="2") Integer pageSize,
									@RequestParam(value="condition", required=false, defaultValue="") String condition) {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("condition", condition);
		
		PageHelper.startPage(pageNum, pageSize);
		
		PageInfo<TRole> page = roleService.getRoleAll(paramMap);;
		
		return page;
	}
}
