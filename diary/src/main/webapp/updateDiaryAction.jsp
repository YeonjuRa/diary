<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
	
	request.setCharacterEncoding("utf-8");
	//업데이트할 데이터 가져오기
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String feeling = request.getParameter("feeling");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	



	//디비연결
	String sql = null;
	PreparedStatement stmt = null;
	Connection con = null;
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	sql = "update diary set feeling=?,title=?,weather=?,content=?,update_date=now() where diary_date=?";
	stmt = con.prepareStatement(sql);
	stmt.setString(1,feeling);
	stmt.setString(2,title);
	stmt.setString(3,weather);
	stmt.setString(4,content);
	stmt.setString(5,diaryDate);
	
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("수정 성공");
		response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);
	}else{
		System.out.println("수정 실패");
		response.sendRedirect("./updateDiaryForm.jsp?diaryDate="+diaryDate);
	}

	stmt.close();
	con.close();
	




%>