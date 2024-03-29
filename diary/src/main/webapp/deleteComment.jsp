<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//diaryOne.jsp으로 리다이렉트 할때 사용 할 기준값
	String diaryDate = request.getParameter("diaryDate");
	//댓글 삭제시 사용
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	//디비 연결
	String sql = null;
	Connection con = null;
	PreparedStatement stmt = null;
	
	
	sql = "delete from comment where comment_no=?";
	Class.forName("org.mariadb.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	stmt = con.prepareStatement(sql);
	stmt.setInt(1,commentNo);
	System.out.println(stmt);
	int row = stmt.executeUpdate();
	
	
	System.out.println(row+"<-삭제된 댓글 row");
	System.out.println(diaryDate+"<-diaryDate");
	
	response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);
	
	
%>