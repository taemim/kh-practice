package ncs.test1;

public class StringTest {

	public static void main(String[] args) {

		/*
		 * 주어진 String 데이터를 ","로 나누어 5 개의 실수 데이터들을 꺼내어 합과 평균을 구한다. 
		 * 단, String 문자열의 모든 실수 데이터를 배열로 만들어 계산한다.
		 * 2022/02/04 과제
		 */

		String str = "1.22,4.12,5.93,8.71,9.34";
		double data[] = new double[5];
		double sum = 0;

		String[] st = str.split(",");

		int count = 0;
		
		for(String s : st) {
			data[count] = Double.parseDouble(s);
			
			sum += data[count];
			
			count++;
		}

		System.out.printf("합계 : %.3f\n", sum);
		System.out.printf("평균 : %.3f", sum/count);

	}
}
