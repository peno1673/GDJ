<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>연락처 보기</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script>
	$(document).ready(function() {
		
		const frm=$('#frm_btn');
		
		$('#btn_edit').click(function() {
			
			alert('연락처가 수정 되었습니다');
			frm.attr('action', '${contextPath}/ctt/edit');
			frm.submit();
			return;
		})

		$('#btn_remove').click(function() {
			if(confirm('삭제할까요?') ){
				frm.attr('action', '${contextPath}/ctt/remove');
				frm.submit();
				return;
			}
			
		})
		
		$('#btn_list').click(function(){
			location.href= '${contextPath}/ctt/list';
		})
		
		
		
	});
</script>
</head>
<body>
	<div>
		<h1>연락처 보기</h1>
		<form id="frm_btn" method="post">
			<input type="hidden" name="no" value="${contact.no}">
			<div>
				<label for="name"> 이름 </label> 
				<input type="text" name="name" id="name" value="${contact.name}"><br><br>
			</div>
			<div>
				<label for="tel"> 전화 </label> 
				<input type="text" name="tel" id="tel" value="${contact.tel}"><br><br>
			</div>
			<div>
				<label for="addr"> 주소 </label>
				<input type="text" name="addr" id="addr" value="${contact.addr}"><br><br>
			</div>
			<div>
				<label for="email"> 이메일 </label>
				<input type="text" name="email" id="email" value="${contact.email}"><br><br>
			</div>
			<div>
				<label for="note"> 비고 </label>
				<input type="text" name="note" id="note" value="${contact.note}"><br><br>
			</div>
			<div>
				<input type="button" value="수정하기" id="btn_edit"> 
				<input type="button" value="삭제하기" id="btn_remove"> 
				<input type="button" value="전체연락처" id="btn_list">
			</div>
		</form>
	</div>
</body>
</html>