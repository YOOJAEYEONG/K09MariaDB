<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>타이틀</title>
</head>
<body>
<!--
[Session]
클라이언트가 서버에 접속해 있는 상태를 말하는 것으로 방문자가 웹브라우저를 열어 서버에 접속하고, 
웹브라우저를 닫아 서버와의 연결을 종료하는 하나의 단위를 세션이라 한다. 
즉 접속한상태의 유지기간을 의미한다.
-클라이언트의 상태정보를 저장하기위한 기술로써 내장 개체중 session개체에 정보가 저장된다.
-cookie는 클라이언트가 저장되지만 session은 서버에 저장된다.
-session개체는 웹브라우저당 1개의 개체가 할당되어 사용자 인증에 관련된 작업을 수행시 주로 사용됨.
-page지시자의 session 속성을 false로 지정하면 사용할 수 없다. (디폴트:true&생략)
-session개체는 일정시간동안 아무런 요청도 하지 않으면 자동적으로 삭제도니다. (디폴트:30분)
-세션 설정시 내부적으로 JSSESSIONID라는 쿠키명으로 세션아이디값을 쿠키값으로 설정된다.
-->


	<h2>세션 유지시간 session내장객체로 설정하기</h2>
	<%
	
	/*
	web.xml에서 설정할때는 분단위로 설정하고, 만약 설정값이 없을때는
	30분(1800초)로 설정된다(디폴트). 웹어플리케이션이 실행될때는
	web.xml이 이 먼저 실행이 되고, 아래 JSP코드가 실행된다.
	내장개체를 사용할때에는 초단위로 설정한다.
	*/
	//세션을유지 할 시간을 초단위로 설정한다..
	session.setMaxInactiveInterval(1000);
	%>
	
	
	
	
	<h2>세션 유지시간 확인하기</h2>
	<p><%=session.getMaxInactiveInterval() %></p>
	
	
	
	<h2>세션 아이디 확인하기</h2>
	<p><%=session.getId() %></p>
	
	
	
	<!--SimpleDateFormat객체로 날짜포멧변경  -->
	<h2>세션의 생성시간/마지막 요청시간</h2>
	<%
	long createTime = session.getCreationTime();
	/*
	[Date 클래스] : 날짜와 시간에 관한 정보를 표현한다.
	Date 클래스는 JDK가 버전업 되면서 많은 메소드가 사용되지 않게 되었다. 
	따라서 Date 클래스는 구버전으로 날짜 관련 정보는 Calendar 클래스를 사용하도록 하자.
	*/

	SimpleDateFormat s = new SimpleDateFormat("HH:mm:ss");
	String creationTimeString = s.format(new Date(createTime));
	
	long lastTime = session.getLastAccessedTime();
	String lastTimeString = s.format(new Date(lastTime));
	
	%>
	
	<ul type="circle">
		<li>최초요청시간 : <%=creationTimeString %></li>
		<li>마지막요청시간: <%=lastTimeString %></li>
	</ul>
	
</body>
</html>































