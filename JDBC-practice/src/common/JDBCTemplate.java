package common;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class JDBCTemplate {

	public static Connection getConnection() {

		/* Connection 레퍼런스 변수 생성 */
		Connection con = null;

		Properties prop = new Properties();

		try {
			prop.load(new FileReader("config/connection-info.properties"));

			String driver = prop.getProperty("driver");
			String url = prop.getProperty("url");

			/* DriverManager : JDBC드라이버를 통해 커넥션을 만드는 역할 forName()를 통해 생성 */
			Class.forName(driver);

			/* getConnection() 메소드로 인스턴스 생성 */
			con = DriverManager.getConnection(url, prop);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return con;
	}

	/* close(con) 메소드 생성 */
	public static void close(Connection con) {
		try {
			if (con != null && !con.isClosed()) {
				con.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/* close(stmt) 메소드 생성 */
	public static void close(Statement stmt) {
		try {
			if (stmt != null && !stmt.isClosed()) {
				stmt.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/* close(rset) 메소드 생성 */
	public static void close(ResultSet rset) {
		try {
			if (rset != null && !rset.isClosed()) {
				rset.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
