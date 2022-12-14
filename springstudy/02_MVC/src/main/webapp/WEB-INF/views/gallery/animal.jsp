<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%-- 전체 경로를 작성해도 안 나옵니다. --%>
	<h1>나 좀 보세요</h1>
	<img src="file:src/main/webapp/resources/images/animal1.jpg" width="200px">

	<%--
		servlet-context.xml 파일을 보자.
		<resources mapping="/resources/**" location="/resources/" />
		mapping이 /resources/로 시작하면 /resources/ 디렉터리에서 찾으라는 뜻이다.
		
		아래 이미지 태그를 보자.
		<img src="${contextPath}/resources/images/animal2.jpg" width="200px">
		src 속성이 ${contextPath}로 시작했으므로 mapping이란 의미이다.
		/resources로 시작한 mapping이므로 /resources/ 디렉터리에서 해당 파일을 찾는다.
	--%>
	
	<h1>여기 예쁜 동물 좀 보세요</h1>
	<img src="${contextPath}/resources/images/animal2.jpg" width="200px">
	
	
	<%--
		servlet-context.xml 파일에
		<resources mapping="/assets/**" location="/assets/" /> 태그를 추가했으므로
		아래 이미지 태그는 /assets/으로 시작하는 mapping이므로
		/assets/ 디렉터리에서 찾는다.
	--%>
	<h1>저도 봐 주세요</h1>
	<img src="${contextPath}/assets/images/animal3.jpg" width="200px">

</body>
</html>