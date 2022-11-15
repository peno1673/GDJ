<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="../assets/js/jquery-3.6.1.min.js"></script>
<script>
	
	$(document).ready(function(){
		
		 $('.btn_edit').click(function(event){
			 
			/* location.href = '${contextPath}/final1/edit.do?boardNo=${board.boardNo}'; */
			location.href = '${contextPath}/final1/edit.do';
		}); 
		
		
		$('.btn_list').click(function(event){
			location.href = '${contextPath}/final1/selectBoardlist.do';
		});
		
	});
	
</script>
</head>
<body>
		<form class="frm_write" action="${contextPath}/final1/edit.do" method="POST">
		<table border="1">
			
			<tr>
				<td>순번</td>
				<td><textarea name="boardNo"  class="boardNo" rows="1" cols="30">${board.boardNo}</textarea></td> 
				<%-- <td><input type="text" name="writer" value="${board.writer}" size="30"> </td> --%>
			</tr>
			<tr>
				<td>작성자</td>
				<td><textarea name="writer"  class="writer" rows="1" cols="30">${board.writer}</textarea></td> 
				<%-- <td><input type="text" name="writer" value="${board.writer}" size="30"> </td> --%>
			</tr>
			<tr>
				<td>제목</td>
				<%-- <td><input type="text" name="title" value="${board.writer}" size="30"> </td> --%>
				 <td><textarea name="title" class="title" rows="1" cols="30">${board.title}</textarea></td> 
			</tr>
			<tr>
				<td>내용</td>
				<%-- <td><input type="text" name="content" value="${board.writer}" size="200"> </td> --%>
				 <td><textarea name="content" class="content" rows="10" cols="50">${board.content}</textarea></td>
			</tr>
			<tr>
				<td><input type="button" value="수정" class="btn_edit">
				<td>
				<td><input type="button" value="목록" class= "btn_list">
				<td>
				<td><input type="button" value="삭제" class= "btn_remove">
				<td>
			</tr>
		</table>
	</form>
</body>
</html>