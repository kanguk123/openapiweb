<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException"%>
<%
    String id = request.getParameter("id");
    if (id != null && !id.isEmpty()) {
        String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
        String dbUser = "root";
        String dbPassword = "zerobase";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            String deleteQuery = "DELETE FROM history WHERE id = ?";
            stmt = conn.prepareStatement(deleteQuery);
            stmt.setInt(1, Integer.parseInt(id));
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                out.print("삭제되었습니다.");
            } else {
                out.print("삭제 실패.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("삭제 중 오류가 발생했습니다.");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
