<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
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

	Class.forName("org.mariadb.jdbc.Driver");
	//자원 초기화
	Connection con = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	//캘린더 달력 출력하기
	//1. 출력하고자 하는 달력의 년도와 월값을 받는다
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	
	Calendar target = Calendar.getInstance();
	//캘린더 api사용
	
	//넘겨받은 값이 null이 아님 -> calendar api값을 받기
	if(targetYear != null && targetMonth != null){
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH,Integer.parseInt(targetMonth));
		//null이 아닐 시 연도와 월 값 설정
		
	}
	
	//달력 시작 공백 칸의 갯수 구하는 법-> 1일의 요일값이 필요하다
	//타겟 날짜를 1일로 변경 즉 3월 15일 --> 3월 1일
	target.set(Calendar.DATE,1);
	
	//달력 타이틀 출력
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
	
	//요일 구하기
	int yoNum = target.get(Calendar.DAY_OF_WEEK);
	//일요일 ->1, 월요ㅣㅇㄹ ->2 ... 토요일 ->7
	//3월 1일은 금요일 ->6 , 즉 1일 요일 넘버 -1 == 시작  공백칸
	//System.out.println(yoNum);
	
	int beginBlank = yoNum - 1;
	int lastDate = target.getActualMaximum(Calendar.DATE);
	//target달의 마지막 날짜 반환하기
	
	int countDiv = beginBlank + lastDate ;
	//전체 칸수 구하기

	//DB에서  tYear 와 tMonth에 해당되는 diary 목록 추출
	String listSql = "select diary_date diaryDate,day(diary_date) day,feeling,left(title,5) title from diary where year(diary_date)=? and month(diary_date)=?;";
	PreparedStatement stmt2 = null;
	ResultSet listRs = null;
	stmt2 = con.prepareStatement(listSql);
	stmt2.setInt(1,tYear);
	stmt2.setInt(2,tMonth+1);
	
	System.out.println(stmt2);
	
	listRs = stmt2.executeQuery(); //현재 타겟달의 모든 일기가 들어가있다
	//listRs.first();   //비교값 일치시 다음 비교를 위해서 커서로 처음으로 돌린다.


%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Diary</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	*{
		font-family:"CookieRun";
		color:black;
	}
	.cell {
			float:left;
			width:100px; height:90px;
			background-color:white;
			border:2px solid black;
			border-radius:5px;
			margin: 3px;
			padding-left:2px;
			
		}
		.sun {
			clear: both;
			color: #FF0000;
			
		}
		.yo {
			float:left;
			width:100px;height:40px;
			/* border:2px solid #ffdb70;
			border-radius:4px; */
			margin: 3px;
			background-color:#1D274D;
			padding:5px;
			border-radius:7px;
			color:white;
			text-align:center;
			font-size: 15px;

		
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
	.imgIcon{
		width:40px;
		height:40px;
	
	
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
	<div class="text-center border-top border-black border-2 mt-3 pt-2" style="color:white">소개글 위치입니다. Welcome! <br>매일 일기를 기록할 수 있는 <br>다이어리 페이지 입니다 :)</div>
	</div>
	
	
	<div class="mt-2 border-black border-end border-3" style="width:280px; height:300px;">
	<!-- 로그인 정보,리스트로 보기 메뉴 -->
	<div class="text-end me-2 pt-2 "><a href="./addDiaryForm.jsp">일기 쓰기!</a></div>
	<div class="text-end me-2"><a href="./diary.jsp">캘린더 보기</a></div>
	<div class="text-end me-2"><a href="./diaryList.jsp">리스트로 보기</a></div>
	<div class="text-end me-2"><a href="./lunchOne.jsp">오늘 점심 투표하기!</a></div>
	<div class="text-end me-2"><a href="./logoutAction.jsp">로그아웃</a></div>
	
	</div>
	<div class="text-right mt-2">최근 로그인: </div>
	<div class="text-right mb-2">최근 로그아웃:</div>
	</div>
	<!--사이드 바 종료  -->
	
	<!-- 메인 내용 출력 -->
	<div class="col-9 justify-content-center mt-2 pb-4 ">
	<!-- 캘린더 출력 -->
	<div class="text-center mb-4" style="background-color:#1D274D;padding:5px;border-radius:7px;color:white;">
	<h2 class="pt-2"><%=tYear%>년 <%=tMonth+1%>월</h2>
	<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>" style="color:white;">< 이전 달 </a>	
	<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>" style="color:white;">다음 달 ></a>
	</div>
	<!--월 선택창 추가  -->
	
	<div class= "text-center mb-4 pb-2 border-bottom">
	<% 
		for(int i=0;i<=11; i=i+1){
			String[] monthNames = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	%>
			<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=i%>"><%=monthNames[i]%></a>
			
	<% 
		}
	%>
	</div>
	
	<div class="ms-5">
	<br>
	<div >
		<div class="yo sun" style="color:red;">Sun</div>
		<div class="yo">Mon</div>
		<div class="yo">Tue</div>
		<div class="yo">Wed</div>
		<div class="yo">Thu</div>
		<div class="yo">Fri</div>
		<div class="yo">Sat</div>
	</div>
	<!-- date값이 들어갈 DIV 찍기 for 문 -->
	<%
		for(int i = 1;i<=countDiv;i=i+1){
			if(i%7 == 1){
	%>
		<div class="cell sun">
	<% 
			}else{
	%>			
			<div class="cell">
	<%		
		}
			if(i-beginBlank >0 && i-beginBlank <= lastDate){
	%>
				<%=i-beginBlank%><br>
				
	<% 		//현재날짜(i-beginBlank)의기가 listRs목룍에 있는 지 비교
			while(listRs.next()){
				//날짜의 일기가 존재
				if(listRs.getInt("day") == (i-beginBlank)){
	%>				
					
					<div>
					<span><%=listRs.getString("feeling")%></span>
					<a href='/diary/diaryOne.jsp?diaryDate=<%=listRs.getString("diaryDate")%>'>
					<img class="imgIcon" src="./icon.png"></a>
				
					</div>
	
	
	<%
				break;
				}
			}
			listRs.beforeFirst(); //커서위치를 처음으로 돌리기
			
		}else{
	%>	
			&nbsp;
	<% 
		}
	%>
			</div>
	<% 
		}
	%>
		</div>
	
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