package cn.cz.atcrowdfunding.component;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import cn.cz.atcrowdfunding.bean.TAdmin;
import cn.cz.atcrowdfunding.bean.TAdminExample;
import cn.cz.atcrowdfunding.bean.TPermission;
import cn.cz.atcrowdfunding.bean.TRole;
import cn.cz.atcrowdfunding.mapper.TAdminMapper;
import cn.cz.atcrowdfunding.mapper.TPermissionMapper;
import cn.cz.atcrowdfunding.mapper.TRoleMapper;

@Component
public class SecurityUserDetailServiceImpl implements UserDetailsService {

	@Autowired
	TAdminMapper adminMapper;
	
	@Autowired
	TRoleMapper roleMapper;
	
	@Autowired
	TPermissionMapper permissionMapper;
	
	Logger log = LoggerFactory.getLogger(SecurityUserDetailServiceImpl.class);
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		// 1.查询用户对象
		TAdminExample example = new TAdminExample();
		example.createCriteria().andLoginacctEqualTo(username);
		List<TAdmin> list = adminMapper.selectByExample(example);
		
		if(list!=null && list.size()==1) {// 如果list不为空且大小为1，则说明查询到了
			TAdmin admin = list.get(0);
			Integer adminId = admin.getId();
			
			log.debug("用户信息是{}",admin);
			
			// 2.根据id查询角色集合
			List<TRole> roleList = roleMapper.listRoleByAdminId(adminId);
			
			log.debug("用户的角色为{}",roleList);
			
			// 3.查询权限集合
			List<TPermission> permissionList = permissionMapper.listPermissionByAdminId(adminId);
			
			log.debug("用户的权限有{}",permissionList);
			
			// 4.构建用户所有权限集合------->（ROLE_角色+权限）
			Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();
			
			for(TRole role : roleList) {
				authorities.add(new SimpleGrantedAuthority("ROLE_"+role.getName()));
			}
			
			for (TPermission permission : permissionList) {
				authorities.add(new SimpleGrantedAuthority(permission.getName()));
			}
			
			log.debug("用户总权限集合{}",authorities);
			
			return new TSecurityAdmin(admin,authorities);
		} else {
			return null;
		}
		
	}

}

// $2a$10$5Jz45kKvG2IosdOiQ2mudOeOeZXpMAYEN5YK6UNJyI5csk86Y1nrS
