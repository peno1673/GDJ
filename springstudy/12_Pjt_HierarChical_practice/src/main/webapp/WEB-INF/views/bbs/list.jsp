<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <c:set var="contextPath" value="${pageContext.request.contextPath}"/>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script>


$(function(){
	
	$.ajax({
		/* 요청 */
		type: 'get',
		url: '${contextPath}/bbs/list?recordPerPage=',
		data: $('#frm_member').serialize(),
		/* 응답 */
		dataType: 'json',
		success: function(resData){
			var ul = '<ul>';
			ul += '<li>' + resData.id + '</li>';
			ul += '<li>' + resData.pw + '</li>';
			ul += '</ul>';
			$('#result').html(ul);
		}
	});  // ajax
	
	if('${recordPerPage}' != ''){
		$('#recordPerPage').val(${recordPerPage});			
	} else {
		$('#recordPerPage').val(10);
	}
	
	$('#recordPerPage').change(function(){
		location.href = '${contextPath}/bbs/list?recordPerPage=' + $(this).val();
	});
	
});
</script>

</head>
<body>
	<div>
		<select id="recordPerPage">
			<option value="10">10</option>
			<option value="20">20</option>
			<option value="30">30</option>
		</select>
	</div>

	<div>
		<table border="1">
			<thead>
				<tr>
					<td>순번</td>
					<td>작성자</td>
					<td>제목</td>
					<td>ip</td>
					<td>작성일</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="bbs" items="${bbsList}" varStatus="vs" >
					<tr>
						<td>${beginNo - vs.index}</td>
						<td>${bbs.writer}</td>
						<td>${bbs.title}</td>
						<td>${bbs.ip}</td>
						<td>${bbs.createDate}</td>
						<td>
							<a href="">X</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="6">${paging}</td>	
				</tr>
			</tfoot>
		</table>
	</div>
</body>
</html>