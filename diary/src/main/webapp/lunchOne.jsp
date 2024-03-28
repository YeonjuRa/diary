<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>

<%
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
		return;  // off 시 코드 진행 끝내기  -> ex)메서드 끝낼때 return 사용
	}
		
	//글 입력 sql
	String checkDate = request.getParameter("checkDate");
	if(checkDate == null){ //그냥 이파일을 실행할경우 ""
		checkDate = "";
	}
	String ck = request.getParameter("ck"); //ck 값은 null
	if(ck == null){
		ck="";
	}
	//ck=T 일때만 날짜칸에 날짜가 자동으로 삽입
	
	String msg = "";
	if(ck.equals("T")){
		msg = "투표 가능한 날짜입니다.";
	}else if(ck.equals("F")){
		msg = "해당 날짜에 기록이 이미 존재합니다.";
	}
	
	if(checkDate.equals("")){
		msg = "날짜는 필수입니다.";
	}

%>
<%
	
	//메뉴 확인 sql
	String lunchSql = "select lunch_date lunchDate, menu,create_date,comment from lunch where lunch_date=?";
	PreparedStatement lunchStmt = null;
	ResultSet lunchRs = null;
	lunchStmt = con.prepareStatement(lunchSql);
	lunchStmt.setString(1,checkDate);
	System.out.println(lunchStmt);
	
	lunchRs = lunchStmt.executeQuery();
	

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
	<div class="text-end me-2 pt-2"><a href="./statsLunch.jsp">점심 통계 확인하기!</a></div>
	<div class="text-end me-2"><a href="./logoutAction.jsp">로그아웃</a></div>
	
	</div>
	<div class="text-right mt-2">최근 로그인: <%=sessionRs.getString("on_date")%></div>
	<div class="text-right mb-2">최근 로그아웃: <%=sessionRs.getString("off_date")%></div>
	</div>
	<!--사이드 바 종료  -->
	
	<div class="col-9 justify-content-center mt-2 ">
	<div style="background-color:#1D274D; color:white; padding:10px; border-radius:7px;">
	<h2 class="text-center">오늘 점심 투표</h2>
	</div>
	<!-- 해당날짜에 투표기록이 있는지 확인 -->
	<div>
	<form method="post" action="/diary/lunchCheckDate.jsp">
		<div class="text-center mt-5" style="color:white;">
		날짜확인: <input type="date" name="checkDate" value="<%=checkDate%>" style="border-radius:10px;"><button type="submit" class="ms-3" style="border-radius:10px;">날짜 확인</button>
		<br><span style="color:black"><%=msg%></span>
		</div>
		
	</form>
	</div>
	
	<div class="mt-3">
		<%
			if(ck.equals("T")){
		%>	
			<div class="text-center">
			<form method="post" action="./addLunchAction.jsp">
			날짜: 		
			<%
					if(ck.equals("T")){
				%>
					<input value="<%=checkDate%>" type="text" name="lunchDate" readonly style="border-radius:10px;">
				<% 
					}else{
				%>		
					<input type="text" name="lunchDate" readonly style="border-radius:10px;">
				<%	
					}
				%>
			<br>
			메뉴 :
			<input type="radio" name="menu" value="한식"> 한식
			<input type="radio" name="menu" value="양식"> 양식
			<input type="radio" name="menu" value="일식"> 일식
			<input type="radio" name="menu" value="중식"> 중식
			<input type="radio" name="menu" value="기타"> 기타
			<br>
			한줄평:
			<br>
			<textarea name="comment" cols="50" rows="4"  style="border-radius:10px;">글 입력</textarea>
			<br>
			<button type="submit" class="btnn">투표하기!</button>
			</form>
			</div>	
		<% 
		}else if(ck.equals("F")){
				while(lunchRs.next()){
		%>		
					<div class="text-center">
					날짜: 
					<input name="lunchDate" type="text" value=<%=lunchRs.getString("lunchDate")%> readonly >
					<br>
					메뉴 : <br>
			<%
					if((lunchRs.getString("menu")).equals("한식")){
			%>
						<input type="radio" name="menu" value="한식" checked onclick="return false;"> 한식
						<input type="radio" name="menu" value="양식" onclick="return false;"> 양식
						<input type="radio" name="menu" value="일식" onclick="return false;"> 일식
						<input type="radio" name="menu" value="중식" onclick="return false;"> 중식
						<input type="radio" name="menu" value="기타" onclick="return false;"> 기타
			<% 	
					}else if((lunchRs.getString("menu")).equals("양식")){
			%>
						<input type="radio" name="menu" value="한식" onclick="return false;"> 한식
						<input type="radio" name="menu" value="양식" checked onclick="return false;"> 양식
						<input type="radio" name="menu" value="일식" onclick="return false;"> 일식
						<input type="radio" name="menu" value="중식" onclick="return false;"> 중식
						<input type="radio" name="menu" value="기타" onclick="return false;"> 기타
			<% 		
					}else if((lunchRs.getString("menu")).equals("일식")){
						
			%>		
						<input type="radio" name="menu" value="한식" onclick="return false;"> 한식
						<input type="radio" name="menu" value="양식" onclick="return false;"> 양식
						<input type="radio" name="menu" value="일식" checked onclick="return false;"> 일식
						<input type="radio" name="menu" value="중식" onclick="return false;"> 중식
						<input type="radio" name="menu" value="기타" onclick="return false;"> 기타
			<% 	
					}else if((lunchRs.getString("menu")).equals("중식")){
			%>		
						<input type="radio" name="menu" value="한식" onclick="return false;"> 한식
						<input type="radio" name="menu" value="양식" onclick="return false;"> 양식
						<input type="radio" name="menu" value="일식" onclick="return false;"> 일식
						<input type="radio" name="menu" value="중식" checked onclick="return false;"> 중식
						<input type="radio" name="menu" value="기타" onclick="return false;"> 기타
					
			<% 	
					}else{					
			%>		
						<input type="radio" name="menu" value="한식" onclick="return false;"> 한식
						<input type="radio" name="menu" value="양식" onclick="return false;"> 양식
						<input type="radio" name="menu" value="일식" onclick="return false;"> 일식
						<input type="radio" name="menu" value="중식" onclick="return false;"> 중식
						<input type="radio" name="menu" value="기타" checked onclick="return false;"> 기타
			<% 	
					}//메뉴 분기 if문 종료
			%>
					<br>
					한줄평:<br>
					<textarea name="content" cols="50" rows="4"  style="border-radius:10px;" readonly><%=lunchRs.getString("comment")%></textarea>
			<% 
				  }//while문 종료
			%>
					<br>
					<div class="mt-4"><a class="btnn" href="./deleteLunchAction.jsp?lunchDate=<%=checkDate%>">삭제하기</a></div>	
					</div>			
		<%
				
			}else{
		%>
				<div class="text-center">점심 투표를 하시려면 먼저 날짜를 확인해 주세요 !</div>
		<% 		
				
			}//ck값 분기 if문 종료
			
	
			
		%>
		
		
	</div>
	
	
	
	</div>
	
	</div>
	
	</div>
	<footer class="container d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top fw-bold">
    		<p class="col-md-4 mb-0 text-muted text-white">&copy;2024 Goodee Academy</p>
    		<ul class="nav col-md-4 justify-content-end">
        		<li class="nav-item"><a href="./diary.jsp" class="nav-link px-2 text-muted">Home</a></li>
   			 </ul>
	</footer>
		<!-- image source - https://br.pinterest.com/pin/742531057307325661/
			https://iconscout.com/free-icon/light-blue-among-us-3218509
			bg- https://motionbgs.com/astronaut-among-us
		 -->
</body>
</html>