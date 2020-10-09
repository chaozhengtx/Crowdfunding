package cn.cz.test;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SLF4JTest {

	public static void main(String[] args) {
		Logger log = LoggerFactory.getLogger(SLF4JTest.class);
		log.debug("debug..."); //用于调试程序
		log.debug("debug信息={}, 编号={}", "debug", 1);//{} 作为占位符，后边的参数放在占位符处，避免了拼接字符串
		log.info("info...");//用于请求处理提示消息
		log.warn("warn...");//用于警告处理提示消息
		log.error("error...");//用于异常处理提示消息
		log.error("==>>"+log.getClass());
	} 

}
