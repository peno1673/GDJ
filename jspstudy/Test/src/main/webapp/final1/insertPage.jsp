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
		
		$('.frm_write').submit(function(event){
			if($('#title').val() == ''  &&  $('#writer').val() == '' &&  $('#content').val() == ''){
				alert('제목과 작성자 내용은 필수입니다.');
				event.preventDefault();
				return;
			}
		});
		
		$('.btn_list').click(function(event){
			location.href = '${contextPath}/final1/selectBoardlist.do';
		});
		
	});
</script>
<title>삽입</title>
</head>
<body>
	<form class="frm_write" action="${contextPath}/final1/insert.do" method="POST">
		<table border="1">
			<tr>
				<td>작성자</td>
				<td><textarea name="writer"  class="writer" rows="1" cols="30"></textarea></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><textarea name="title" class="title" rows="1" cols="30"></textarea></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="content" class="content" rows="10" cols="50"></textarea></td>
			</tr>
			<tr>
				<td><input type="submit" value="등록">
				<td>
				<td><input type="button" value="목록" class= "btn_list">
				<td>
			</tr>
		</table>
	</form>
</body>
</html>