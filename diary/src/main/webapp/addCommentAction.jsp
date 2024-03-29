<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");

	//diaryOne 에서 값 받아오기
	String diaryDate = request.getParameter("diaryDate");
	String memo = request.getParameter("memo");
	

	
	//댓글 sql -> insert into comment (diary_date, memo) values(?,?)
	String sql = "insert into comment (diary_date, memo,create_date,update_date) values(?,?,now(),now())";
	Class.forName("org.mariadb.jdbc.Driver");
	
	//db자원 초기화
	Connection con = null;
	PreparedStatement stmt= null; 
	ResultSet rs = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	stmt = con.prepareStatement(sql);

	stmt.setString(1,diaryDate);
	stmt.setString(2,memo);
	
	System.out.println(stmt);
	
	//update
	int row = 0;
	row = stmt.executeUpdate();
	if(row==1){
		//영향받은 행이 1일시 입력 성공
		System.out.println("입력성공");
	}else{
		System.out.println("입력실패");
	}
	
	response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);

	

	// + post로 넘길시 제일 먼저 인코딩 맞춰주기 ->request.setCharacterEncoding("utf-8");
	
	
	

%>
