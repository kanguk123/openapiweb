<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>북마크 추가</title>
</head>
<body>
    <h1>북마크 추가</h1>
    <%
        String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
        String dbUser = "root";
        String dbPassword = "zerobase";
        Connection conn = null;
        PreparedStatement stmt = null;

        String groupId = request.getParameter("groupId");
        String wifiId = request.getParameter("wifiId");

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            
            String insertQuery = "INSERT INTO bookmarks (group_id, wifi_id) VALUES (?, ?)";
            stmt = conn.prepareStatement(insertQuery);
            stmt.setString(1, groupId);
            stmt.setString(2, wifiId);
            
            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                out.print("<p>북마크가 추가되었습니다.</p>");
                response.sendRedirect("lookbookmark.jsp"); // 추가 후 lookbookmark.jsp로 이동
            } else {
                out.print("<p>북마크 추가 실패. 다시 시도해주세요.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("<p>오류가 발생했습니다. 다시 시도해주세요.</p>");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
