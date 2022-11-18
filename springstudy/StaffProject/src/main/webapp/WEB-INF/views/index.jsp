<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>

<script>
	$(function() {
		fn_staffList();
		fn_staffAdd();
		fn_find();
	});

	function fn_staffList() {
		$.ajax({
			type : 'get',
			url : '${contextPath}/list/json',
			dataType : 'json',
			success : function(resData) {
				$('#staff_list').empty();
				$.each(resData, function(i, staff) {
					/* 	var tr = '<tr>';
						tr += '<td>' + staff.sno + '</td>';
						tr += '<td>' + staff.name + '</td>';
						tr += '<td>' + staff.dept + '</td>';
						tr += '<td>' + staff.salary + '</td>';
						tr += '</tr>'
						$('#staff_list').apeend(tr); */
					$('<tr>')
					.append($('<td>').text(staff.sno))
					.append($('<td>').text(staff.name))
					.append($('<td>').text(staff.dept))
					.append($('<td>').text(staff.salary))
					.appendTo('#staff_list');
				});
			}
		});
	}

	function fn_staffAdd() {
		$('#btn_add').click(function() {
			if (/^[0-9]{5}$/.test($('#sno').val()) == false) {
				alert('사원번호는 5자리 숫자입니다.');
				return;
			}
			if (/^[가-힣]{3,5}$/.test($('#dept').val()) == false) {
				alert('부서는 3~5자리 한글입니다.');
				return;
			}
			$.ajax({
				type : 'post',
				url : '${contextPath}/add',
				data : $('#frm_add').serialize(),
				/* data : 'sno=' + $('#sno').val() +  '&name=' + $('#name').val() + '&dept=' + $('#dept').val(), */
				dataType : 'text',
				success : function(resData) {
					$('#staff_list').empty();
					alert(resData);	
					fn_staffList();
					$('#sno').val('');
					$('#name').val('');
					$('#dept').val('');
					/* document.getElementByid('sno').value = ''; * */
				},
				error : function(jqXHR) {
					alert(jqXHR.responseText);
				}
			});
		});
	}
	
	function fn_find() {
		$('#btn_find').click(function() {
			$.ajax({
				type : 'get',
				url : '${contextPath}/query.json',
				data : $('#frm_find').serialize(),
				dataType : 'json',
				success : function(resData) {
					console.log(resData);
					$('#staff_list').empty();
					alert('사원 조회가 성공했습니다.');
					$('<tr>')
					.append($('<td>').text(resData.sno))
					.append($('<td>').text(resData.name))
					.append($('<td>').text(resData.dept))
					.append($('<td>').text(resData.salary))
					.appendTo('#staff_list');
				},
				error : function(jqXHR) {
					alert('조회된 사원 정보가 없습니다.');
				}
			});
		});
	}

	
	
	
	$(document).ready(function() {
		$('#btn_findAll').click(function() {
			fn_staffList()
		});
	})
</script>
</head>
<body>

	<h3>사원 등록</h3>
	<form id="frm_add">
		<input type="text" id="sno" name="sno" placeholder="사원번호"> 
		<input type="text" id="name" name="name" placeholder="사원명"> 
	    <input type="text" id="dept" name="dept" placeholder="부서명"> 
		<input type="button" value="등록" id="btn_add">
	</form>

	<h3>사원 조회</h3>
	<form id="frm_find">
		<input type="text" id="sno" name="query" placeholder="사원번호"> 
		<input type="button" value="조회" id="btn_find"> 	
		<input type="button" value="전체" id="btn_findAll">
	</form>

	<h3>사원 목록</h3>
	<table border="1">
		<thead>
			<tr>
				<td>사원번호</td>
				<td>사원명</td>
				<td>부서명</td>
				<td>연봉</td>
			</tr>
		</thead>
		<tbody id="staff_list">

		</tbody>
	</table>
</body>
</html>