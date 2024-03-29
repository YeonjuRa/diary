<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//my session  -> 로그인/비로그인 분기
	
	//로그인 분기 -> 인증 분기
	//로그인 세션분기
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null){
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 해주세요.","utf-8");
		//param 값으로 넘기기 위해 한글 값 인코딩 맞춰주기
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return;
	}else{
		System.out.println(loginMember);
		
	}

	

%>

<%
	//db연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	
	//자원 초기화
	Connection con = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	//페이징
	//search
	String searchWord = "";
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}
	//1.페이지 번호 넘기기 -> 페이지 1 -> 최신 6개글
	
	//페이지 값 받기 -> 
	int currentPage = 1;
	//null이 아니면 값이 넘어온 것이다 ->즉 페이지 번호가 넘어온것
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 6; //한페이지당 글 6개씩 출력
	
	//전체 행 갯수를 가져오기 (즉 전체 글 갯수) 쿼리 -> select count(*) from diary;
	//전체글 갯수/한페이지당 글 개수 => 나머지가 0이면 몫-> 페이지 갯수
	//나머지가 0이아니면 몫+1 => 페이지 갯수
	
	String sql = "select count(*) from diary where title like ?";

	//db자원 초기화
	PreparedStatement countStmt= null; //페이지에서 쿼리를 두개 실행할 계획 
	ResultSet countRs = null;
	
	
	countStmt = con.prepareStatement(sql);
	countStmt.setString(1,"%"+searchWord+"%");
	countRs = countStmt.executeQuery();
	
	int totalRow = 0;
	//읽어올 행이 있을 경우에 totalRow -> count(*) 즉 전체 행갯수 반환
	if(countRs.next()){
		totalRow = countRs.getInt("count(*)");
	}
	//디버깅
	System.out.println(totalRow +"<-totalRow Diary list");
	
	int lastPage = totalRow/rowPerPage;
	if(totalRow%rowPerPage != 0){
		lastPage = lastPage +1; //나머지가 0이 아니면 페이지 갯수= 몫+1;
	}
	System.out.println(lastPage +"<-lastPage Diary list ");
	
	
	//2. 페이징 한 페이지에 6개씩, 페이지가 넘어가면 다음 6개글 가져오기
	//1페이지 -> limit 0,6 , 2페이지 ->6,6 ----
	int limitSkip = ((currentPage-1)* rowPerPage);
	
	System.out.println(limitSkip);



%>
<%
	
	//searchWord가 공백
	String listSql = "select diary_date diaryDate,title,create_date from diary where title like ? order by diaryDate desc limit ?,?";
	//리스트 출력
	PreparedStatement listStmt = null;
	ResultSet listRs = null;
	listStmt = con.prepareStatement(listSql);
	listStmt.setString(1, "%"+searchWord+"%");
	listStmt.setInt(2,limitSkip);
	listStmt.setInt(3,rowPerPage);
	System.out.println(listStmt); 
	
	listRs = listStmt.executeQuery();
	
	//diaryOne 연결
	String diaryDate = request.getParameter("diaryDate");

	
	

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	*{
		font-family:"CookieRun";
		color:black;
	}
	
	a{
		text-decoration:none;
		color:#000000;
	}
	body{
		background:url("amongusbg.jpg");
		background-repeat: no-repeat;
		background-size: cover;
		background-position: center center;
		width: 100%;
		height: 900px;
	}
	
	a:visited{
		text-decoration:none;
		color:#000000;
	}
	a:active,a:hover{
		color:#2821E2;	
		font-size:17px;	
	}
	.img{
	width:250px;
	height:250px;
	border:1px solid black;
    border-radius:70%;
    overflow: hidden;
    margin-top:5px;
    margin-right:5px;
	}
	.profile{
	 width: 100%;
    height: 100%;
    object-fit: cover;

	}
	td{
		color:white;
		
	}
	

</style>
</head>
<body>
<div class="container mt-5" style="background-color:white; border: 2px solid black; border-radius:5px">
	<div class="row">
		<!-- 사이드바 -->
		<div class="col-3">
		<div class="mb-2 mt-2" style="width:280px;height:400px;background-color:#1D274D; border-radius:7px;border:1px solid black" >
		<!-- 프로필 박스 -->
		<div class="img ms-2 me-2"><img class="profile" src="./amonus.png"></div>
		<div class="text-center border-top border-black border-2 mt-3 pt-2" style="color:white">소개글 위치입니다. Welcome! <br>매일 일기를 기록할 수 있는 <br>다이어리 페이지 입니다 :)</div>
		</div>
		
		<div class="mt-2 border-black border-end border-3" style="width:280px; height:300px;">
		<!-- 로그인 정보,리스트로 보기 메뉴 -->
		<div class="text-end me-2 pt-2"><a href="./addDiaryForm.jsp">일기 쓰기!</a></div>
		<div class="text-end me-2"><a href="./diary.jsp">캘린더 보기</a></div>
		<div class="text-end me-2"><a href="./lunchOne.jsp">오늘 점심 투표하기!</a></div>
		<div class="text-end me-2 pt-2"><a href="./statsLunch.jsp">점심 통계 확인하기!</a></div>
		<div class="text-end me-2"><a href="./diaryList.jsp">리스트로 보기</a></div>
		<div class="text-end me-2"><a href="./logoutAction.jsp">로그아웃</a></div>
		
		</div>
		<div class="text-right mt-2"><%=loginMember%>님이 접속 중 </div>
		<div class="text-right mt-2">최근 로그인: </div>
		<div class="text-right mb-2">최근 로그아웃: </div>
		</div>
		<!--사이드 바 종료  -->
		<!-- 메인화면 -->
		<div class="col-9">
		<div style="background-color:#1D274D; color:white; padding:10px; border-radius:7px;" class="mt-2">
		<h1 class="text-center">일기 리스트</h1>
		</div>
		<hr>
		<form method="get" action="./diaryList.jsp?searchWord=<%=request.getParameter(searchWord)%>">
			<div class="text-center">
			제목검색:
			<input type="text" name="searchWord" style="border-radius:10px;" value="<%=searchWord%>">
			
			<button type="submit"  style="border-radius:10px;">검색</button>
			</div>
		</form>
		
		<div class="d-flex justify-content-center diaryTable text-center">
		
		<table style="width:600px; height:450px; background-color:#1D274D;border-radius:10px;color:white;" class="mt-3 pt-3">
			<thead>
			<tr>
				<td class="pt-3">날짜</td>
				<td class="pt-3">제목</td>
				<td class="pt-3">게시 날짜</td>
			</tr>
			<thead>
			
			<tbody>
			<%
				while(listRs.next()){
			%>
			
			<tr>
				<td><%=listRs.getString("diaryDate")%></td>
				<td><a href='/diary/diaryOne.jsp?diaryDate=<%=listRs.getString("diaryDate")%>' style="color:white"><%=listRs.getString("title")%></a></td>
				<td><%=listRs.getString("create_date")%></td>
			</tr>
			
		
					
			<%	
				}
			
			%>	
		</tbody>
		</table>
			
		</div>
		<!-- 페이징 넘기기-->
				<div class="text-center mt-2"><%=currentPage%></div>
				<br>
				<!-- 페이징 버튼 -->
				<nav>
				<ul class="pagination justify-content-center">
				
				
				<%
					if(currentPage > 1){
				//1페이지보다 작을때 이전페이지로 이동을 못함
				//페이지번호가 1보다 클 때만 이전페이지 버튼 출력 + 다음페이지 버튼은 고정;
				%>
					<li class="page-item"><a href="./diaryList.jsp?currentPage=1&searchWord=<%=searchWord%>" class="page-link">처음 페이지</a></li>
					<li class="page-item"><a href="./diaryList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord%>" class="page-link">이전</a></li>
				<%
					}else{
				%>	
					<li class="page-item disabled"><a href="./diaryList.jsp?currentPage=1&searchWord=<%=searchWord%>" class="page-link">처음 페이지</a></li>
					<li class="page-item disabled"><a href="./diaryList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord%>" class="page-link">이전</a></li>
					
				<%	
					}
					if(currentPage<lastPage){
				%>
					<li class="page-item"><a href="./diaryList.jsp?currentPage=<%=currentPage+1%>&searchWord=<%=searchWord%>" class="page-link">다음</a></li>
					<li class="page-item"><a href="./diaryList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>" class="page-link">마지막 페이지</a></li>
				<%
					}else{
						
				%>
					<li class="page-item disabled"><a href="./diaryList.jsp?currentPage=<%=currentPage+1%>&searchWord=<%=searchWord%>" class="page-link">다음</a></li>
					<li class="page-item disabled"><a href="./diaryList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>" class="page-link">마지막 페이지</a></li>
				
				<% 
					}
				
				%>
				
				</ul>
				</nav>
		
		
		</div>
	</div>



</div>
</body>
</html>