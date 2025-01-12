package com.example.servlet;

import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/wifiInfo")
public class WifiInfoServlet extends HttpServlet {

    // DB 연결 정보
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/openapi";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "zerobase";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 클라이언트에서 전달된 위도, 경도 받기
        double lat = Double.parseDouble(request.getParameter("LAT"));
        double lon = Double.parseDouble(request.getParameter("LNT"));

        List<WifiInfo> nearbyWifiList = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "SELECT * FROM wifiInfo";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                // 데이터베이스에서 좌표 및 정보를 추출
                double wifiLat = rs.getDouble("x_coordinate");  // X 좌표
                double wifiLon = rs.getDouble("y_coordinate");  // Y 좌표
                String managementId = rs.getString("management_id");
                String district = rs.getString("district");
                String wifiName = rs.getString("wifi_name");
                String roadAddress = rs.getString("road_address");
                String detailedAddress = rs.getString("detailed_address");
                Double distance = rs.getDouble("distance");  // NULL일 수 있어 Double 사용
                String installationFloor = rs.getString("installation_floor");
                String installationType = rs.getString("installation_type");
                String installationAgency = rs.getString("installation_agency");
                String serviceType = rs.getString("service_type");
                String networkType = rs.getString("network_type");
                Integer installationYear = rs.getInt("installation_year");
                String indoorOutdoor = rs.getString("indoor_outdoor");
                String wifiEnv = rs.getString("wifi_env");
                String workDate = rs.getString("work_date");

                // 거리 계산 (Haversine 공식을 사용)
                double calculatedDistance = calculateDistance(lat, lon, wifiLat, wifiLon);

                if (calculatedDistance <= 1.0) {  // 1km 이내 Wi-Fi만 추가
                    WifiInfo wifiInfo = new WifiInfo(managementId, district, wifiName, roadAddress, detailedAddress, distance, installationFloor, installationType, installationAgency, serviceType, networkType, installationYear, indoorOutdoor, wifiEnv, wifiLat, wifiLon, workDate);
                    nearbyWifiList.add(wifiInfo);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // JSON 응답 생성
        response.setContentType("application/json");
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(nearbyWifiList);
        response.getWriter().write(jsonResponse);
    }

    // 거리 계산 함수 (Haversine 공식)
    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final double R = 6371; // 지구 반지름 (킬로미터)
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c; // 반환값은 킬로미터 단위
    }
}
