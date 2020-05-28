<%@page import="util.JavascriptUtil"%>
<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>



<%@include file="../common/isLogin.jsp" %>
<%@include file="../common/isFlag.jsp" %>


<%
//한글처리 안해도 됨
//request.setCharacterEncoding("UTF-8");

String num = request.getParameter("num");

BbsDTO dto = new BbsDTO();
BbsDAO dao = new BbsDAO(application);

//작성자본인 확인을 위해 기존 게시물의 내용을 가져온다.
dto = dao.selectView(num);

//세션영역에 저장된 로그인아이디를 Object=>String으로 가져온다.
String sesstion_id = 
	session.getAttribute("USER_ID").toString();
System.out.print("session.getAttribute(\"USER_ID\"): "+session.getAttribute("USER_ID"));

int affected = 0;

//세션영역과 DB상의 작성자가 동일한지 확인하여 true일때는 삭제 처리
if(sesstion_id.equals(dto.getId())){
	dto.setNum(num);
	affected = dao.delete(dto);
}
else {
	//경고창으로 알림후 뒤로가기 처리
	JavascriptUtil.jsAlertBack("본인만 사용가능합니다.", out);
	return;
}
if(affected ==1){
	JavascriptUtil.jsAlertLocation("삭제되었습니다.",
			"BoardList.jsp?bname="+bname , out);
}
else{
	out.println("삭제실패하였습니다.");
}

%>

























