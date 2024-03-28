<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	//0순위.로그인 분기 -> 인증 분기
	///diary.login.my_session  -> 디비 이름.테이블이름.columm이름 => "ON" -> redirect(diary.jsp)
	
	//받아올 데이터 :연도 월
	
	//db연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	String sessionSql = "select my_session mySession from login";
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
	if(mySession.equals("ON")){ //loginForm에는 로그인 되어있는 사람은 접근할 수 없다
		//param 값으로 넘기기 위해 한글 값 인코딩 맞춰주기
		response.sendRedirect("/diary/diary.jsp");
		return;  //코드 진행을 끝내는 문법  -> ex)메서드 끝낼때 return 사용
	}
		//if문에 안 걸릴때.
			sessionRs.close();
			sessionStmt.close();
			con.close();
			
	//1.요청값 분석
	String errMsg = request.getParameter("errMsg");
	
	
	
	

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
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
	width:500px;
	height:200px;
	/* border:1px solid black; */
    border-radius:5px;
    overflow: hidden;

  
	}
	.profile{
	 width: 100%;
    height: 100%;
    object-fit: cover;

	}
	.input{
	border-radius:8px;
	
	}
</style>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-5">
	<div class="row">
	<div class="col-3"></div>
	<div class="col-6">
	<div>
	<%
		if(errMsg !=null){
	%>
		<div><%=errMsg%></div>
	<% 
		}
	
	%>
	</div>
		<div class="img" style="margin-left: auto; margin-right: auto;" >
		<img class="profile" src="./header.jpg">
		</div>
		<div style="padding:20px; border-radius:5px;color:white;">
		<h1 class="text-center">로그인</h1>
	
		<form method="post" action="./loginAction.jsp">
		
			<table style="margin-left: auto; margin-right: auto;" >
			<tr>
				<td style="color:white;">아이디: </td>
				<td><input type="text" name="memberId" class="input"></td>
			</tr>
			<tr>
				<td style="color:white;">비밀번호:</td>
				<td><input type="password" name="memberPw" class="input"></td>
			</tr>
			</table> 
		
			<div class="mt-3 text-end"><button type="submit" class="btn btn-info">로그인하기</button></div>
		</form>
		
		</div>

	</div>
	<div class="col-3"></div>
	</div>
	</div>
	<footer class="container d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top fw-bold">
    		<p class="col-md-4 mb-0 text-muted text-white">&copy;2024 Goodee Academy</p>
    		<ul class="nav col-md-4 justify-content-end">
        		<li class="nav-item"><a href="./boardList.jsp" class="nav-link px-2 text-muted">Home</a></li>
   			 </ul>
	</footer>
		<!-- image source - https://br.pinterest.com/pin/742531057307325661/
			https://iconscout.com/free-icon/light-blue-among-us-3218509
			bg- https://motionbgs.com/astronaut-among-us
		 -->
</body>
</html>