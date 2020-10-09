package cn.cz.atcrowdfunding.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cn.cz.atcrowdfunding.util.Const;

/**
 * 监听application对象的生成和销毁
 * @author Qyylr
 *
 */
public class SystemUpInitListener implements ServletContextListener {

	Logger log = LoggerFactory.getLogger(SystemUpInitListener.class);
	
	/**
	 * application创建时执行
	 */
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		ServletContext application = sce.getServletContext();
		String contextPath = application.getContextPath();
		log.debug("contextPath=========================="
				+ "====================================="
				+ "====================================={}",contextPath);
		application.setAttribute(Const.PATH, contextPath);
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		log.debug("application销毁");
	}

}
