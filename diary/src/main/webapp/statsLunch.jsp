<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//로그인 분기 -> 인증 분기
	///diary.login.my_session  -> 디비 이름.테이블이름.columm이름 => "OFF" -> redirect(loginForm.jsp)
	
	//받아올 데이터 :연도 월
	
	//db연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	
	//자원 초기화
	Connection con = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
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
	String statsSql = "select menu,count(*) cnt from lunch group by menu";
	PreparedStatement statsStmt = null;
	ResultSet statsRs = null;
	statsStmt = con.prepareStatement(statsSql);
	statsRs = statsStmt.executeQuery();
	
	

%>
<%
	//페이징
	
	//1.페이지 번호 넘기기 -> 페이지 1 -> 최신 10개글
	
	//페이지 값 받기 -> 
	int currentPage = 1;
	//null이 아니면 값이 넘어온 것이다 ->즉 페이지 번호가 넘어온것
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10; //한페이지당 글 6개씩 출력
	
	//전체 행 갯수를 가져오기 (즉 전체 글 갯수) 쿼리 -> select count(*) from diary;
	//전체글 갯수/한페이지당 글 개수 => 나머지가 0이면 몫-> 페이지 갯수
	//나머지가 0이아니면 몫+1 => 페이지 갯수
	
	String sql = "select count(*) from diary";

	//db자원 초기화
	PreparedStatement countStmt= null; //페이지에서 쿼리를 두개 실행할 계획 
	ResultSet countRs = null;
	
	
	countStmt = con.prepareStatement(sql);
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
	
	
	//2. 페이징 한 페이지에 6개씩, 페이지가 넘어가면 다음 10개글 가져오기
	//1페이지 -> limit 0,10 , 2페이지 ->10,10 ----
	int limitSkip = ((currentPage-1)* rowPerPage);
	
	System.out.println(limitSkip);
	
	//날짜 목록 전체 출력
		String lunchSql2 = "select lunch_date lunchDate, menu,create_date,comment from lunch order by lunch_date desc limit ?,?";
		PreparedStatement lunchStmt2 = null;
		ResultSet lunchRs2 = null;
		lunchStmt2 = con.prepareStatement(lunchSql2);
		lunchStmt2.setInt(1,limitSkip);
		lunchStmt2.setInt(2,rowPerPage);
		System.out.println(lunchStmt2);
		lunchRs2 = lunchStmt2.executeQuery();


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
body{
		background:url("amongusbg.jpg");
		background-repeat: no-repeat;
		background-size: cover;
		background-position: center center;
		width: 100%;
		height: 900px;
	}
*{
		font-family:"CookieRun";
		color:black;
	}
	a{
		text-decoration:none;
		color:black;
	
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
		color:black;
		
		border-bottom:1px solid black;

	
	}
	
	
</style>
</head>
<body>
<div class="container mt-5" style="background-color:white; border: 2px solid black; border-radius:5px">
	<div class="row">
	<div class="col-3">
	<!--  사이드 바 -->
	<div class="mb-2 mt-2" style="width:280px;height:400px;background-color:#1D274D; border-radius:7px;border:1px solid black" >
	<!-- 프로필 박스 -->
	<div class="img ms-2 me-2"><img class="profile" src="./amonus.png"></div>
	<div class="text-center border-top border-black border-2 mt-3 pt-2" style="color:white">소개글 위치입니다. Welcome! <br>매일 일기를 기록할 수 있는 <br>다이어리 페이지 입니다 :)</div>
	</div>
	
	
	<div class="mt-2 border-black border-end border-3" style="width:280px; height:300px;">
	<!-- 로그인 정보,리스트로 보기 메뉴 -->
	<div class="text-end me-2 pt-2"><a href="./diary.jsp">돌아가기</a></div>

	<div class="text-end me-2"><a href="./logoutAction.jsp">로그아웃</a></div>
	
	</div>
	<div class="text-right mt-2">최근 로그인: </div>
	<div class="text-right mb-2">최근 로그아웃: </div>
	</div>
	<!--사이드 바 종료  -->
	
	<div class="col-9 justify-content-center mt-2 ">
	<div style="background-color:#1D274D; color:white; padding:10px; border-radius:7px;">
	<h2 class="text-center">점심통계</h2>
	</div>
	<%	//숫자 먼저 뿌리고 -> 메뉴 이름 출력 -> 커서는 제자리
			int maxHeight = 300;
			double totalCnt = 0;
				while(statsRs.next()){
					totalCnt = totalCnt + statsRs.getInt("cnt");
					
				}
				statsRs.beforeFirst();
	%>
	<div class="mb-5 mt-5 text-center" >전체 투표수 : <%=(int)totalCnt%></div>
	<div class="text-center ps-5"  style='width:50%; float:left;'>
	<table style="margin:auto; padding:auto;">
		<tr>
			<%	
				String [] c = {"#FF0000","#FE2EF7","#58FAF4","#2EFE64","#F4FA58"};
				int i = 0;
				while(statsRs.next()){
					int h = (int)(maxHeight *(statsRs.getInt("cnt")/totalCnt));
			%>
				<td style="vertical-align:bottom;">
				<div class="mb-4"style="height:<%=h%>px; background-color:<%=c[i]%>;"><%=statsRs.getInt("cnt")%></div>
				</td>
	
			<%
			i=i+1;
			}
			%>
		</tr>
		<tr>
		<%
			statsRs.beforeFirst();
			while(statsRs.next()){
		%>
				<td style="color:black;"><%=statsRs.getString("menu")%></td>
		<%
			}
		%>
		</tr>
	</table>
	
	</div>
	<div style='width:50%; float:right;'>
	<table class="class-start" style="margin:auto; padding:auto;">
					<tr>
						<td><b>날짜</b></td>
						<td><b>메뉴</b></td>
						<td><b>한줄평</b></td>
						
					</tr>
		<%
			while(lunchRs2.next()){
		%>
				
					<tr>
						<td><%=lunchRs2.getString("lunchDate")%></td>
						<td><a href="./lunchOne.jsp?lunchDate=<%=lunchRs2.getString("lunchDate")%>">&nbsp;<%=lunchRs2.getString("menu")%>
						</a></td>
						<td><%=lunchRs2.getString("comment")%></td>
						
					</tr>
		
		<% 	
			}
		
		
		%>
	</table>
	
	<!-- 페이징 넘기기-->
				<div class="text-center mt-2"><%=currentPage%></div>
				<br>
				<!-- 페이징 버튼 -->
				<nav>
				<ul class="pagination justify-content-center">
				
				
				<%
					if(currentPage > 1){
				
				%>
					<li class="page-item"><a href="./statsLunch.jsp?currentPage=1" class="page-link">처음 페이지</a></li>
					<li class="page-item"><a href="./statsLunch.jsp?currentPage=<%=currentPage-1%>" class="page-link">이전</a></li>
				<%
					}else{
				%>	
					<li class="page-item disabled"><a href="./statsLunch.jsp?currentPage=1" class="page-link">처음 페이지</a></li>
					<li class="page-item disabled"><a href="./statsLunch.jsp?currentPage=<%=currentPage-1%>" class="page-link">이전</a></li>
					
				<%	
					}
					if(currentPage<lastPage){
				%>
					<li class="page-item"><a href="./statsLunch.jsp?currentPage=<%=currentPage+1%>" class="page-link">다음</a></li>
					<li class="page-item"><a href="./statsLunch.jsp?currentPage=<%=lastPage%>" class="page-link">마지막 페이지</a></li>
				<%
					}else{
						
				%>
					<li class="page-item disabled"><a href="./statsLunch.jsp?currentPage=<%=currentPage+1%>" class="page-link">다음</a></li>
					<li class="page-item disabled"><a href="./statsLunch.jsp?currentPage=<%=lastPage%>" class="page-link">마지막 페이지</a></li>
				
				<% 
					}
				
				%>
				
				</ul>
				</nav>
		
		
		</div>
	
	
	</div>
	
	
	</div>
	</div>
	</div>
</body>
</html>