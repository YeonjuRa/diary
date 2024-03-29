<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	/* request.setCharacterEncoding
	("utf-8");
	// 0. 로그인(인증) 분기
	// diary.login.my_session => 'ON' => redirect("diary.jsp")

	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()) {
		mySession = rs1.getString("mySession");
	}
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	if(mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
	}
	//세션 사용시 on_Date, off_date는 남길 수 없다//세션 -> DB 로 연동해줘야함
	
	// 1. 요청값 분석
	
	String sql3 = "UPDATE login SET my_session = 'OFF',off_date=now() where my_session='ON'";
	PreparedStatement stmt3 = null;
	stmt3 =	conn.prepareStatement(sql3);
	
	int row = stmt3.executeUpdate();
	
		
	if(row == 1 ){
		
			System.out.println("Session OFF");	 */
			
	/* }else{
		System.out.println("로그아웃 실패");
		response.sendRedirect("/diary/diary.jsp");
	} */
	
	//세션 로그아웃
	/* session.removeAttribute("loginMember"); */

	session.invalidate(); //세션공간 초기화 (포맷)

	response.sendRedirect("./loginForm.jsp");
	
%>

