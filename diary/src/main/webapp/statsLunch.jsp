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
		
	/* //글 입력 sql
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
		msg = "입력 가능한 날짜입니다.";
	}else if(ck.equals("F")){
		msg = "일기가 이미 존재합니다.";
	} */

%>
<%
	String statsSql = "select menu,count(*) cnt from lunch group by menu";
	PreparedStatement statsStmt = null;
	ResultSet statsRs = null;
	statsStmt = con.prepareStatement(statsSql);
	statsRs = statsStmt.executeQuery();
	
	

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
	<div class="text-right mt-2">최근 로그인: <%=sessionRs.getString("on_date")%></div>
	<div class="text-right mb-2">최근 로그아웃: <%=sessionRs.getString("off_date")%></div>
	</div>
	<!--사이드 바 종료  -->
	
	<div class="col-9 justify-content-center mt-2 ">

	<h1>statsLunch</h1>
	<%	//숫자 먼저 뿌리고 -> 메뉴 이름 출력 -> 커서는 제자리
			int maxHeight = 300;
			double totalCnt = 0;
				while(statsRs.next()){
					totalCnt = totalCnt + statsRs.getInt("cnt");
					
				}
				statsRs.beforeFirst();
	%>
	<div>전체 투표수 : <%=(int)totalCnt%></div>
	<div>
	
	<table>
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
	
	</div>
	</div>
	</div>
</body>
</html>