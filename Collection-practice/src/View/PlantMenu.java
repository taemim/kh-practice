package View;

import java.util.ArrayList;

import java.util.Comparator;
import java.util.List;
import java.util.Scanner;

import controller.PlantController;
import model.comparator.AscPlantSize;
import model.comparator.DescPlantName;
import model.comparator.DescPlantSize;
import model.dto.PlantDTO;

public class PlantMenu {
	private PlantController plantController = new PlantController();
	Scanner sc = new Scanner(System.in);
	
	
	public void mainMenu() {
		//	plantController.fileOpen();
	
		mainMenu:
		while(true) {
			System.out.println("========== 메뉴 ==========");
			System.out.println("1. 식물 추가");
			System.out.println("2. 식물 전체 조회");
			System.out.println("3. 정렬하여 조회");
			System.out.println("4. 식물명으로 검색");
			System.out.println("5. 사이즈로 검색");
			System.out.println("6. 식물 정보 수정");
			System.out.println("7. 식물 삭제");
			System.out.println("0. 프로그램 종료");
			System.out.print("메뉴 선택 : ");
			int menu = sc.nextInt();
			sc.nextLine();
			
			switch(menu) {
			case 1: 
				addPlant();
				break;
			case 2: 
				selectPlant();
				break;
			case 3: 
				sortPlant();
				break;
			case 4: 
				searchPlantName();
				break;
			case 5: 
				seachPlantSize();
				break;
			case 6: 
				updatePlant();
				break;
			case 7: 
				removePlant();
				break;
			case 0: 
				//plantcontroller.fileSave()
				System.out.println("프로그램을 종료합니다.");
				break mainMenu;
			default: 
				System.out.println("잘못 선택하셨습니다. 번호를 다시 입력하세요.");
				break;
			
			}
		}
	
		
	}


	private void addPlant() {
		System.out.println("========= 식물 등록 =========");
		System.out.print("식물 이름 입력: ");
		String plantName = sc.nextLine();
		System.out.print("식물 크기 입력: ");
		String plantSize = sc.nextLine();
		
		plantController.addPlant(new PlantDTO(plantName, plantSize));
	
	}


	private void selectPlant() {
		System.out.println("======== 식물 전체 조회 ========");
		List<PlantDTO> plantList = plantController.selectList();
		if (!plantList.isEmpty()){
			for(PlantDTO plant : plantList) {
				System.out.println(plant);
			}
		}else {
			System.out.println("목록이 존재하지 않습니다.");
		}
	}


	private void sortPlant() {
		System.out.println("======== 정렬 메뉴 ========");
		System.out.println("1. 식물명 오름차순 정렬");
		System.out.println("2. 식물사이즈 오름차순 정렬");
		System.out.println("3. 식물명 내림차순 정렬");
		System.out.println("4. 식물사이즈 내림차순 정렬");
		System.out.print("메뉴 선택 : ");
		int menu = sc.nextInt();
		sc.nextLine();
		
		ascDesc(menu);
		
		
	}


	private void ascDesc(int menu) {
		System.out.println("======= 정렬하여 조회 =======");
		List<PlantDTO> plantList = plantController.selectList();
		
		/* 정렬 시 원본 데이터를 변경하므로 사본 데이터를 별도로 생성한다. */
		List<PlantDTO> sortList = new ArrayList<>();
		sortList.addAll(plantList);
		
		if (menu == 1) {
		/* 익명 클래스를 사용할 수도 있다. */
			sortList.sort(new Comparator<PlantDTO>() {
				
				@Override
				public int compare(PlantDTO p1, PlantDTO p2) {
					return p1.getPlantName().compareTo(p2.getPlantName());
				}
			});
		} else if (menu == 2) {
			sortList.sort(new AscPlantSize());
		} else if (menu == 3) {
			sortList.sort(new DescPlantName());
		} else {
			sortList.sort(new DescPlantSize());
		} 
		
		for (int i = 0; i < sortList.size(); i++) {
			System.out.println(sortList.get(i));
		}
	}


	private void searchPlantName() {
		System.out.println("======= 식물명으로 검색 =======");
		System.out.print("식물명 이름 : ");
		List<PlantDTO> searchList = plantController.searchPlantName(sc.nextLine());
		
		if(!searchList.isEmpty()) {
			for(int i=0; i < searchList.size(); i++) {
				System.out.println(searchList.get(i));
			}
		}else {
			System.out.println("검색 결과가 없습니다.");
		}
	}


	private void seachPlantSize() {
		System.out.println("====== 식물 사이즈로 검색 ======");
		System.out.print("식물 사이즈 : ");
		List<PlantDTO> searchList = plantController.searchPlantSize(sc.nextLine());
		
		if(!searchList.isEmpty()) {
			for(int i=0; i < searchList.size(); i++) {
				System.out.println(searchList.get(i));
			}
		}else {
			System.out.println("검색 결과가 없습니다.");
		}
	}

	private void updatePlant() {
		System.out.println("====== 식물 정보 수정 ======");
		System.out.print("수정할 식물의 이름 : ");
		String plant = sc.nextLine();
		
		System.out.print("수정할 식물명 : ");
		String updateName = sc.nextLine();
		System.out.print("수정할 식물사이즈 : ");
		String updateSize = sc.nextLine();
		
		PlantDTO updatePlant = new PlantDTO(updateName, updateSize);
		int result = plantController.UpdatePlant(plant,updatePlant);
		
		if (result > 0) {
			System.out.println("성공적으로 수정되었습니다.");
		} else {
			System.out.println("수정할 식물을 찾지 못했습니다.");
		}
	}


	private void removePlant() {
		System.out.println("======== 식물 삭제 ========");
		System.out.print("삭제할 식물의 이름 : ");
		int result = plantController.removePlant(sc.nextLine());

		if (result > 0) {
			System.out.println("성공적으로 삭제 되었습니다.");
		} else {
			System.out.println("삭제할 식물을 찾지 못했습니다.");
		}
		
	}
	
}
