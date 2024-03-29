<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%	
	request.setCharacterEncoding("utf-8");
	//게시글 삭제시 달려있는 댓글먼저 삭제 후 -> 글 삭제


	//diaryOne.jsp으로 리다이렉트 할때 사용 할 기준값
	String diaryDate = request.getParameter("diaryDate");
	
	//디비 연결
	String sql = null;
	Connection con = null;
	PreparedStatement stmt = null;
	
	
	sql = "delete from comment where diary_date=?";
	Class.forName("org.mariadb.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	stmt = con.prepareStatement(sql);
	stmt.setString(1,diaryDate); //날짜가 일치하는 게시글의 댓글이 전부 지워짐
	System.out.println(stmt);
	int row = stmt.executeUpdate();
	
	
	System.out.println(row+"<-삭제된 댓글 row");
	System.out.println(diaryDate+"<-diaryDate");
	
	
	//부모글 (게시글) 삭제
	
	
	String sql2 = "delete from diary where diary_date=?";
	PreparedStatement stmt2 = null;
	
	con =  DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", 
			"root", "java1234");
	stmt2 = con.prepareStatement(sql2);
	stmt2.setString(1,diaryDate);
	System.out.println(stmt2);
	int row2 = stmt2.executeUpdate();
	
	
	System.out.println(row2 +"<-삭제된 게시글 row");
	
	if(row2 == 1){ 
		response.sendRedirect("./diary.jsp");
		System.out.println("삭제성공");
	}else{
		response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);
		System.out.println("삭제실패");
	}
	
	con.close();
	stmt.close();
	


%>
