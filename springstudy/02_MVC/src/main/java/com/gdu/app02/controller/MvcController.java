package com.gdu.app02.controller;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/*
	@Controller
	
	안녕. 난 컨트롤러야.
	@Component를 가지고 있어서 자동으로 컨테이너에 Bean으로 만들어 지고 스프링에 의해서 사용되지.
*/

@Controller
public class MvcController {


	// 메소드 1개 : 요청 1개와 응답 1개를 처리하는 단위
	
	
	/*
		@RequestMapping
		
		안녕. 난 요청을 인식하는 애너테이션이야.
		URL매핑과 요청 메소드(GET/POST 등)를 인식하지.
		
		속성
			1) value  : URLMapping
			2) method : RequestMethod
	*/
	
	
	
	// welcome 파일 작업하기
	// URLMapping으로 "/"를 요청하면 "/WEB-INF/views/index.jsp"를 열어준다.
	
	
	// 메소드 작성 방법
	// 1. 반환타입 : String (응답할 뷰(JSP)의 이름을 반환)
	// 2. 메소드명 : 아무 일도 안함. 맘대로 작성.
	// 3. 매개변수 : 그때그때 다름. (요청이 있으면 request, 응답을 만들면 response 등)
	
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String welcome() {
		
		return "index";  // DispatcherServlet의 ViewResolver에 의해서 해석된다.
		                 // prefix="/WEB-INF/views/"
		                 // suffix=".jsp"
		                 // prefix와 suffix에 의해서 "/WEB-INF/views/index.jsp"와 같이 해석되고 처리된다.
		
	}
	
	
	
	// <a href="${contextPath}/animal">
	@RequestMapping(value="/animal", method=RequestMethod.GET)
	public String 동물보러가기() {
		
		// /WEB-INF/views/ + gallery/animal + .jsp
		
		return "gallery/animal";
		
	}
	
	// @RequestMapping(value="/animal", method=RequestMethod.GET)
	// @RequestMapping(value="animal", method=RequestMethod.GET)   슬래시로 시작하지 않아도 됩니다.
	// @RequestMapping(value="/animal")                            GET은 없어도 됩니다.	
	// @RequestMapping("/animal")                                  하나만 작성하면 value로 인식합니다.
	// @RequestMapping("animal")                                   슬래시로 시작하지 않아도 됩니다.
	
	
	
	// <a href="${contextPath}/flower">
	@RequestMapping("/flower")
	public String 꽃보러가기() {
		
		// return "/gallery/flower"   슬래시(/)로 시작해도 됩니다.
		
		return "gallery/flower";   // 슬래시(/)로 시작하지 않아도 됩니다.
		
	}	
	
	
	
	// <a href="${contextPath}/response">
	@RequestMapping("response")
	public void 응답만들기(HttpServletRequest request, HttpServletResponse response) {  // 컨트롤러는 request와 response가 필요하면 언제든 매개변수로 선언해서 사용하면 된다.
		
		// 응답을 만들 때는 return 없이 void 처리한다.
		
		try {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('동물 보러 가자.');");
			out.println("location.href='" + request.getContextPath() + "/animal';");  // 이건 <a href="${contextPath}/animal">과 똑같이 처리되는 자바스크립트 코드
			out.println("</script>");
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
}
