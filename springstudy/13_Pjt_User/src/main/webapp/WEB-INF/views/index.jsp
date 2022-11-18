<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
</head>
<body>
	<c:if test="${loginUser == null}">
		<a href="${contextPath}/user/agree">회원가입 페이지</a>
		<a href="${contextPath}/user/login/form?">로그인 페이지</a>
	</c:if>	
	
	<c:if test="${loginUser != null }">
		<div>
			<a href="${contextPath}/user/check/form">${loginUser.name}</a>님 반갑습니다.
		</div>
		
		<a href="${contextPath}/user/logout" >로그아웃</a>
		
		<a href="javascript:fn_abc()">회원탈퇴</a>
		<form id="lnk_retire" action="${contextPath}/user/retire" method="post"></form>
		<script>
			function fn_abc(){
					if(confirm('탈퇴하시겠습니까?') == false){
						$('#lnk_retire').submit();
					}
			}
			
		</script>
	</c:if>	
	
</body>
</html>