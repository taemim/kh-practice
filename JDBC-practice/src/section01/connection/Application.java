package section01.connection;

import static common.JDBCTemplate.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import model.dto.EmployeeDTO;

public class Application {

	public static void main(String[] args) {

		/* Scanner를 이용해서 사번을 입력 받고 해당 사번의 
		 * 사원 정보를 EmployeeDTO에 담아서 출력하세요
		 * (PreparedStatement 객체를 사용하시오)
		 * 
		 * 2022/01/28 과제*/
		
		EmployeeDTO selectedEmp = null;
		
		/* DB접속을 위한 Connection 인스턴스 생성 */
		Connection con = getConnection();

		PreparedStatement pstmt = null;
		ResultSet rset = null;

		System.out.print("조회하실 사번을 입력 하세요 : ");
		Scanner sc = new Scanner(System.in);

		String empId = sc.nextLine();

		String query = "SELECT * FROM EMPLOYEE WHERE EMP_ID = ?";

		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, empId);

			rset = pstmt.executeQuery();

			if (rset.next()) {

				selectedEmp = new EmployeeDTO();

				selectedEmp.setEmpId(rset.getString("EMP_ID"));
				selectedEmp.setEmpName(rset.getString("EMP_NAME"));
				selectedEmp.setEmpNo(rset.getString("EMP_NO"));
				selectedEmp.setEmail(rset.getString("EMAIL"));
				selectedEmp.setPhone(rset.getString("PHONE"));
				selectedEmp.setDeptCode(rset.getString("DEPT_CODE"));
				selectedEmp.setJobCode(rset.getString("JOB_CODE"));
				selectedEmp.setSalLevel(rset.getString("SAL_LEVEL"));
				selectedEmp.setSalary(rset.getInt("SALARY"));
				selectedEmp.setBonus(rset.getDouble("BONUS"));
				selectedEmp.setManagerId(rset.getString("MANAGER_ID"));
				selectedEmp.setHireDate(rset.getDate("HIRE_DATE"));
				selectedEmp.setEntDate(rset.getDate("ENT_DATE"));
				selectedEmp.setEntYn(rset.getString("ENT_YN"));

			} else {
				System.out.println("조회하는 사원이 없습니다.");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rset);
			close(pstmt);
			close(con);
		}

		System.out.println("slectedEmp : " + selectedEmp);

	}

}
