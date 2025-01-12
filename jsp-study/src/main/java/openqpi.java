import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class openqpi {

    public static Connection getDatabaseConnection() {
        String url = "jdbc:mariadb://localhost:3306/openapi";
        String username = "root";
        String password = "zerobase";

        try {
            // 드라이버 로드
            Class.forName("org.mariadb.jdbc.Driver");

            // 연결 시도
            Connection connection = DriverManager.getConnection(url, username, password);
            System.out.println("MariaDB 연결 성공!");
            return connection;

        } catch (ClassNotFoundException e) {
            System.out.println("MariaDB JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection failed!");
            e.printStackTrace();
        }
        return null;
    }
}
