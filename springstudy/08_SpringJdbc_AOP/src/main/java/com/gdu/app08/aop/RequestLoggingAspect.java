package com.gdu.app08.aop;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/*
	AOP 기본 용어
	1. 조인포인트 : AOP를 동작시킬 수 있는 메소드 전체      (목록, 상세, 삽입, 수정, 삭제 메소드)
	2. 포인트컷   : 조인포인트 중에서 AOP를 동작시킬 메소드 (삽입, 수정, 삭제 메소드)
	3. 어드바이스 : 포인트컷에 동작시킬 AOP 동작 자체       (로그, 트랜잭션 등)
*/

@Component  // RequestLoggingAspect 클래스를 Bean으로 만들어 두시오.
@Aspect     // 안녕. 난 Aspect야. AOP 동작하려면 내가 필요해.
@EnableAspectJAutoProxy  // 안녕. 난 Aspect를 자동으로 동작시키는 애너테이션이야.
public class RequestLoggingAspect {
	
	// 로거
	private static final Logger LOGGER = LoggerFactory.getLogger(RequestLoggingAspect.class);

	// 포인트컷 표현식
	/*
		1. 기본 형식
			execution(리턴타입 패키지.클래스.메소드(매개변수))
		
		2. 의미
			1) 리턴타입
				(1) *
				(2) void
				(3) !void
			2) 매개변수
				(1) ..  모든 매개변수
				(2) *   1개의 모든 매개변수
	*/
	
	// 포인트컷 설정
	// 컨트롤러의 모든 메소드를 포인트컷으로 지정하겠다.
	// 컨트롤러의 모든 메소드에서 어드바이스(콘솔에 로그 찍기)가 동작한다.
	@Pointcut("execution(* com.gdu.app08.controller.BoardController.*(..))")  
	public void setPointCut() { }  // 오직 포인트컷 대상을 결정하기 위한 메소드(이름 : 아무거나, 본문 : 없음)
	
	// 어드바이스 설정
	// 어드바이스 실행 시점
	// @Before, @After, @AfterReturning, @AfterThrowing, @Around
	@Around("setPointCut()")  // setPointCut() 메소드에 설정된 포인트컷에서 동작하는 어드바이스
	public Object executeLogging(ProceedingJoinPoint joinPoint) throws Throwable {  // @Around는 반드시 ProceedingJoinPoint 타입의 조인포인트를 선언해야 함, 나머지는 JoinPoint 선언 가능
		
		// HttpServletRequest를 사용하는 방법
		ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();
		HttpServletRequest request = servletRequestAttributes.getRequest();
		
		// HttpServletRequest를 Map으로 바꾸기
		// 파라미터는 Map의 key가 되고, 값은 Map의 value가 된다.
		Map<String, String[]> map = request.getParameterMap();
		String params = "";
		if(map.isEmpty()) {
			params += "[No Parameter]";
		} else {
			for(Map.Entry<String, String[]> entry : map.entrySet()) {				
				params += "[" + entry.getKey() + "=" + String.format("%s", (Object[])entry.getValue()) + "]";
			}
		}
		
		// 어드바이스는 proceed() 메소드 실행 결과를 반환
		Object result = null;
		try {
			result = joinPoint.proceed();  // @Around는 ProceedingJoinPoint 실행을 개발자가 직접 해야 하고, 나머지 어드바이스는 자동으로 JoinPoint가 실행된다.
		} catch (Exception e) {
			throw e;
		} finally {
			// 무조건 실행되는 영역(여기서 로그를 찍는다.)
			// 치환문자 : {}
			LOGGER.debug("{} {} {} > {}", request.getMethod(), request.getRequestURI(), params, request.getRemoteHost());
		}
		
		return result;
		
	}
	
}
