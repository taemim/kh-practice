package model.comparator;

import java.util.Comparator;

import model.dto.PlantDTO;

public class DescPlantName implements Comparator< PlantDTO> {
	
	@Override
	public int compare(PlantDTO p1, PlantDTO p2) {
		return -p1.getPlantName().compareTo(p2.getPlantName());
	}
	
}
