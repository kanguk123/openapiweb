<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 가져오기</title>
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
    </style>
</head>
<body>
    <h1>Open API 와이파이 정보 가져오기</h1>
    <div>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="load-wifi-result.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="lookbookmark.jsp">북마크 보기</a> |
        <a href="bookmark.jsp">북마크 그룹 관리</a> |
    </div>

    <div>
        <h2>와이파이 정보</h2>
        <%
            // 위와 동일한 코드로 와이파이 정보 가져오기 및 처리
        %>
    </div>
</body>
</html>
