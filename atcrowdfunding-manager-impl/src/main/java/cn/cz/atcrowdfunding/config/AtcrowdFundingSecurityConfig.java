package cn.cz.atcrowdfunding.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;

@EnableGlobalMethodSecurity(prePostEnabled=true) // 全局权限注解
@EnableWebSecurity
@Configuration
public class AtcrowdFundingSecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Autowired
	UserDetailsService userDetailsService; // 服务对象
	
	// 设置请求相关
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		// super.configure(http);
		
		http.authorizeRequests().antMatchers("/static/**", "/welcome.jsp", "/tiLogin").permitAll()
				.anyRequest().authenticated(); // 剩下的都需要验证
		
		http.formLogin().loginPage("/toLogin") // 去到指定的登录页
				.usernameParameter("loginacct") // 指定登录名
				.passwordParameter("userpawd") // 指定登陆密码
				.loginProcessingUrl("/login") // 处理登陆页面
				.defaultSuccessUrl("/main"); // 默认登录成功页面
		
		http.csrf().disable(); 
		
		http.logout().logoutSuccessUrl("/index");
		
		http.exceptionHandling().accessDeniedHandler(new AccessDeniedHandler() {
			
			@Override
			public void handle(HttpServletRequest request, HttpServletResponse response,
					AccessDeniedException accessDeniedException) throws IOException, ServletException {

				String type = request.getHeader("X-Requested-With");
				
				if ("X-Requested-With".equals(type)) {
					// 针对Ajax请求
					response.getWriter().print("403");
				} else {
					// 针对同步请求
					request.getRequestDispatcher("/WEB-INF/jsp/error/error403.jsp").forward(request, response);
				}
				
			}
		});
		
		http.rememberMe();
	}
	
	// 设置认证相关
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		// super.configure(auth);
		
		// 
		auth.userDetailsService(userDetailsService).passwordEncoder(new BCryptPasswordEncoder());
	}
	
}
