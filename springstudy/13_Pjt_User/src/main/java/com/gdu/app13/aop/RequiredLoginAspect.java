package com.gdu.app13.aop;

import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.request.ServletWebRequest;

@Component
@EnableAspectJAutoProxy
@Aspect
public class RequiredLoginAspect {

	@Pointcut("execution(* com.gdu.app13.controller.*Controller.requiredLogin_*(..))")
	public void requiredLogin() {}
		
	@Before("requiredLogin()") //포인트 컷 실행 전에 requiredLogin() 메소드 수행
	public void requiredLoginHandler (JoinPoint joinPoint) throws Throwable{
		// 로그인이 되어 있는지 확인하기 위해서 session이 필요하므로,
		// request가 필요하다.
//		ServletWebRequest servletWebRequest = (ServletWebRequest)RequestContextHolder.getRequestAttributes();
		ServletRequestAttributes servletWebRequest = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();
		HttpServletRequest request = servletWebRequest.getRequest();
		HttpServletResponse response = servletWebRequest.getResponse();
		
		
		//세션
		HttpSession session = request.getSession();
		
		if(session.getAttribute("loginUser") == null) {
			System.out.println("로그인 x");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();

			out.println("<script>");
			out.println("if(confirm('로그인이 필요한 기능입니다. 로그인 하시겠습니까?')){");			
			out.println("location.href='" + request.getContextPath() + "/user/login/form';");
			out.println("} else {");
			out.println("history.back();");
			out.println("}");
			out.println("</script>");
			out.close();
		}
	}
}
