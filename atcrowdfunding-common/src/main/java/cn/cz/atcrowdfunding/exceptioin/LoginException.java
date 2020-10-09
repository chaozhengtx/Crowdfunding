package cn.cz.atcrowdfunding.exceptioin;

// 继承运行时异常， 因为spring声明式事务只对运行时异常进行回滚
public class LoginException extends RuntimeException {
	
	public LoginException() {}
	
	public LoginException(String message) {
		super(message);
	}
	
}
