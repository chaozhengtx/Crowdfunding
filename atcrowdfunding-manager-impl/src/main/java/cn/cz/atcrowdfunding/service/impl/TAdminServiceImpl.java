package cn.cz.atcrowdfunding.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;

import cn.cz.atcrowdfunding.bean.TAdmin;
import cn.cz.atcrowdfunding.bean.TAdminExample;
import cn.cz.atcrowdfunding.bean.TAdminExample.Criteria;
import cn.cz.atcrowdfunding.bean.TAdminRole;
import cn.cz.atcrowdfunding.bean.TRole;
import cn.cz.atcrowdfunding.exceptioin.LoginException;
import cn.cz.atcrowdfunding.mapper.TAdminMapper;
import cn.cz.atcrowdfunding.mapper.TAdminRoleMapper;
import cn.cz.atcrowdfunding.service.TAdminService;
import cn.cz.atcrowdfunding.util.AppDateUtils;
import cn.cz.atcrowdfunding.util.Const;
import cn.cz.atcrowdfunding.util.MD5Util;

@Service
public class TAdminServiceImpl implements TAdminService {
	
	@Autowired
	TAdminMapper adminMapper;
	
	@Autowired
	TAdminRoleMapper adminRoleMapper;

	@Override
	public TAdmin getTAdminByLogin(Map<String, Object> paramMap) {
		
		// 1.密码加密
		
		// 2.查询用户
		String loginacct = (String)paramMap.get("loginacct");
		String userpswd = (String)paramMap.get("userpswd");
		
		// 条件查询对象
		TAdminExample example = new TAdminExample();
		// 绑定条件
		example.createCriteria().andLoginacctEqualTo(loginacct);
		// 根据条件查询
		List<TAdmin> list = adminMapper.selectByExample(example);
		
		// 3.判断list是否为空，就是判断用户是否存在
		if(list == null || list.size() == 0) {
			throw new LoginException(Const.LOGIN_LOGINACCT_ERROR);
		}
		
		TAdmin admin = list.get(0);
		
		// 4.判断密码是否一致
		if(!(MD5Util.digest(userpswd)).equals(admin.getUserpswd())) {
			throw new LoginException(Const.LOGIN_USERPSWD_ERROR);
		}
		
		// 5.返回结果
		return admin;
	}

	/**
	 * 查询所有管理员信息
	 */
	@Override
	public PageInfo<TAdmin> listAdminPage(Map<String,Object> map) {
		
		String condition = (String)map.get("condition");

		TAdminExample example = new TAdminExample();
		
		if(!"".equals(condition)) {
			example.createCriteria().andLoginacctLike("%"+condition+"%");
			
			Criteria criteria1 = example.createCriteria();
			criteria1.andUsernameLike("%"+condition+"%");
			
			Criteria criteria2 = example.createCriteria();
			criteria2.andEmailLike("%"+condition+"%");
			
			example.or(criteria1);
			example.or(criteria2);
		}
		
		example.setOrderByClause("createtime desc");
		
		List<TAdmin> list = adminMapper.selectByExample(example);
		
		PageInfo<TAdmin> page = new PageInfo<TAdmin>(list,5);
		
		return page;
	}

	@Override
	public void saveAdmin(TAdmin admin) {
		
		admin.setUserpswd(MD5Util.digest(Const.DEFAULT_USERPSWD));
		
		admin.setCreatetime(AppDateUtils.getFormatTime());
		
		// 动态Sql,用选择性的保存，如果字段有null值，则不参与保存sql语句
		adminMapper.insertSelective(admin);
	}

	@Override
	public TAdmin getTAdminById(Integer id) {
		return adminMapper.selectByPrimaryKey(id);
	}

	@Override
	public void update(TAdmin admin) {
		// 有选择性更新
		adminMapper.updateByPrimaryKeySelective(admin);
	}

	@Override
	public void singleDelete(Integer id) {
		adminMapper.deleteByPrimaryKey(id);
	}

	@Override
	public void deleteBatch(List<Integer> idList) {
		adminMapper.deleteBatch(idList);
	}

	@Override
	public List<TAdminRole> getAdminRole() {
		return adminRoleMapper.selectByExample(null);
	}

}
