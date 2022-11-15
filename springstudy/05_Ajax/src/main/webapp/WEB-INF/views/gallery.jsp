<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
</head>
<body>

	<h1>종길이 같은 귀여운 동물 보세요</h1>
	<div>
	<!--
		절대 경로로 ㅇ미지를 img태그로 표시하기
		 1 요청
		 	경로 + 이미지 파라미터로 전송
		 2 응답
		  이미지의 byte[]
		 	
	  -->
	</div>  
	<div id  = "galleries"></div>
	<script>
		for(let n = 1 ; n <= 10; n++){
			$('<div>')
			.append($('<img>')
				.attr('src', '${contextPath}/image/display?path=' + encodeURIComponent('C:\\GDJ\\images') + '&filename=animal' + n + '.jpg')
				.attr('width' , '200px'))
			.appendTo('#galleries');
		}
		
	</script>
	
</body>
</html>