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
	
	$(document).ready(function(){
	
	/* function fn_getList(){ */
		$.ajax({
			type: 'get',
			url: '${contextPath}/searchAllMovies',
			/* data: '' */
			dataType: 'json',
			
			success : function(resData){
				alert(resData.message);
				$.each(resData.list, function(i, moive){
					console.log(i);
					$('<tr>')
					.append( $('<td>').text(moive.title) )
					.append( $('<td>').text(moive.genre) )
					.append( $('<td>').text(moive.description) )
					.append( $('<td>').text(moive.star) )
					.appendTo('#list');	
				})
			},
			error: function(jqXHR){
				$('#list').text(jqXHR.status);
			}
		})
		
/* 	} */
		$.ajax({
			type: 'get',
			url: '${contextPath}/searchAllMovies',
			/* data: '' */
			dataType: 'json',
			success : function(resData){
				console.log(resData);
				$.each(resData, function(i, moive){
					$('<tr>')
					.append( $('<td>').text(moive.title) )
					.append( $('<td>').text(moive.genre) )
					.append( $('<td>').text(moive.description) )
					.append( $('<td>').text(moive.star) )
					.appendTo('#list');	
				})
			},
			error: function(jqXHR){
			  alert(jqXHR.status);
			}
		})
		
	 	
		$('#btn_search').click(function(){
			$.ajax({
				type: 'get',
				url : '${contextPath}/searchMovie',
				data : $('#frm_search').serialize(),
				dataType : 'json',
				success : function(resData){
					console.log(resData);
					$('#list').empty(); 
					$.each(resData, function(i, moive){
						$('<tr>')
						.append( $('<td>').text(moive.title) )
						.append( $('<td>').text(moive.genre) )
						.append( $('<td>').text(moive.description) )
						.append( $('<td>').text(moive.star) )
						.appendTo('#list');	
					})
				},
				error: function(jqXHR){
					alert('검색 결과가 없습니다.');
					
				}
			})
		})
		
		$('#btn_init').click(function(){
			$('#list').empty(); 
			fn_getList();
		})
	
	});
	
</script>
</head>
<body>
	
	
	<div>
	
		<form id="frm_search">
			
			<select id="column" name="column">
				<option value="TITLE">제목</option>
				<option value="GENRE">장르</option>
				<option value="DESCRIPTION">내용</option>
			</select>
			<input type="text" id="searchText" name="searchText">
			<input type="button" id="btn_search" value="검색">
			<input type="button" id="btn_init" value="초기화">
			
			<br><hr><br>
			
			<table border="1">
				<thead>
					<tr>
						<td>제목</td>
						<td>장르</td>
						<td>내용</td>
						<td>평점</td>
					</tr>
				</thead>
				<tbody id="list"></tbody>
			</table>
			
		</form>
		
	</div>

</body>
</html>