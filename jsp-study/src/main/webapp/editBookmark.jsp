<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>북마크 그룹 수정</title>
</head>
<body>
    <h1>북마크 그룹 수정</h1>
    <form action="editBookmark.jsp" method="post">
        <%
            String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
            String dbUser = "root";
            String dbPassword = "zerobase";
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            int groupId = Integer.parseInt(request.getParameter("id"));

            try {
                Class.forName("org.mariadb.jdbc.Driver");
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                String selectQuery = "SELECT * FROM bookmark_groups WHERE id = ?";
                stmt = conn.prepareStatement(selectQuery);
                stmt.setInt(1, groupId);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    String groupName = rs.getString("group_name");
                    int groupOrder = rs.getInt("group_order");
        %>
                    <label for="groupName">북마크 이름:</label>
                    <input type="text" id="groupName" name="groupName" value="<%= groupName %>" required><br><br>
                    <label for="groupOrder">순서:</label>
                    <input type="number" id="groupOrder" name="groupOrder" value="<%= groupOrder %>" required><br><br>
                    <input type="hidden" name="id" value="<%= groupId %>">
                    <input type="submit" value="수정">
        <%
                } else {
                    out.print("<p>해당 북마크 그룹을 찾을 수 없습니다.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.print("<p>오류가 발생했습니다. 다시 시도해주세요.</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </form>

    <%
        // 데이터 수정 처리
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String groupName = request.getParameter("groupName");
            int groupOrder = Integer.parseInt(request.getParameter("groupOrder"));
            int id = Integer.parseInt(request.getParameter("id"));

            try {
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                String updateQuery = "UPDATE bookmark_groups SET group_name = ?, group_order = ?, modified_date = CURRENT_TIMESTAMP WHERE id = ?";
                stmt = conn.prepareStatement(updateQuery);
                stmt.setString(1, groupName);
                stmt.setInt(2, groupOrder);
                stmt.setInt(3, id);
                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    out.print("<p>북마크 그룹이 수정되었습니다.</p>");
                } else {
                    out.print("<p>수정 실패. 다시 시도해주세요.</p>");
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
        }
    %>
</body>
</html>
