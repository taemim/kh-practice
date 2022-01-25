package controller;

import java.util.ArrayList;
import java.util.List;


import model.dto.PlantDTO;

public class PlantController {

	private List<PlantDTO> plantList = new ArrayList<>();
	
	public void addPlant(PlantDTO plant) {
		plantList.add(plant);
	}

	public List<PlantDTO> selectList() {
		
		return plantList;
	}
	/*식물명 조회*/
	public List<PlantDTO> searchPlantName(String plantName) {
		List<PlantDTO> searchPlantName = new ArrayList<>();
		
		for(PlantDTO plant : plantList) {
			if(plant.getPlantName().contains(plantName)) {
				searchPlantName.add(plant);
			}
		}
		return searchPlantName;
	}
	
	/*사이즈로 조회*/
	public List<PlantDTO> searchPlantSize(String plantSize) {
		List<PlantDTO> searchPlantSize = new ArrayList<>();
		
		for(PlantDTO plant : plantList) {
			if(plant.getPlantSize().contains(plantSize)) {
				searchPlantSize.add(plant);
			}
		}
		return searchPlantSize;
	}
	/* 식물명 수정 - 식물명 기준으로 조회해서 수정 */
	public int UpdatePlant(String plant, PlantDTO updatePlant) {
		 PlantDTO old = null;
		 /* 식물명이 완벽하게 일치하는 객체를 대상으로 변경한다. */
		 for(int i =0; i < plantList.size(); i++) {
			 if(plantList.get(i).getPlantName().equals(plant)) {
				 old = plantList.set(i, updatePlant);
			 }
		 }
		/* oldValue가 반환 된 경우 result는 1, oldValue가 반환 되지 않은 경우 result는 0이다. */
		return old != null? 1 : 0;
	}
	/* 식물 삭제 - 식물명 기준으로 조회해서 수정 */
	public int removePlant(String plant) {
		PlantDTO old = null;
		for (int i = 0; i < plantList.size(); i++) {
			if(plantList.get(i).getPlantName().equals(plant)) {
				old = plantList.remove(i);
			}
		}
		/* oldValue가 반환 된 경우 result는 1, oldValue가 반환 되지 않은 경우 result는 0이다. */
		return old != null? 1 : 0;
	}

}
