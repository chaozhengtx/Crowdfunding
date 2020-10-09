package cn.cz.atcrowdfunding.service;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.PageInfo;

import cn.cz.atcrowdfunding.bean.TAdmin;
import cn.cz.atcrowdfunding.bean.TAdminRole;
import cn.cz.atcrowdfunding.bean.TRole;

public interface TAdminService {

	TAdmin getTAdminByLogin(Map<String, Object> paramMap);

	PageInfo listAdminPage(Map<String,Object> map);

	void saveAdmin(TAdmin admin);

	TAdmin getTAdminById(Integer id);

	void update(TAdmin admin);

	void singleDelete(Integer id);

	void deleteBatch(List<Integer> idList);

	List<TAdminRole> getAdminRole();


}
