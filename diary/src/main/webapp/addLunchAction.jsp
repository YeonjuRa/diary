<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//입력분기코드 
	//세션 확인
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
		mySession = sessionRs.getString("mySession"); //sql에서 my_session값을 가져오기 
		
	}
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 해주세요.","utf-8");
		//param 값으로 넘기기 위해 한글 값 인코딩 맞춰주기
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return;  // off 시 코드 진행 끝내기  -> ex)메서드 끝낼때 return 사용
	}
%>
<%
	//투표한 결과값 등록 

	request.setCharacterEncoding("utf-8");
	//form 에서 값 받아오기
	String lunchDate = request.getParameter("lunchDate");
	String menu = request.getParameter("menu");
	String comment = request.getParameter("comment");
	
	
	System.out.println(lunchDate);
	System.out.println(menu);
	System.out.println(comment);

	//insert sql -> insert into lunch (lunch_date,menu,comment,create_date) 
	//values(?,?,?,now())
	String addLunchsql = "insert into lunch (lunch_date,menu,comment,create_date,update_date) values(?,?,?,now(),now())";
	
	PreparedStatement addLunchstmt= null; 
	
	addLunchstmt = con.prepareStatement(addLunchsql);
	//?값 치환해주기
	addLunchstmt.setString(1,lunchDate);
	addLunchstmt.setString(2,menu);
	addLunchstmt.setString(3,comment);

	//디버깅
	System.out.println(addLunchstmt);
	
	//update
	
	int row = addLunchstmt.executeUpdate();
	if(row==1){
		//영향받은 행이 1일시 입력 성공
		System.out.println("입력성공");
	}else{
		System.out.println("입력실패");
	}
	
	response.sendRedirect("./diary.jsp");
	//성공/실패 시 리스트 페이지로 리다이렉트
	

%>