<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException"%>
<%@ page import="java.io.IOException"%>
<%
    // 클라이언트에서 전달된 위도, 경도 받기
    String latParam = request.getParameter("lat");
    String lonParam = request.getParameter("lon");

    // 위도, 경도 값이 null이거나 비어있으면 오류 메시지 출력
    if (latParam == null || lonParam == null || latParam.trim().isEmpty() || lonParam.trim().isEmpty()) {
        response.getWriter().write("위치 정보가 잘못되었습니다.");
        return;
    }

    double lat = 0.0;
    double lon = 0.0;

    try {
        lat = Double.parseDouble(latParam);
        lon = Double.parseDouble(lonParam);
    } catch (NumberFormatException e) {
        response.getWriter().write("위치 정보가 올바르지 않습니다.");
        return;
    }

    // DB 연결 및 위치 정보 저장
    String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
    String dbUser = "root";
    String dbPassword = "zerobase";
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        String insertQuery = "INSERT INTO history (lat, lon, query_date) VALUES (?, ?, NOW())";
        stmt = conn.prepareStatement(insertQuery);
        stmt.setDouble(1, lat);
        stmt.setDouble(2, lon);
        stmt.executeUpdate();

        response.getWriter().write("위치 정보가 저장되었습니다.");
    } catch (SQLException e) {
        e.printStackTrace();
        response.getWriter().write("DB 오류가 발생했습니다.");
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
