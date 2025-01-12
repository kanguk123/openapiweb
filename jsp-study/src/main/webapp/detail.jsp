<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
  <title>Wi-Fi 상세 정보</title>
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
        width: 20%; /* 초록색 칸 너비 줄이기 */
    }
    td {
        width: 80%; /* 흰색 칸 너비 늘리기 */
    }
</style>

</head>
<body>
    <h1>Wi-Fi 상세 정보</h1>
    <div>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="load-wifi-result.jsp">근처 Wi-Fi 목록</a>
        <a href="lookbookmark.jsp">북마크 보기</a> |
        <a href="bookmark.jsp">북마크 그룹 관리</a> |
    </div>

    <%
        // Wi-Fi 고유 ID를 파라미터로 받음
        String wifiId = request.getParameter("wifiId");

        if (wifiId == null || wifiId.trim().isEmpty()) {
            out.print("<p>잘못된 접근입니다. Wi-Fi ID가 없습니다.</p>");
            return;
        }

        // MariaDB 연결 설정
        String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
        String dbUser = "root";
        String dbPassword = "zerobase";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        // Wi-Fi 상세 정보를 조회하는 SQL 쿼리
        String query = "SELECT * FROM wifiInfo WHERE management_id = ?";

        try {
            Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로드

            // 데이터베이스 연결
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            stmt = conn.prepareStatement(query);
            stmt.setString(1, wifiId);  // 고유 ID를 쿼리 파라미터로 설정

            rs = stmt.executeQuery();

            // 결과가 있을 경우
            if (rs.next()) {
                out.print("<table>");
                out.print("<tr><th>관리번호</th><td>" + rs.getString("management_id") + "</td></tr>");
                out.print("<tr><th>자치구</th><td>" + rs.getString("district") + "</td></tr>");
                out.print("<tr><th>와이파이명</th><td>" + rs.getString("wifi_name") + "</td></tr>");
                out.print("<tr><th>도로명주소</th><td>" + rs.getString("road_address") + "</td></tr>");
                out.print("<tr><th>상세주소</th><td>" + rs.getString("detailed_address") + "</td></tr>");
                out.print("<tr><th>설치위치(층)</th><td>" + rs.getString("installation_floor") + "</td></tr>");
                out.print("<tr><th>설치유형</th><td>" + rs.getString("installation_type") + "</td></tr>");
                out.print("<tr><th>설치기관</th><td>" + rs.getString("installation_agency") + "</td></tr>");
                out.print("<tr><th>서비스구분</th><td>" + rs.getString("service_type") + "</td></tr>");
                out.print("<tr><th>망종류</th><td>" + rs.getString("network_type") + "</td></tr>");
                out.print("<tr><th>설치년도</th><td>" + rs.getInt("installation_year") + "</td></tr>");
                out.print("<tr><th>실내외구분</th><td>" + rs.getString("indoor_outdoor") + "</td></tr>");
                out.print("<tr><th>WIFI접속환경</th><td>" + rs.getString("wifi_env") + "</td></tr>");
                out.print("<tr><th>X좌표</th><td>" + rs.getDouble("x_coordinate") + "</td></tr>");
                out.print("<tr><th>Y좌표</th><td>" + rs.getDouble("y_coordinate") + "</td></tr>");
                out.print("<tr><th>작업일자</th><td>" + rs.getString("work_date") + "</td></tr>");
                out.print("</table>");

                // 북마크 그룹 선택 드롭다운 추가
                out.print("<h3>북마크 그룹에 추가</h3>");
                out.print("<form action='addBookmark.jsp' method='post'>");
                out.print("<label for='groupId'>북마크 그룹 선택: </label>");
                out.print("<select name='groupId' required>");
                
                // 북마크 그룹 목록을 조회하는 쿼리
                String groupQuery = "SELECT * FROM bookmark_groups ORDER BY group_order";
                stmt = conn.prepareStatement(groupQuery);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int groupId = rs.getInt("id");
                    String groupName = rs.getString("group_name");
                    out.print("<option value='" + groupId + "'>" + groupName + "</option>");
                }
                out.print("</select><br>");
                out.print("<input type='hidden' name='wifiId' value='" + wifiId + "'>");
                out.print("<input type='submit' value='북마크 추가하기' />");
                out.print("</form>");
            } else {
                out.print("<p>해당 Wi-Fi 정보를 찾을 수 없습니다.</p>");
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.print("<p>데이터베이스 오류가 발생했습니다. 다시 시도해주세요.</p>");
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