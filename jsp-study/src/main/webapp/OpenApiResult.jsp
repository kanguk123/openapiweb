<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>와이파이 정보</title>
</head>
<body>
    <h1>와이파이 정보</h1>

    <%
        // MariaDB JDBC 드라이버 로드
        out.print("<p>Starting database connection...</p>");
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            out.print("<p>JDBC driver loaded successfully.</p>");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.print("<p>JDBC 드라이버를 찾을 수 없습니다.</p>");
            return;
        }

        // 데이터베이스 연결 코드
        String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
        String dbUser = "root";
        String dbPassword = "zerobase";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String query = "SELECT * FROM wifiInfo";

        try {
            // 데이터베이스 연결
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            out.print("<p>데이터베이스에 연결되었습니다.</p>");
            
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            // 결과 처리
            StringBuilder resultHtml = new StringBuilder();
            resultHtml.append("<table border='1' cellpadding='5' cellspacing='0'>");
            resultHtml.append("<tr><th>관리번호</th><th>자치구</th><th>와이파이명</th><th>도로명주소</th><th>상세주소</th></tr>");

            while (rs.next()) {
                resultHtml.append("<tr>");
                resultHtml.append("<td>").append(rs.getString("management_id")).append("</td>");
                resultHtml.append("<td>").append(rs.getString("district")).append("</td>");
                resultHtml.append("<td>").append(rs.getString("wifi_name")).append("</td>");
                resultHtml.append("<td>").append(rs.getString("road_address")).append("</td>");
                resultHtml.append("<td>").append(rs.getString("detailed_address")).append("</td>");
                resultHtml.append("</tr>");
            }

            resultHtml.append("</table>");
            out.print(resultHtml.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("<p>SQL 오류: " + e.getMessage() + "</p>");
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

</body>
</html>
