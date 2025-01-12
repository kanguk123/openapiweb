<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>북마크 목록</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #009900; /* 연한 초록색 */
            color: white;
        }
    </style>
</head>
<body>
    <h1>북마크 목록</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>북마크 그룹</th>
                <th>와이파이명</th>
                <th>등록일자</th>
                <th>비고</th>
            </tr>
        </thead>
        <tbody>
            <%
                String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
                String dbUser = "root";
                String dbPassword = "zerobase";
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("org.mariadb.jdbc.Driver");
                    conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                    // 북마크 목록을 조회하는 SQL 쿼리
                    String query = "SELECT b.id, bg.group_name, wi.wifi_name, b.created_at, wi.management_id " +
                                   "FROM bookmarks b " +
                                   "JOIN bookmark_groups bg ON b.group_id = bg.id " +
                                   "JOIN wifiInfo wi ON b.wifi_id = wi.management_id " +
                                   "ORDER BY b.created_at DESC";
                    stmt = conn.prepareStatement(query);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int bookmarkId = rs.getInt("id");
                        String groupName = rs.getString("group_name");
                        String wifiName = rs.getString("wifi_name");
                        String createdAt = rs.getString("created_at");
                        String wifiId = rs.getString("management_id");

                        out.print("<tr>");
                        out.print("<td>" + bookmarkId + "</td>");
                        out.print("<td>" + groupName + "</td>");

                        // 와이파이명에 링크 추가, 클릭 시 detail.jsp로 넘어감
                        out.print("<td><a href='detail.jsp?wifiId=" + wifiId + "'>" + wifiName + "</a></td>");
                        out.print("<td>" + createdAt + "</td>");
                        out.print("<td><a href='deleteBookmark.jsp?id=" + bookmarkId + "'>삭제</a></td>");
                        out.print("</tr>");
                    }
                } catch (SQLException | ClassNotFoundException e) {
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
        </tbody>
    </table>
</body>
</html>
