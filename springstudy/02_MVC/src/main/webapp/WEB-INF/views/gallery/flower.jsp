<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%--
	css나 js 같은 정적 파일도
	servlet-context.xml 파일의 <resources mapping="/resources/**" location="/resources/" /> 태그에 의해서
	 /resources/ 디렉터리에서 찾는다.
--%>


<link rel="stylesheet" href="${contextPath}/resources/css/style.css">

<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script>
	$(document).ready(function(){
		$('#title').text('예쁜 꽃 구경하세요');
		$('#image').attr('src', '${contextPath}/resources/images/flower1.jpg').attr('width', '200px');
	});
</script>

</head>
<body>

	<div class="wrap">
		<h1 id="title"></h1>
		<img id="image">
	</div>

</body>
</html>