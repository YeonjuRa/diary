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
	 
	//db연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	//자원 초기화
	Connection con = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");


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
	<div class="text-right mt-2"><%=loginMember%>님이 접속 중 </div>
	<div class="text-right mt-2">최근 로그인: </div>
	<div class="text-right mb-2">최근 로그아웃: </div>
	</div>
	<!--사이드 바 종료  -->
	
	<!-- 메인 내용 출력 -->
	
	<div class="col-9 justify-content-center mt-2 pb-4 ">
		<div style="background-color:#1D274D; color:white; padding:10px; border-radius:7px;">
		<h1 class="text-center">일기 보기</h1>
		</div>
		
		<hr>
		<div class="d-flex justify-content-center">
		<table style="width:600px; height:400px; background-color:#1D274D;padding:20px;border-radius:10px;" class="mt-1">
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
		
		<div class="text-center mt-3 mb-3">
			<a href="./updateDiaryForm.jsp?diaryDate=<%=diaryDate%>" class="btnn">일기 수정하기</a>
			<a href="./diaryList.jsp" class="btnn">돌아가기</a>
			<a href="./deleteDiaryAction.jsp?diaryDate=<%=diaryDate%>" class="btnn">일기 삭제하기</a>
		</div>
			
		<div style="width:50%; float:left;">
			<form class="text-center mt-2 ms-2" method="post" action="addCommentAction.jsp">
				<input type="hidden" name="diaryDate" value="<%=diaryDate%>">
				<textarea rows="5" cols="30" name="memo">댓글 입력</textarea>
				<br>
				<button type="submit" class="btnn">댓글 달기</button>
			</form>
		</div>
		<%
			String sql2 = "select comment_no, memo,create_date,update_date from comment where diary_date=? order by comment_no desc";
			PreparedStatement stmt2 = null;
			ResultSet rs2 = null;
			stmt2 = con.prepareStatement(sql2);
			stmt2.setString(1,diaryDate);
			rs2 = stmt2.executeQuery();
		
		%>
		<table style="width:50%; float:right;" class="text-center mt-3">
		<%
			while(rs2.next()){
		%>	
			<tr>
				<td style="color:black"><%=rs2.getString("memo") %></td>
				<td style="color:black"><%=rs2.getString("create_date") %></td>
				<td style="color:black"><a href="./deleteComment.jsp?diaryDate=<%=diaryDate%>&commentNo=<%=rs2.getString("comment_no")%>">삭제</a></td>
			</tr>
			
		<% 	
			}
		
		
		%>
		</table>
		
		
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