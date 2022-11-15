<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<c:set var="n" value="123456789" />
	
	<%--
		<fmt:formatDate> 태그
		
		1. DecimalFormat 클래스를 대체하는 태그
		2. value 속성과 pattern 속성과 type 속성 이용
		3. pattern 속성에서 사용하는 패턴은 DecimalFormat과 동일한 패턴임
	--%>
	
	<h1><fmt:formatNumber value="${n}" pattern="#,##0" /></h1>
	<h1><fmt:formatNumber value="${n}" pattern="#,##0,0" /></h1>
	<h1><fmt:formatNumber value="${n}" pattern="#,##0,00" /></h1>


	<h1><fmt:formatNumber value="${n}" pattern="0" /></h1>
	<h1><fmt:formatNumber value="${n}" pattern="0,0" /></h1>
	<h1><fmt:formatNumber value="${n}" pattern="0,00" /></h1>
	
	
	<h1><fmt:formatNumber value="${n}" type="percent"/></h1>	
	
	<h1><fmt:formatNumber value="${n}" type="currency" currencySymbol="$"/></h1>	
	
</body>
</html>