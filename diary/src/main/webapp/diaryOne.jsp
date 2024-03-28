<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//my session  -> 로그인/비로그인 분기
	
	//로그인 분기 -> 인증 분기
	///diary.login.my_session  -> 디비 이름.테이블이름.columm이름 => "OFF" -> redirect(loginForm.jsp)
	
	//받아올 데이터 :연도 월
	
	//db연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	String sessionSql = "select my_session mySession,on_date,off_date from login";
	//자원 초기화
	Connection con = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	PreparedStatement sessionStmt= null;
	ResultSet sessionRs = null;
	sessionStmt = con.prepareStatement(sessionSql);
	sessionRs = sessionStmt.executeQuery();
	String mySession = null;
	if(sessionRs.next()){
		mySession = sessionRs.getString("mySession"); //sql에서 my_session값을 가져오기 ->알리오스 이름으로 가져오기
		
	}
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 해주세요.","utf-8");
		//param 값으로 넘기기 위해 한글 값 인코딩 맞춰주기
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		//자원 반납
		sessionRs.close();
		sessionStmt.close();
		
		return;  // off 시 코드 진행 끝내기  -> ex)메서드 끝낼때 return 사용
	}
		//if문에 안 걸릴때.
		sessionRs.close();
		sessionStmt.close();
		
		
		//로그인 시간 /로그아웃 시간 가져오기
		//String timeSql = "select my_session,on_date,off_date from login";


%>
<%
	String diaryDate = request.getParameter("diaryDate");
	
	System.out.println(diaryDate);
	
	String oneSql = "select diary_date,feeling,title,weather,content,update_date,create_date from diary where diary_date=?";
	PreparedStatement oneStmt = null;
	ResultSet oneRs = null;
	oneStmt = con.prepareStatement(oneSql);
	oneStmt.setString(1,diaryDate);
	
	System.out.println(oneStmt);
	
	oneRs = oneStmt.executeQuery();
	
	




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
	a{
		text-decoration:none;
		color:black;
	
	}

	a:active,a:hover{
		color:#2821E2;
		font-size:17px;	
		
	}
	
	td{
		color:white;
		padding-left:20px;
	
	}
	.btnn{
		background-color:#1D274D;
		color:white;
		border-radius:7px;
		border: 1px solid black;
		padding:10px;
	
	}
	
	
</style>
</head>
<body>
<div class="container mt-5" style="background-color:white; border: 2px solid black; border-radius:5px;">
	<div class="row">
	<div class="col-3">
	<!--  사이드 바 -->
	<div class="mb-2 mt-2" style="width:280px;height:400px;background-color:#1D274D; border-radius:7px;border:1px solid black" >
	<!-- 프로필 박스 -->
	<div class="img ms-2 me-2"><img class="profile" src="./amonus.png"></div>
	<div class="text-center border-top border-black border-2 mt-3 pt-2" style="color:white">
	소개글 위치입니다. Welcome! <br>매일 일기를 기록할 수 있는 <br>다이어리 페이지 입니다 :)</div>
	</div>
	
	
	<div class="mt-2 border-black border-end border-3" style="width:280px; height:300px;">
	<!-- 로그인 정보,리스트로 보기 메뉴 -->
	<div class="text-end me-2 pt-2"><a href="./addDiaryForm.jsp">일기 쓰기!</a></div>
	<div class="text-end me-2"><a href="./diary.jsp">캘린더 보기</a></div>
	<div class="text-end me-2"><a href="./diaryList.jsp">리스트로 보기</a></div>
	<div class="text-end me-2"><a href="./logoutAction.jsp">로그아웃</a></div>
	
	</div>
	<div class="text-right mt-2">최근 로그인: <%=sessionRs.getString("on_date")%></div>
	<div class="text-right mb-2">최근 로그아웃: <%=sessionRs.getString("off_date")%></div>
	</div>
	<!--사이드 바 종료  -->
	
	<!-- 메인 내용 출력 -->
	
	<div class="col-9 justify-content-center mt-2 pb-4 ">
		<div style="background-color:#1D274D; color:white; padding:10px; border-radius:7px;">
		<h1 class="text-center">일기 보기</h1>
		
		</div>
		<hr>
		<div class="d-flex justify-content-center">
		<table style="width:600px; height:400px; background-color:#1D274D;padding:30px;border-radius:10px;" class="mt-5">
			<%
				if(oneRs.next()){
			%>
			<tr>
				<td>날짜</td>
				<td><%=oneRs.getString("diary_date")%></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><%=oneRs.getString("title")%></td>
			</tr>
			<tr>
				<td>기분</td>
				<td><%=oneRs.getString("feeling")%></td>
			</tr>
			<tr>
				<td>날씨</td>
				<td><%=oneRs.getString("weather")%></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><%=oneRs.getString("content")%></td>
			</tr>
			<tr>
				<td>업데이트 날짜</td>
				<td><%=oneRs.getString("update_date")%></td>
			</tr>
			<tr>
				<td>게시 날짜</td>
				<td><%=oneRs.getString("create_date")%></td>
			</tr>
					
			<%	
				}
			
			%>	
		
		</table>
			
		</div>
			<div class="text-center mt-5">
			<a href="./updateDiaryForm.jsp?diaryDate=<%=diaryDate%>" class="btnn">일기 수정하기</a>
			<a href="./diaryList.jsp" class="btnn">돌아가기</a>
			<a href="./deleteDiaryAction.jsp?diaryDate=<%=diaryDate%>" class="btnn">일기 삭제하기</a>
			</div>
	</div>

	</div>

	</div>
	<footer class="container d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top fw-bold">
    	<p class="col-md-4 mb-0 text-muted" style="color:white;">&copy;2024 Goodee Academy</p>
    	<ul class="nav col-md-4 justify-content-end">
        		<li class="nav-item"><a href="./diary.jsp" class="nav-link px-2 text-muted">Home</a></li>
   		</ul>
	</footer>
		<!-- image source - https://br.pinterest.com/pin/742531057307325661/
			https://iconscout.com/free-icon/light-blue-among-us-3218509
			bg- https://motionbgs.com/astronaut-among-us
			https://www.freepnglogos.com/pics/among-us
		 -->
</body>
</html>