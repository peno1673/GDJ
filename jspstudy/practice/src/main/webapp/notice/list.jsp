<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
</head>
<body>

	<table border="1">
		<thead>
			<tr>
				<td>공지번호</td>
				<td>제목</td>
				<td>작성일</td>				
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${notices}" var="notice">
				<tr>
					<td>${notice.noticeNo}</td>
					<td>${notice.title}</td>
					
					
					<td>${notice.createDate}</td>
				</tr>
			</c:forEach>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="3">
					<c:if test="${page > pagePerBlock}">
						<a href="${contextPath}/notice/list.no?page=${beginPage-1}">&lt;이전블록</a>
					</c:if>
					
					<c:if test="${page != 1 }">
						<a href="${contextPath}/notice/list.no?page=${page-1}">&lt;이전</a>
					</c:if>
					<!-- 1 2 3 -->
					<c:forEach begin="${beginPage}" end="${endPage}" step="1" var="p">
						<c:if test="${page == p }">
							${p}
						</c:if>
						<c:if test="${page != p}">
							<a href="${contextPath}/notice/list.no?page=${p}">${p}</a>
						</c:if>						
					</c:forEach>
					<c:if test="${page != totalPageCnt }">
						<a href="${contextPath}/notice/list.no?page=${page+1}">&gt;다음</a>
					</c:if>
					
					<c:if test="${endPage != totalPageCnt}">
						<a href="${contextPath}/notice/list.no?page=${endPage+1}">다음블록&gt;</a>
					</c:if>
					
					<%-- <c:if test="${page <= pagePerBlock}">
						<a href="${contextPath}/notice/list.no?page=${endPage+1}">&gt;다음블록</a>
					</c:if> --%>
				</td>
			</tr>
		</tfoot>
	</table>

</body>
</html>