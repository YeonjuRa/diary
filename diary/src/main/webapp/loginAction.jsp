<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	String loginMember = (String)(session.getAttribute("loginMember"));
	//getAttribute () => 찾는 변수가 없으면 null값을 반환한다.
	//null이 아니라는 말은 로그인 한 적이 있다는 뜻이다//
	System.out.println(loginMember + "<-loginMember");
		
	//즉 분기문은 null이냐 null 이 아니냐로 분기
		if(loginMember != null){
			//로그인 상태
			response.sendRedirect("/diary/diary.jsp");
			return;
		}
	//loginMember 가 null이다 -> session rhdrks loginMember 변수를 생성하고..<- 로그인 성공햇을때만!//
	
%>
	
<%
	//1. 요펑값 분석 -> session공간에 loginMember변수를 생성..
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(memberId);
	System.out.println(memberPw);
	
	
	String sql2 = "select member_id memberId from member where member_id=? and member_pw=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 =	conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	rs2 = stmt2.executeQuery();
	
	
	
	
	if(rs2.next()) {
		// 로그인 성공
		System.out.println("로그인 성공 아이디:" + (rs2.getString("memberId")));
		// diary.login.my_session -> "ON" 변경
		
		/* String sql3 = "UPDATE login SET my_session = 'ON',on_date= now() where my_session='OFF'";
		PreparedStatement stmt3 = null;
		stmt3 =	conn.prepareStatement(sql3);
		int row = stmt3.executeUpdate(); */
		
		//로그인 성공시 DB값 설정 -> session변수 설정
		session.setAttribute("loginMember",rs2.getString("memberId"));
		response.sendRedirect("/diary/diary.jsp");
		
		
	} else {
		// 로그인 실패
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	}
	
	
	//
%>

