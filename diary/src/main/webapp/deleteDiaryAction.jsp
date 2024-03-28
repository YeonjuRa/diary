<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//글 삭제
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate);
	String sql = "delete from diary where diary_date=?";
	PreparedStatement stmt = null;
	Connection con = null;
	con =  DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	stmt = con.prepareStatement(sql);
	stmt.setString(1,diaryDate);
	System.out.println(stmt);
	int row = stmt.executeUpdate();
	
	
	System.out.println(row +"<-게시글 row");
	
	if(row == 1){ 
		response.sendRedirect("./diaryList.jsp");
		System.out.println("삭제성공");
	}else{
		response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);
		System.out.println("삭제실패");
	}
	
	con.close();
	stmt.close();


%>