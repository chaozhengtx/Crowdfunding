package cn.cz.atcrowdfunding.service;

import java.awt.Menu;
import java.util.List;

import cn.cz.atcrowdfunding.bean.TMenu;

public interface TMenuService {

	List<TMenu> listMenuAll();

	void saveMenu(TMenu menu);

	TMenu getMenuById(Integer id);

	void updateMenu(TMenu menu);

	void deleteMenuById(Integer id);

}
