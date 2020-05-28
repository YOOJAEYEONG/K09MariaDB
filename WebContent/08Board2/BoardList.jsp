
<%@page import="util.JavascriptUtil"%>
<%@page import="util.PagingUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<!--필수파라미터 체크로직  -->    
<%@include file="../common/isFlag.jsp" %>



<%
//한글깨짐처리 - 검색폼에서 입력된 한글이 전송되기 때문
request.setCharacterEncoding("UTF-8");





//web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaConnectURL");

//DAO객체 생성 및 DB연결
BbsDAO dao = new BbsDAO(drv,url);

/*
파라미터를 저장할 용도로 생성한 Map컬랙션. 여러개의 파라미터가 있는경우
메소드의 파라미터의 값이 한번 바뀌면 연관되어있는부분 모두 찾아서 
변경해야하므로 이를 개선하기위해 객체에 한거번에 저장한 후 DAO로 전달할 것임.
*/
Map<String, Object> param = new HashMap<String, Object>();




//필수파라미터인 bname을 DAO로 전달하기위해 Map컬렉션에 저장한다.
param.put("bname", bname);




//검색후 2페이지로 넘어가면 검색이 풀리는 문제를 해결하기위해
//폼값을 받아서 파라미터를 저장할 변수 생성
String queryStr = "";//검색시 페이지번호로 쿼리스트링을 넘겨주기위한 용도


//필수파라미터에 대한 쿼리스트링 처리
queryStr = "bname="+bname+"&";





//검색어 입력시 전송된 폼값을 받아 Map에 저장
String searchColumn = request.getParameter("searchColumn");
String searchWord = request.getParameter("searchWord");



if(searchWord!=null){
	//검색어를 입력한경우 Map에 값을 입력함
	//아무것도 입력안하고 그냥 검색버튼을 누를경우를 위한 로직임
	param.put("Column", searchColumn);
	param.put("Word", searchWord);
	
	//검색어가 있을때 쿼리스트링을 만들어준다.
	queryStr +="&searchColumn="+searchColumn
				+"&searchWord="+searchWord+"&";
}
//board테이블에 입력된 전체 레코드 갯수를 카운트하여 반환받음 
int totalRecordCount = dao.getTotalRecordCount(param);






/***페이지처리 start ***/
//web.xml 의 초기화 파라미터를 가져와서 정수로 변경후 저장
int pageSize = 
	Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
int blockPage = 
	Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));

//전체페이지수 계산 => 약105개 / 10 => 10.5 => ceil(10.5) =>11
int totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);
/*
현재페이지번호 : 파라미터가 없을때는 무조건 1페이지로 지정하고, 있을때는 해당값을 
	얻어와서 지정한다. 즉 리스트에 처음 진입했을때는 1페이지가 된다.
*/
int nowPage = 
	request.getParameter("nowPage")==null ||
	request.getParameter("nowPage").equals("")? 1 :
	Integer.parseInt(request.getParameter("nowPage"));



//MariaDB를통해 한페이지에 출력할 게시물의 범위를 결정한다. 
//limit의 첫번째인자 : 시작인덱스
int start = (nowPage-1)*pageSize;
//limit의 두번째인자 : 가져올레코드의 갯수
int end = pageSize;



//게시물의 범위를 Map컬렉션에 저장하고 DAO로 전달한다.
param.put("start", start);
param.put("end", end);
/**페이지처리 end**/







//조건에 맞는 레코드를 select하여 결과 셋을 List컬랙션으로 반환받음
List<BbsDTO> bbs = dao.selectListPage(param);

//DB연결해제
dao.close();
%>    
    
    
<!DOCTYPE html>
<html lang="en">
<jsp:include page="../common/boardHead.jsp" />
<body>
<div class="container">
	<jsp:include page="../common/boardTop.jsp" />
	<div class="row">		
		<jsp:include page="../common/boardLeft.jsp"/>
		<div class="col-9 pt-3">
			<h3><%=boardTitle %> - <small>이런저런 기능이 있는 게시판입니다.</small></h3>
			
			<div class="row">
				<!-- 검색부분 -->
				<form class="form-inline ml-auto" name="searchFrm" method="get">	
					
					
					<!--검색시 필수파라미터인 bname이 전달되어야하므로 히든폼추가 -->
					<input type="hidden" name="bname" value="<%=bname%>"/>
					
					
					<div class="form-group">
						<select name="searchColumn" class="form-control">
							<option value="title">제목</option>
							<option value="content">내용</option>
						</select>
					</div>
					<div class="input-group">
						<input type="text" name="searchWord"  class="form-control"/>
						<div class="input-group-btn">
							<button type="submit" class="btn btn-warning">
								<i class='fa fa-search' style='font-size:20px'></i>
							</button>
						</div>
					</div>
				</form>	
			</div>
			<div class="row mt-3">
				<!-- 게시판리스트부분 -->
				<table class="table table-bordered table-hover table-striped">
				<colgroup>
					<col width="60px"/>
					<col width="*"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="60px"/>
				</colgroup>				
				<thead>
				<tr style="background-color: rgb(133, 133, 133);" 
					class="text-center text-white">
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>조회수</th>
					<!-- <th>첨부</th> -->
				</tr>
				</thead>				
				<tbody>
				
			<%
								//List컬렉션에 입력된 데이터가 없을때 true를 반환.
								if(bbs.isEmpty()){
							%>	
				<tr>
					<td colspan="5" align="center" height="100">
						등록된 게시물이 없습니다.
					</td>
				</tr>
			<%
				} else {
					//게시물의 가상번호로 사용할 변수
					int vNum = 0;
					int countNum = 0;
					/*
					컬렉션에 입력된 데이터가 있다면 저장된 BbsDTO의 갯수만큼 즉, DB가 반환해준
					레코드의 갯수만큼 반복하면서 출력한다.
					*/
					for(BbsDTO dto : bbs){
						vNum = totalRecordCount - 
								(nowPage-1) * pageSize + countNum++;
						/*
						전체게시물수 : 107개
						페이지사이즈 : 10
						countNum은 page가 바뀌면 0으로 초기화된다.
						현제페이지1
							첫번째게시물:107 - (((1-1)*10)+0) = 107
							두번째게시물:107 - (((1-1)*10)+1) = 106
						현제페이지2
							첫번째게시물:107 - (((2-1)*10)+0) = 97
							두번째게시물:107 - (((2-1)*10)+1) = 96
						*/
			%>	
				<%-- 리스트반복 시작 --%>
				<tr>
					<td class="text-center"><%=vNum%></td>
					<td class="text-left">
						<a href="BoardView.jsp?num=<%=dto.getNum()%>
							&nowPage=<%=nowPage%>&<%=queryStr%>">
							<%=dto.getTitle()%>
						</a>
					</td>
					<td class="text-center"><%=dto.getId()%></td>
					<td class="text-center"><%=dto.getPostDate()%></td>
					<td class="text-center"><%=dto.getVisitcount()%></td>
					<!-- <td class="text-center">
						<i class="material-icons" style="font-size:20px">
							attach_file</i>
					</td> --> 
					
				</tr>
				<%-- 리스트반복 끝--%>
			<%
				}//for-each
				}//if
			%>
				</tbody>
				</table>
			</div>
			<div class="row">
				<div class="col text-right">
				<!--자유게시판과 질문과 답변에서만 글쓰기버튼 보임처리  -->
				<%if(bname.equals("freeboard")||bname.equals("qna")){ %>	
					<button type="button" class="btn btn-primary"
						onclick="location.href='./BoardWrite.jsp?bname=<%=bname%>';">글쓰기</button>
				<%} %>
				
				</div>
			</div>
			<div class="row mt-3">
				<div class="col">
					<!-- 페이지번호 부분 -->
					<ul class="pagination justify-content-center">	
					<%=PagingUtil.pagingBS4(totalRecordCount,pageSize, 
							blockPage, nowPage,"BoardList.jsp?"+queryStr)%>
					</ul>
				</div>				
			</div>		
		</div>
	</div>
	<jsp:include page="../common/boardBottom.jsp" />
	<!--"name"과 "value" 속성들을 포함한 "jsp:param" 표준 액션이 요구됩니다.
	=> 액션태그 닫는 태그가 />가 아닌경우 발생하였다.
	  -->
</div>
</body>
</html>

<!-- 
	<i class='fas fa-edit' style='font-size:20px'></i>
	<i class='fa fa-cogs' style='font-size:20px'></i>
	<i class='fas fa-sign-in-alt' style='font-size:20px'></i>
	<i class='fas fa-sign-out-alt' style='font-size:20px'></i>
	<i class='far fa-edit' style='font-size:20px'></i>
	<i class='fas fa-id-card-alt' style='font-size:20px'></i>
	<i class='fas fa-id-card' style='font-size:20px'></i>
	<i class='fas fa-id-card' style='font-size:20px'></i>
	<i class='fas fa-pen' style='font-size:20px'></i>
	<i class='fas fa-pen-alt' style='font-size:20px'></i>
	<i class='fas fa-pen-fancy' style='font-size:20px'></i>
	<i class='fas fa-pen-nib' style='font-size:20px'></i>
	<i class='fas fa-pen-square' style='font-size:20px'></i>
	<i class='fas fa-pencil-alt' style='font-size:20px'></i>
	<i class='fas fa-pencil-ruler' style='font-size:20px'></i>
	<i class='fa fa-cog' style='font-size:20px'></i>

	아~~~~힘들다...ㅋ
 -->