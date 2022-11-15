<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>연락처 등록</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script>
	$(document).ready(function() {
		
		const frm=$('#frm_btn');
		
		$('#btn_list').click(function(){
			location.href= '${contextPath}/ctt/list';
		})
		
		$('#btn_add').click(function(event){
			if ($('#name').val() == '' || 
				$('#tel').val() == '' || 
				$('#addr').val() == '' ||
				$('#email').val() == '') {
						alert("필수 정보를 모두 입력하시오") 

						event.preventDefault();
						return;
			} else{
				frm.attr('action', '${contextPath}/ctt/add');
				frm.submit();
			}
		})
		
	});
</script>
</head>
<body>
	<div>
		<h1>연락처 등록</h1>
		<form id="frm_btn" method="post">
			<div>
				<label for="name"> 이름 </label> <br>
				<input type="text" name="name" id="name"> <br><br>
			</div>
			<div>
				<label for="tel"> 전화 </label>  <br>
				<input type="text" name="tel" id="tel"> <br><br>
			</div>
			<div>
				<label for="addr"> 주소 </label><br>
				<input type="text" name="addr" id="addr"> <br><br>
			</div>
			<div>
				<label for="email"> 이메일 </label> <br>
				<input type="text" name="email" id="email"> <br><br>
			</div>
			<div>
				<label for="note"> 비고 </label> <br>
				<input type="text" name="note" id="note"> <br><br>
			</div>
			<div>
				<input type="button" value="연락처 저장하기" id="btn_add"> 
				<input type="button" value="전체연락처" id="btn_list">
			</div>
		</form>
	</div>
</body>
</html>