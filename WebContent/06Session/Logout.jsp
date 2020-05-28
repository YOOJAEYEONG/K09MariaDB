
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
session.removeAttribute("USER_ID");
session.removeAttribute("USER_PW");


session.invalidate();
request.logout();
response.sendRedirect("Login.jsp");


/*
logout()	clears the identity information in the request but doesn't affect the session
			요청에서 신원 정보를 지우지 만 세션에는 영향을 미치지 않습니다.
invalidate()	invalidates the session but doesn't affect the identity information in the request.
				세션을 무효화하지만 요청의 ID 정보에는 영향을 미치지 않습니다.
*/
%>
