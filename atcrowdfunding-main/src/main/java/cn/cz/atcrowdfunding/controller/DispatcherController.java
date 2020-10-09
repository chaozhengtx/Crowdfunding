package cn.cz.atcrowdfunding.controller;

import java.awt.Menu;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.cz.atcrowdfunding.bean.TAdmin;
import cn.cz.atcrowdfunding.bean.TMenu;
import cn.cz.atcrowdfunding.service.TAdminService;
import cn.cz.atcrowdfunding.service.TMenuService;
import cn.cz.atcrowdfunding.util.Const;

@Controller
public class DispatcherController {
	
	Logger log = LoggerFactory.getLogger(DispatcherController.class);
	
	@Autowired
	TAdminService adminService;
	
	@Autowired
	TMenuService menuService;
	
	@RequestMapping("/main")
	public String main(HttpSession session) {
		
		if(session == null) {
			return "redirect:/login";
		}
		
		// 存放父菜单
		List<TMenu> menuList = (List<TMenu>) session.getAttribute(Const.MENU_LIST);
		
		if(menuList == null) {
			log.debug("执行方法");
			System.out.println("测试方法是否执行");
			menuList = menuService.listMenuAll();
			session.setAttribute(Const.MENU_LIST, menuList);
		}
		log.debug("跳转到登陆成功页面...");
		return "main";
	}
	
	@RequestMapping("/index")
	public String index() {
		log.debug("跳转到index页面...");
		return "index";
	}
	
	@RequestMapping("/login")
	public String adminLogin() {
		log.debug("跳转到管理员登陆页面...");
		return "login";
	}
	
	
//	@RequestMapping("/loginout")
//	public String loginout(HttpSession session) {
//		log.debug("退出系统...");
//		if(session != null) {
//			session.removeAttribute(Const.LOGIN_ADMIN);
//			session.invalidate();
//		}
//		return "redirect:/index";
//	}
//	
//	@RequestMapping("/doLogin")
//	public String doLogin(String loginacct,String userpswd,HttpSession session,Model model) {
//		log.debug("开始登录...");
//		
//		log.debug("loginacct={}",loginacct);
//		log.debug("userpswd={}",userpswd);
//		
//		
//		Map<String,Object> paramMap = new HashMap<String,Object>(); 
//		paramMap.put("loginacct", loginacct);
//		paramMap.put("userpswd", userpswd);
//		
//		try {
//			TAdmin admin = adminService.getTAdminByLogin(paramMap);
//			session.setAttribute(Const.LOGIN_ADMIN, admin);			
//			log.debug("登录成功...");
//			//return "main"; //避免表单重复提交，采用重定向
//			return "redirect:/main";// 重定向时，需要建立/main的映射
//		} catch (Exception e) {
//			e.printStackTrace();
//			log.debug("登录失败={}...",e.getMessage());
//			model.addAttribute("message",e.getMessage());
//			return "adminLogin";
//		}
//	}
	
	
	
}
