<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>위치 히스토리 목록</title>
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
            background-color: #009900;
            color: white;
        }
        .delete-btn {
            color: red;
            cursor: pointer;
        }
    </style>
    <script>
        // 삭제 버튼 클릭 시 AJAX를 사용하여 서버로 삭제 요청
        function deleteHistory(id) {
            if (confirm("정말 삭제하시겠습니까?")) {
                var xhr = new XMLHttpRequest();
                xhr.open("GET", "deleteHistory.jsp?id=" + id, true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        // 삭제 후 페이지 새로 고침
                        alert("삭제되었습니다.");
                        location.reload();
                    }
                };
                xhr.send();
            }
        }
    </script>
</head>
<body>
    <h1>위치 히스토리 목록</h1>

    <table>
        <tr>
            <th>ID</th>
            <th>위도</th>
            <th>경도</th>
            <th>조회일자</th>
            <th>삭제</th>
        </tr>
        <%
            // DB에서 위치 히스토리 가져오기
            String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
            String dbUser = "root";
            String dbPassword = "zerobase";
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                String selectQuery = "SELECT * FROM history ORDER BY query_date DESC";
                stmt = conn.prepareStatement(selectQuery);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    double lat = rs.getDouble("lat");
                    double lon = rs.getDouble("lon");
                    String queryDate = rs.getString("query_date");

                    out.print("<tr>");
                    out.print("<td>" + id + "</td>");
                    out.print("<td>" + lat + "</td>");
                    out.print("<td>" + lon + "</td>");
                    out.print("<td>" + queryDate + "</td>");
                    out.print("<td><button class='delete-btn' onclick='deleteHistory(" + id + ")'>삭제</button></td>");
                    out.print("</tr>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
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
    </table>
    <a href="index.jsp">홈으로</a>
</body>
</html>
