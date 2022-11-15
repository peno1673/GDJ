<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="../assets/js/jquery-3.6.1.min.js"></script>
<script>

$(document).ready(function(){
	$('.registration').click(function(event){
		location.href = '${contextPath}/final1/insertPage.do';
	});
});

</script>
<title>리스트</title>
</head>
<body>
	<table border="1">
			<tr>
				<td>순번</td>
				<td>작성자</td>
				<td>제목</td>
				<td>작성일</td>
			</tr>
			<c:forEach items="${boards}" var="b">
			<tr>
				<td>${b.boardNo}</td>
				<td>${b.writer}</td>
				<td><a href="${contextPath}/final1/detail.do?boardNo=${b.boardNo}">${b.title}</a></td>
				<td>${b.createDate}</td>
			</tr>
			</c:forEach>
			<tr>
				<td><input type="button" value="새글작성" class="registration"><td>
			</tr>
	</table>
	
	
</body>
</html>