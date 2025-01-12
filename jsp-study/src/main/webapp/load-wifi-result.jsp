<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 저장 완료</title>
    <link rel="stylesheet" href="/resources/css/index.css">
    <style>
        .result-container {
            text-align: center;
            margin-top: 50px;
        }
        .result-container button {
            padding: 10px 20px;
            background-color: #009900;
            color: white;
            border: none;
            font-size: 16px;
            cursor: pointer;
        }
        .result-container button:hover {
            background-color: #006600;
        }
    </style>
</head>
<body>
    <div class="result-container">
        <h1>1000개의 WiFi 정보를 정상적으로 저장하였습니다.</h1>
       <button onclick="window.location.href='index.jsp'">홈으로 가기</button>
    </div>
</body>
</html>
