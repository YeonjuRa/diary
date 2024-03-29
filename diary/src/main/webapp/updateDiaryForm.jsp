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
	//1.기준이 될 값 => diary_date
	String diaryDate = request.getParameter("diaryDate");
	
	
	
	//2.디비연결
	String sql = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	
	//값이 일치하는 글의 모든항목을 가져오기
	sql = "select diary_date diaryDate,feeling,title,weather,content from diary where diary_date=?";
	stmt = con.prepareStatement(sql);
	stmt.setString(1,diaryDate);
	rs = stmt.executeQuery();
	
	if(rs.next()){



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
		color:white;
		padding-left:20px;
	
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
	<div class="text-right mt-2"><%=loginMember%>님이 접속 중 </div>
	<div class="text-right mt-2">최근 로그인: </div>
	<div class="text-right mb-2">최근 로그아웃: </div>
	</div>
	<!--사이드 바 종료  -->
	
	<div class="col-9 justify-content-center mt-2 ">
	<div>
	<%-- checkDate: <%=checkDate %>
	ck : <%=ck %> --%>
	</div>
	<div style="background-color:#1D274D; color:white; padding:10px; border-radius:7px;">
	<h1 class="text-center">일기쓰기</h1>
	
		<!-- 이날짜를 디비에 보내서 일기가 있는지 확인 -->
		<!-- rs.next() ->그 날짜에 일기가 있는지 확인 -->
	</div>
	<hr>
	<div class="d-flex justify-content-center">
	<form method="post" action="./updateDiaryAction.jsp">
	<div>
		<table style="width:600px; height:400px; background-color:#1D274D;padding:30px;border-radius:10px;" class="mb-3">
			<tr>
				<td>날짜:</td>
				<td>
					<input type="text" name="diaryDate" value="<%=rs.getString("diaryDate") %>" readonly style="border-radius:10px;">
				</td>
			</tr>
		
			<tr>
				<td>제목:</td>
				<td><input type="text" name="title" value="<%=rs.getString("title") %>" style="border-radius:10px;">
				</td>
			</tr>
			<tr>
				<td>기분:</td>
				<td>
				<%
					if(rs.getString("feeling").equals("&#128512")){
				%>		
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128512" checked>&#128512
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128530">&#128530
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128528">&#128528
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128557">&#128557	
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128564">&#128564
				<% 
					}else if(rs.getString("feeling").equals("&#128530")){
				%>	
					
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128512">&#128512
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128530" checked>&#128530
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128528">&#128528
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128557">&#128557	
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128564">&#128564
					<%
					}else if(rs.getString("feeling").equals("&#128528")){ 
					%>
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128512">&#128512
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128530">&#128530
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128528" checked>&#128528
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128557">&#128557	
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128564">&#128564
					<% 
					}else if(rs.getString("feeling").equals("&#128557")){
					%>
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128512">&#128512
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128530">&#128530
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128528">&#128528
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128557" checked>&#128557	
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128564">&#128564
					<% 
					}else{
					%>
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128512">&#128512
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128530">&#128530
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128528">&#128528
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128557">&#128557	
						<input type="radio" name="feeling" style="border-radius:10px;" value="&#128564" checked>&#128564
					<% 
					}
					%>
					
				</td>
			</tr>
			<tr>
				<td>날씨:</td>
				<td>
				<select name="weather" style="border-radius:10px;">
					<%
						if(rs.getString("weather").equals("맑음")){
					%>
							<option value="맑음" selected>맑음</option>
							<option value="흐림">흐림</option>
							<option value="비">비</option>
							<option value="눈">눈</option>
					<% 
						}else if(rs.getString("weather").equals("흐림")){
					%>
							<option value="맑음">맑음</option>
							<option value="흐림" selected>흐림</option>
							<option value="비">비</option>
							<option value="눈">눈</option>
					<% 
						}else if(rs.getString("weather").equals("비")){
					%>
							<option value="맑음">맑음</option>
							<option value="흐림">흐림</option>
							<option value="비" selected>비</option>
							<option value="눈">눈</option>
					<% 	
						}else{
					%>
							<option value="맑음">맑음</option>
							<option value="흐림">흐림</option>
							<option value="비">비</option>
							<option value="눈" selected>눈</option>
					<% 	
						}
					
					
					%>
				</select>
				</td>
			</tr>
			<tr>
				<td>내용:</td>
				<td><textarea name="content" cols="50" rows="4"   style="border-radius:10px;"><%=rs.getString("content") %></textarea></td>
			</tr>
		
		</table>
		</div>
		<div>
		<input type="hidden" name="update_date">
		<input type="hidden" name="create_date">
		</div>
		<div class="text-end">
		<button type="submit" class="text-end btn btn-info">일기 수정</button>
		</div>
	</form>
	</div>
	
	</div>
	
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
<%
	}
%>