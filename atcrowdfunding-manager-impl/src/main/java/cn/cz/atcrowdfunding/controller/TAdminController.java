package cn.cz.atcrowdfunding.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.cz.atcrowdfunding.bean.TAdmin;
import cn.cz.atcrowdfunding.bean.TRole;
import cn.cz.atcrowdfunding.service.TAdminService;
import cn.cz.atcrowdfunding.service.TRoleService;
import cn.cz.atcrowdfunding.util.Const;

@Controller
public class TAdminController {
	
	@Autowired
	TAdminService adminService;
	
	@Autowired
	TRoleService roleService;
	
	Logger log = LoggerFactory.getLogger(TAdminController.class);
	
	@ResponseBody
	@RequestMapping("/admin/doUnAssign")
	public String doUnAssign(Integer[] roleId, Integer adminId) {
		
		roleService.updateAdminAndRole(roleId,adminId);
		
		log.debug("跳转到添加页面...");
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/admin/doAssign")
	public String doAssign(Integer[] roleId, Integer adminId) {
		
		roleService.saveAdminAndRole(roleId,adminId);
		
		log.debug("跳转到添加页面...");
		return "ok";
	}
	
	@RequestMapping("/admin/assignRole")
	public String getAdminRole(String id,Model model) {
		
		// 1.查询所有角色信息
		List<TRole> allRoleList = roleService.getAllRole();
		
		// 2.按用户id查询改用户所拥有的角色id
		List<Integer> roleIdList = roleService.getAssignRoleAdminId(id);
		
		List<TRole> assignList = new ArrayList<TRole>();
		List<TRole> unAssignList = new ArrayList<TRole>();
		
		// 3.将已拥有的和为拥有的分类
		for (TRole tRole : allRoleList) {
			if(roleIdList.contains(tRole.getId())) {
				assignList.add(tRole);
			} else {
				unAssignList.add(tRole);
			}
		}
		
		model.addAttribute("assignList", assignList);
		model.addAttribute("unAssignList", unAssignList);
		
		log.debug("跳转到添加页面...");
		return "admin/assignRole";
	}

	@RequestMapping("/admin/index")
	public String index(@RequestParam(value="pageNum", required=false, defaultValue="1") Integer pageNum, 
						  @RequestParam(value="pageSize", required=false, defaultValue="2") Integer pageSize,
						  Model model,
						  @RequestParam(value="condition", required=false, defaultValue="") String condition) {
		
		Map<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("condition", condition);
		
		PageHelper.startPage(pageNum, pageSize);// 线程绑定
		PageInfo<TAdmin> page = adminService.listAdminPage(paramMap);
		
		model.addAttribute(Const.PAGE, page);
		
		log.debug("跳转到管理员信息页面...");
		
		return "admin/index";
	}
	
	@RequestMapping("/admin/toAdd")
	public String toAdd() {
		log.debug("跳转到添加页面...");
		return "admin/add";
	}
	
	@RequestMapping("/admin/doAdd")
	public String add(TAdmin admin) {
		
		adminService.saveAdmin(admin);
		
		return "redirect:/admin/index";
	}
	
	@RequestMapping("/admin/toUpdate")
	public String toUpdate(String pageNum, Integer id, Model model) {
		
		TAdmin admin = adminService.getTAdminById(id);
		
		model.addAttribute("admin", admin);
		
		log.debug("跳转到修改界面...");
		
		return "admin/update";
	}
	
	@RequestMapping("/admin/doUpdate")
	public String doUpdate(TAdmin admin) {
		
		adminService.update(admin);
		
		log.debug("跳转到列表...");
		
		return "redirect:/admin/index";
	}
	
	@RequestMapping("/admin/doDelete")
	public String doDelete(Integer pageNum, Integer id) {
		
		adminService.singleDelete(id);
		
		log.debug("跳转到列表...");
		
		return "redirect:/admin/index?pageNum="+pageNum;
	}
	
	@RequestMapping("/admin/deleteBatch")
	public String deleteBatchBtn(Integer pageNum, String ids) {
		List<Integer> idList = new ArrayList<Integer>();
		
		// 以","分隔字符串，放入数组
		String[] split = ids.split(",");
		
		// 把字符串数组转换成整数数组
		for (String idStr : split) {
			int id = Integer.parseInt(idStr);
			idList.add(id);
		}
		
		adminService.deleteBatch(idList);
		
		log.debug("跳转到列表...");
		
		return "redirect:/admin/index?pageNum="+pageNum;
	}
}
