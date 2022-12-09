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
<script>
	$(function(){
	
	});

</script>
</head>
<body>
	<h1>회원 관리</h1>
	<div>
		
		<div>
			<label for="id">
				아이디 <input type="text" id="id">
			</label>
		</div>
		
		<div>
			<label for="name">
				이름 <input type="text" id="name">
			</label>
		</div>
		
		<div>
			<span>성별</span>
			<label for="male">
				 <input type="radio" id="gander" id="male">남자
			</label>
			<label for="female">
				 <input type="radio" id="gander" id="female">남자
			</label>
		</div>
		
		<div>
			<label for="address">
				주소 
				<select id="address">
					<option value="">선택</option>
					<option value="서울">서울</option>
					<option value="경기">경기</option>
					<option value="인천">인천</option>
				</select>
			</label>
		</div>
		
		<div>
			<input type="button" value="초기화" id="btn_init">
			<input type="button" value="등록하기" id="btn_add">
			<input type="button" value="수정하기" id="btn_modify">
		</div>
	</div>
	<hr>
	<div>
		<input type="button" value="선택삭제" id="btn_remove">
		<table border="1">
			<thead>
				<tr>
					<td><input type="checkbox" id="check_all"> </td>
					<td>아이디</td>
					<td>이름</td>
					<td>성별</td>
					<td>주소</td>
					<td></td>
				</tr>
			</thead>
			<tbody id="member_list"></tbody>
			<tfoot>
				<tr>
					<td colspan="6">
						<div id="paging"></div>
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
</body>
</html>