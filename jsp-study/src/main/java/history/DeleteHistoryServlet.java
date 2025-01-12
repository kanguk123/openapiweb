package history;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/deleteHistory")
public class DeleteHistoryServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String deleteId = request.getParameter("id");

        if (deleteId != null) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/openapi", "root", "zerobase");
                String deleteQuery = "DELETE FROM history WHERE id = ?";
                stmt = conn.prepareStatement(deleteQuery);
                stmt.setInt(1, Integer.parseInt(deleteId));
                stmt.executeUpdate();
                
                // 삭제 후 history.jsp로 리다이렉트
                response.sendRedirect("history.jsp");

            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
