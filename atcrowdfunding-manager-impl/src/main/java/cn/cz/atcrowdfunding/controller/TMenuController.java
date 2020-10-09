package cn.cz.atcrowdfunding.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.cz.atcrowdfunding.bean.TMenu;
import cn.cz.atcrowdfunding.service.TMenuService;

@Controller
public class TMenuController {
	
	@Autowired
	TMenuService menuService;
	
	
	@ResponseBody
	@RequestMapping("/menu/delete")
	public String delete(Integer id) {
		
		menuService.deleteMenuById(id);
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/menu/doUpdate")
	public String doUpdate(TMenu menu) {
		
		menuService.updateMenu(menu);
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/menu/getMenuById")
	public TMenu getMenuById(Integer id) {
		
		TMenu menu = menuService.getMenuById(id);
		
		return menu;
	}
	
	@ResponseBody
	@RequestMapping("/menu/addMenu")
	public String addMenu(TMenu menu) {
		
		menuService.saveMenu(menu);
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/menu/getAllMenu")
	public List<TMenu> getAllMenu() {
		
		List<TMenu> menuList = menuService.listMenuAll();
		
		return menuList;
	}
	
	@RequestMapping("/menu/index")
	public String index() {
		return "menu/index";
	}
}
