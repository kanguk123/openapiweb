<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>북마크 그룹 삭제</title>
</head>
<body>
    <h1>북마크 그룹 삭제</h1>
    <%
        String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
        String dbUser = "root";
        String dbPassword = "zerobase";
        Connection conn = null;
        PreparedStatement stmt = null;

        int groupId = Integer.parseInt(request.getParameter("id"));

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            String deleteQuery = "DELETE FROM bookmark_groups WHERE id = ?";
            stmt = conn.prepareStatement(deleteQuery);
            stmt.setInt(1, groupId);
            int rowsDeleted = stmt.executeUpdate();

            if (rowsDeleted > 0) {
                out.print("<p>북마크 그룹이 삭제되었습니다.</p>");
                out.print("<a href='bookmark.jsp'>북마크 그룹 관리 페이지로 돌아가기</a>");
            } else {
                out.print("<p>삭제 실패. 다시 시도해주세요.</p>");
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
