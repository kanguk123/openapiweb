<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
    <link rel="stylesheet" href="/resources/css/index.css">
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
        td.centered {
            text-align: center;        /* 가로 중앙 정렬 */
            vertical-align: middle;     /* 세로 중앙 정렬 */
            height: 50px;               /* 적절한 높이 설정 */
        }
        /* 테이블에 대해 스크롤 기능 추가 및 마지막 컬럼까지 박스쳐지도록 설정 */
        #wifiTable {
            table-layout: fixed;
            width: 100%;
        }
        #wifiTable th, #wifiTable td {
            word-wrap: break-word;
        }
    </style>
    <script src="getWifiInfo.js" defer></script>
    <script> 
        /* 내 위치 가져오는 기능 */  
        function getLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(saveLocation);
            } else {
                alert("이 브라우저는 Geolocation을 지원하지 않습니다.");
            }
        }

        function saveLocation(position) {
            var lat = position.coords.latitude;
            var lon = position.coords.longitude;

            document.getElementById("LAT").value = lat;
            document.getElementById("LNT").value = lon;

            // AJAX 요청으로 위치 정보 DB에 저장
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "getLocation.jsp?lat=" + lat + "&lon=" + lon, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    alert(xhr.responseText);  // 위치 정보 저장 여부 확인
                }
            };
            xhr.send();
        }
        
        // 위치 정보 전달 버튼 클릭 시
        function goToWifiInfo() {
            var lat = document.getElementById('LAT').value;
            var lon = document.getElementById('LNT').value;

            console.log('LAT: ' + lat);  // 디버깅: LAT 값 확인
            console.log('LNT: ' + lon);  // 디버깅: LNT 값 확인

            if (lat === "0.0" || lon === "0.0") {
                alert("위치 정보가 올바르지 않습니다.");
            } else {
                window.location.href = 'getWifiInfo.jsp?lat=' + lat + '&lon=' + lon;
            }
        }
    </script>
</head>
<body>
    <h1>와이파이 정보 구하기</h1>
    <div>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="load-wifi-result.jsp">Open API 와이파이 정보 가져오기</a>
        <a href="lookbookmark.jsp">북마크 보기</a> |
        <a href="bookmark.jsp">북마크 그룹 관리</a> |
    </div>
    <div style="margin: 20px 0;">
        LAT: <input type="text" id="LAT" value="0.0">, 
        LNT: <input type="text" id="LNT" value="0.0">
        <button onclick="getLocation()">내 위치 가져오기</button>
        <button onclick="goToWifiInfo()">근처 WIFI 정보 보기</button>
    </div>

    <div id="result"></div>

    <table id="wifiTable">
        <tr>
            <th>거리(Km)</th>
            <th>관리번호</th>
            <th>자치구</th>
            <th>와이파이명</th>
            <th>도로명주소</th>
            <th>상세주소</th>
            <th>설치위치(층)</th>
            <th>설치유형</th>
            <th>설치기관</th>
            <th>서비스구분</th>
            <th>망종류</th>
            <th>설치년도</th>
            <th>실내외구분</th>
            <th>WIFI접속환경</th>
            <th>X좌표</th>
            <th>Y좌표</th>
            <th>작업일자</th>
        </tr>
        <tr>
            <td colspan="17" class="centered">위치 정보를 입력한 후에 조회해 주세요</td>
        </tr>
    </table>
</body>
</html>
