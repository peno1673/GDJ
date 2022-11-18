package com.gdu.app13.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.gdu.app13.domain.SleepUserDTO;
import com.gdu.app13.service.UserService;

@Component
public class SleepUserCheckingInterceptor implements HandlerInterceptor {

	@Autowired
	private UserService userService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		String id = request.getParameter("id");
		
		SleepUserDTO sleepUser = userService.getSleepUserById(id);
		
		HttpSession session = request.getSession();
		session.setAttribute("sleepUser", sleepUser);
		
		
		if(sleepUser != null) {
//			System.out.println(sleepUser);
			response.sendRedirect(request.getContextPath() + "/user/sleep/display" );
			return false;
		} else {
			return true;
		}
	}

}
