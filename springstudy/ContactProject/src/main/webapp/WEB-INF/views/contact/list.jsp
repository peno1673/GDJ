<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>연락처 리스트</title>
</script>
</head>
<body>
	<div>
		<table border="1">
			<thead>
				<tr>
					<td>번호</td>
					<td>이름</td>
					<td>전화</td>
					<td>주소</td>
					<td>이메일</td>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty contacts}">
					<tr>
						<td colspan="5">없음</td>
					</tr>
				</c:if>
				<c:if test="${not empty contacts}">
					<c:forEach items="${contacts}" var="contact">
						<tr>
							<td>${contact.no}</td>
							<td><a href="${contextPath}/ctt/detail?no=${contact.no}">${contact.name}</a></td>
							<td>${contact.tel}</td>
							<td>${contact.addr}</td>
							<td>${contact.email}</td>
						</tr>
					</c:forEach>
				</c:if>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="5"><a href="${contextPath}/ctt/write">신규 연락처
							등록하기</a></td>
				</tr>
			</tfoot>
		</table>
	</div>

</body>
</html>