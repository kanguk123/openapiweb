import java.sql.*;
import java.net.*;
import java.io.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.net.URL;


public class hello {
    public static void main(String[] args) {
    	System.setProperty("mariadb.log.logger", "NONE");
        String dbUrl = "jdbc:mariadb://localhost:3306/openapi?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";  // MariaDB 사용자명
        String dbPassword = "zerobase";  // MariaDB 비밀번호

        // API URL 및 키 설정
        String apiUrl = "http://openapi.seoul.go.kr:8088/6c6b527171736f6c3130304d6b68654b/json/TbPublicWifiInfo/1/1000/";

        // MariaDB 연결 및 API 데이터 삽입 준비
        String insertQuery = "INSERT INTO wifiInfo (management_id, district, wifi_name, road_address, detailed_address, " +
                             "installation_floor, installation_type, installation_agency, service_type, network_type, " +
                             "installation_year, indoor_outdoor, wifi_env, x_coordinate, y_coordinate, work_date) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        
        
        try {
            // API 호출하여 JSON 데이터 받기
            String jsonResponse = callApi(apiUrl);

            // JSON 파싱
            JSONObject jsonObject = new JSONObject(jsonResponse);
            JSONObject tbPublicWifiInfo = jsonObject.getJSONObject("TbPublicWifiInfo");
            JSONArray wifiList = tbPublicWifiInfo.getJSONArray("row");

            // MariaDB 연결
            Connection connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            PreparedStatement preparedStatement = connection.prepareStatement(insertQuery);

            // JSON 데이터 삽입
            for (int i = 0; i < wifiList.length(); i++) {
                JSONObject wifiData = wifiList.getJSONObject(i);

                // 데이터 매핑 및 PreparedStatement에 설정
                preparedStatement.setString(1, convertToNull(wifiData.optString("X_SWIFI_MGR_NO", "")));  // 관리번호
                preparedStatement.setString(2, convertToNull(wifiData.optString("X_SWIFI_WRDOFC", "")));  // 자치구
                preparedStatement.setString(3, convertToNull(wifiData.optString("X_SWIFI_MAIN_NM", "")));  // 와이파이명
                preparedStatement.setString(4, convertToNull(wifiData.optString("X_SWIFI_ADRES1", "")));  // 도로명주소
                preparedStatement.setString(5, convertToNull(wifiData.optString("X_SWIFI_ADRES2", "")));  // 상세주소
                preparedStatement.setString(6, convertToNull(wifiData.optString("X_SWIFI_INSTL_FLOOR", "")));  // 설치위치(층)
                preparedStatement.setString(7, convertToNull(wifiData.optString("X_SWIFI_INSTL_TY", "")));  // 설치유형
                preparedStatement.setString(8, convertToNull(wifiData.optString("X_SWIFI_INSTL_MBY", "")));  // 설치기관
                preparedStatement.setString(9, convertToNull(wifiData.optString("X_SWIFI_SVC_SE", "")));  // 서비스구분
                preparedStatement.setString(10, convertToNull(wifiData.optString("X_SWIFI_CMCWR", "")));  // 망종류
                preparedStatement.setInt(11, wifiData.optInt("X_SWIFI_CNSTC_YEAR", 0));  // 설치년도
                preparedStatement.setString(12, convertToNull(wifiData.optString("X_SWIFI_INOUT_DOOR", "")));  // 실내외구분
                preparedStatement.setString(13, convertToNull(wifiData.optString("X_SWIFI_REMARS3", "")));  // WIFI접속환경
                preparedStatement.setFloat(14, wifiData.optFloat("LAT", 0));  // X좌표
                preparedStatement.setFloat(15, wifiData.optFloat("LNT", 0));  // Y좌표

                // 날짜 처리: WORK_DTTM 값이 비어있거나 잘못된 형식일 경우 처리
                String workDateStr = wifiData.optString("WORK_DTTM", "");
                if (workDateStr.isEmpty()) {
                    preparedStatement.setDate(16, null);  // 빈 값일 경우 null로 설정
                } else {
                    try {
                        preparedStatement.setDate(16, java.sql.Date.valueOf(workDateStr));  // 날짜 형식 변환
                    } catch (IllegalArgumentException e) {
                        preparedStatement.setDate(16, null);  // 잘못된 형식일 경우 null로 설정
                    }
                }

                // 데이터 삽입
                preparedStatement.executeUpdate();
            }

            System.out.println("Data inserted successfully!");
      
            // 자원 정리
            preparedStatement.close();
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 빈 문자열을 null로 변환하는 메서드
    private static String convertToNull(String value) {
        return value.isEmpty() ? null : value;
    }

    // API 호출 및 응답 받기
   
	public static String callApi(String apiUrl) throws IOException {
        StringBuilder result = new StringBuilder();
        try {
            URI uri = new URI(apiUrl);  // URI 객체 생성
            URL url = uri.toURL();      // URI를 URL로 변환
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));

            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                result.append(inputLine);
            }
            in.close();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
		/*URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));

        String inputLine;
        while ((inputLine = in.readLine()) != null) {
            result.append(inputLine);
        }
        in.close();*/
        return result.toString();
    }
}
