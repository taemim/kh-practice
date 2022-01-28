package section01.connection;

import static common.JDBCTemplate.close;

import static common.JDBCTemplate.getConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import model.dto.EmployeeDTO;

public class Application3 {

	public static void main(String[] args) {

		/*
		 * EMPLOYEE 테이블에서 조회한 사원의 이름의 성을 입력 받아 해당 사원의 정보와 같은 성씨를 가진 사원 정보를 모두 출력하세요.
		 * (PreparedStatement 객체 사용, List<EmployeeDTO> 객체에 담아서 출력)
		 * 
		 * 2022/01/29 과제응용
		 */

		System.out.println("<조회할 사원의 정보와 같은 성을 가진 사원 정보를 출력하기>");
		Connection con = getConnection();

		PreparedStatement pstmt = null;
		ResultSet rset = null;

		EmployeeDTO emp = null;
		List<EmployeeDTO> empList = null;

		Scanner sc = new Scanner(System.in);
		System.out.print("조회하실 사번을 입력하세요 : ");
		String empId = sc.nextLine();

		String empName = null;
		String empFirstName = null;

		/* 사번으로 사원명을 구하는 쿼리 */
		String query = "SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = ?";
		/* 같은 성을 가진 사원의 정보를 구하는 쿼리 */
		String query2 = "SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE ? || '%'";

		try {
			empList = new ArrayList<>();
			/* 첫번째 쿼리문 실행 */
			pstmt = con.prepareStatement(query);
			/* 입력받은 empId를 전달 */
			pstmt.setString(1, empId);

			rset = pstmt.executeQuery();

			if (rset.next()) {
				/* 사번으로 조회되면 EMP_NAME을 empName 변수에 담는다. */
				empName = rset.getString("EMP_NAME");

				/* substring() 메소드로 사원명의 성만 변수에 담는다. */
				empFirstName = empName.substring(0, 1);

				/* 두 번쩨 쿼리문 실행 */
				pstmt = con.prepareStatement(query2);
				pstmt.setString(1, empFirstName);

				rset = pstmt.executeQuery();

				while (rset.next()) {

					emp = new EmployeeDTO();

					emp.setEmpId(rset.getString("EMP_ID"));
					emp.setEmpName(rset.getString("EMP_NAME"));
					emp.setEmpNo(rset.getString("EMP_NO"));
					emp.setEmail(rset.getString("EMAIL"));
					emp.setPhone(rset.getString("PHONE"));
					emp.setDeptCode(rset.getString("DEPT_CODE"));
					emp.setJobCode(rset.getString("JOB_CODE"));
					emp.setSalLevel(rset.getString("SAL_LEVEL"));
					emp.setSalary(rset.getInt("SALARY"));
					emp.setBonus(rset.getDouble("BONUS"));
					emp.setManagerId(rset.getString("MANAGER_ID"));
					emp.setHireDate(rset.getDate("HIRE_DATE"));
					emp.setEntDate(rset.getDate("ENT_DATE"));
					emp.setEntYn(rset.getString("ENT_YN"));

					empList.add(emp);

				}
			} else {
				/* 조회하는 사번이 없는 경우 */
				System.out.println("조회하는 사원이 없습니다.");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rset);
			close(pstmt);
			close(con);
		}
		for (EmployeeDTO e : empList) {
			System.out.println(e);
		}
	}
}
