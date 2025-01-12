<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
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
            text-align: center;
            vertical-align: middle;
            height: 50px;
        }
    </style>
    <script>
        function getLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    document.getElementById('LAT').value = position.coords.latitude;
                    document.getElementById('LNT').value = position.coords.longitude;
                }, function(error) {
                    alert("위치 정보를 가져오는데 실패했습니다. " + error.message);
                });
            } else {
                alert("이 브라우저는 위치 정보를 지원하지 않습니다.");
            }
        }
    </script>
</head>
<body>
    <h1>와이파이 정보 구하기</h1>
    <div>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="load-wifi-result.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="lookbookmark.jsp">북마크 보기</a> |
        <a href="bookmark.jsp">북마크 그룹 관리</a> |
    </div>
    <div style="margin: 20px 0;">
        LAT: <input type="text" id="LAT" value="0.0">, 
        LNT: <input type="text" id="LNT" value="0.0">
        <button onclick="getLocation()">내 위치 가져오기</button>
        <button onclick="window.location.href='getWifiInfo.jsp?lat=' + document.getElementById('LAT').value + '&lon=' + document.getElementById('LNT').value">근처 WIFI 정보 보기</button>
    </div>

    <div>
        <h2>근처 Wi-Fi 정보</h2>
        <%
            String latParam = request.getParameter("lat");
            String lonParam = request.getParameter("lon");

            if (latParam == null || lonParam == null || latParam.trim().isEmpty() || lonParam.trim().isEmpty()) {
                out.print("<p>위치 정보가 잘못되었습니다. 다시 시도해주세요.</p>");
                return;
            }

            double lat = 0.0;
            double lon = 0.0;
            try {
                lat = Double.parseDouble(latParam);
                lon = Double.parseDouble(lonParam);
            } catch (NumberFormatException e) {
                out.print("<p>위치 정보가 올바르지 않습니다. 다시 시도해주세요.</p>");
                return;
            }

            double R = 6371;
            try {
                Class.forName("org.mariadb.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                out.print("<p>MariaDB 드라이버를 찾을 수 없습니다. 드라이버가 설치되어 있는지 확인해주세요.</p>");
                return;
            }

            String dbUrl = "jdbc:mariadb://localhost:3306/openapi";
            String dbUser = "root";
            String dbPassword = "zerobase";
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            String query = "SELECT * FROM wifiInfo";

            List<String[]> wifiList = new ArrayList<>();

            try {
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    double wifiLat = rs.getDouble("x_coordinate");
                    double wifiLon = rs.getDouble("y_coordinate");

                    double latDistance = Math.toRadians(wifiLat - lat);
                    double lonDistance = Math.toRadians(wifiLon - lon);
                    double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                             + Math.cos(Math.toRadians(lat)) * Math.cos(Math.toRadians(wifiLat))
                             * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
                    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
                    double distance = R * c;

                    if (distance <= 3.0) {
                        String[] wifiData = new String[]{
                            String.format("%.2f", distance),
                            rs.getString("management_id"),
                            rs.getString("district"),
                            rs.getString("wifi_name"),
                            rs.getString("road_address"),
                            rs.getString("detailed_address"),
                            rs.getString("installation_floor"),
                            rs.getString("installation_type"),
                            rs.getString("installation_agency"),
                            rs.getString("service_type"),
                            rs.getString("network_type"),
                            String.valueOf(rs.getInt("installation_year")),
                            rs.getString("indoor_outdoor"),
                            rs.getString("wifi_env"),
                            String.valueOf(rs.getDouble("x_coordinate")),
                            String.valueOf(rs.getDouble("y_coordinate")),
                            rs.getString("work_date")
                        };
                        wifiList.add(wifiData);
                    }
                }

                wifiList.sort((wifi1, wifi2) -> Double.compare(Double.parseDouble(wifi1[0]), Double.parseDouble(wifi2[0])));

                StringBuilder resultHtml = new StringBuilder();
                resultHtml.append("<table>");
                resultHtml.append("<tr><th>거리(Km)</th><th>관리번호</th><th>자치구</th><th>와이파이명</th><th>도로명주소</th><th>상세주소</th><th>설치위치(층)</th><th>설치유형</th><th>설치기관</th><th>서비스구분</th><th>망종류</th><th>설치년도</th><th>실내외구분</th><th>WIFI접속환경</th><th>X좌표</th><th>Y좌표</th><th>작업일자</th></tr>");

                for (String[] wifiData : wifiList) {
                    resultHtml.append("<tr>");
                    for (int i = 0; i < wifiData.length; i++) {
                        if (wifiData[i] != null && !wifiData[i].trim().isEmpty()) {
                            if (i == 3) {
                                // 와이파이명 열에 클릭 가능한 링크 추가
                                resultHtml.append("<td><a href='detail.jsp?wifiId=" + wifiData[1] + "'>" + wifiData[i] + "</a></td>");
                            } else {
                                resultHtml.append("<td>" + wifiData[i] + "</td>");
                            }
                        } else {
                            resultHtml.append("<td></td>");
                        }
                    }
                    resultHtml.append("</tr>");
                }

                resultHtml.append("</table>");
                out.print(resultHtml.toString());

            } catch (SQLException e) {
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
    </div>
</body>
</html>
