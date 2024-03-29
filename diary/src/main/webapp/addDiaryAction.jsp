<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//입력분기코드 
	//세션 확인
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
	
	String sessionSql = "select my_session mySession,on_date,off_date from login";
	//자원 초기화
	Connection con = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");

%>
<%
	//글 등록 

	request.setCharacterEncoding("utf-8");
	//insertform 에서 값 받아오기
	String diary_date = request.getParameter("diary_date");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	String feeling = request.getParameter("feeling");
	
	System.out.println(feeling);

	//마리아 디비 연결//
	
	//insert sql -> insert into diary (diary_date, title,weather,content) 
	//values(?,?,?,?,?,?)
	String sql = "insert into diary (diary_date,feeling, title,weather,content,update_date,create_date) values(?,?,?,?,?,now(),now())";
	Class.forName("org.mariadb.jdbc.Driver");
	//db자원 초기화
	PreparedStatement stmt= null; 
	ResultSet rs = null;
	
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	stmt = con.prepareStatement(sql);
	//?값 치환해주기
	stmt.setString(1,diary_date);
	stmt.setString(2,feeling);
	stmt.setString(3,title);
	stmt.setString(4,weather);
	stmt.setString(5,content);
	//디버깅
	System.out.println(stmt);
	
	//update
	
	int row = stmt.executeUpdate();
	if(row==1){
		//영향받은 행이 1일시 입력 성공
		System.out.println("입력성공");
	}else{
		System.out.println("입력실패");
	}
	
	response.sendRedirect("./diary.jsp");
	//성공/실패 시 리스트 페이지로 리다이렉트
	

%>









