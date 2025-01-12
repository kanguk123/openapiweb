<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>북마크 그룹 관리</title>
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
            width: 20%;
        }
        td {
            width: 80%; /* 흰색 칸 너비 늘리기 */
        }
        td.centered {
            text-align: center;
            vertical-align: middle;
            height: 50px;
        }

        /* 폼을 가운데 정렬 */
        .form-container {
            text-align: center;
            margin-top: 20px;
        }
        .form-table {
            margin: 0 auto;
        }
        .submit-button {
            padding: 10px 20px;
            background-color: #009900;
            color: white;
            border: none;
            cursor: pointer;
        }
        .submit-button:hover {
            background-color: #007700;
        }
    </style>
    <script>
        // 북마크 이름과 순서를 입력할 수 있는 폼을 추가하는 함수
        function showAddForm() {
            document.getElementById("addForm").style.display = "block";
            document.getElementById("bookmarkList").style.display = "none"; // 북마크 목록 숨기기
        }

        // 폼을 숨기는 함수
        function hideAddForm() {
            document.getElementById("addForm").style.display = "none";
            document.getElementById("bookmarkList").style.display = "block"; // 북마크 목록 보이기
        }
    </script>
</head>
<body>
    <h1>북마크 그룹 관리</h1>
    <div>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="load-wifi-result.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="lookbookmark.jsp">북마크 보기</a> |
        <a href="bookmark.jsp">북마크 그룹 관리</a> |
    </div>
    <div>
        <button onclick="showAddForm()">북마크 그룹 이름 추가</button>
    </div>

    <!-- 북마크 그룹 추가 폼 -->
    <div id="addForm" style="display:none;">
        <h2>새로운 북마크 그룹 추가</h2>
        <form action="bookmark.jsp" method="post">
            <table class="form-table">
                <tr>
                    <th>북마크 이름</th>
                    <td><input type="text" id="groupName" name="groupName" required></td>
                </tr>
                <tr>
                    <th>순서</th>
                    <td><input type="number" id="groupOrder" name="groupOrder" required></td>
                </tr>
            </table>
            <div class="form-container">
                <input type="submit" value="추가" class="submit-button">
            </div>
        </form>
    </div>

    <!-- 북마크 그룹 목록 (초기 상태에서만 보임) -->
    <div id="bookmarkList">
        <h2>북마크 그룹 목록</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>북마크 이름</th>
                <th>순서</th>
                <th>등록일자</th>
                <th>수정일자</th>
                <th>비고</th>
            </tr>
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
                    String query = "SELECT * FROM bookmark_groups ORDER BY group_order";
                    stmt = conn.prepareStatement(query);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String groupName = rs.getString("group_name");
                        int groupOrder = rs.getInt("group_order");
                        String createdDate = rs.getString("created_date");
                        String modifiedDate = rs.getString("modified_date");
            %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= groupName %></td>
                            <td><%= groupOrder %></td>
                            <td><%= createdDate %></td>
                            <td><%= modifiedDate %></td>
                            <td>
                                <a href="editBookmark.jsp?id=<%= id %>">수정</a> |
                                <a href="deleteBookmark.jsp?id=<%= id %>">삭제</a>
                            </td>
                        </tr>
            <%
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
        </table>
    </div>

    <%
        // 데이터 추가 처리
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String groupName = request.getParameter("groupName");
            int groupOrder = Integer.parseInt(request.getParameter("groupOrder"));

            try {
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                String insertQuery = "INSERT INTO bookmark_groups (group_name, group_order) VALUES (?, ?)";
                stmt = conn.prepareStatement(insertQuery);
                stmt.setString(1, groupName);
                stmt.setInt(2, groupOrder);
                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted > 0) {
                    out.print("<p>새로운 북마크 그룹이 추가되었습니다.</p>");
                } else {
                    out.print("<p>추가 실패. 다시 시도해주세요.</p>");
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
