package model.dto;

public class PlantDTO {
//	private static final long serialVersionUID = 0;
			
	private String plantName;
	private String plantSize;
	
	public PlantDTO() {}

	public PlantDTO(String plantName, String plantSize) {
		this.plantName = plantName;
		this.plantSize = plantSize;
	}

	public String getPlantName() {
		return plantName;
	}

	public void setPlantName(String plantName) {
		this.plantName = plantName;
	}

	public String getPlantSize() {
		return plantSize;
	}

	public void setPlantSize(String plantSize) {
		this.plantSize = plantSize;
	}

	@Override
	public String toString() {
		return "PlantDTO [plantName=" + plantName + ", plantSize=" + plantSize + "]";
	}


	
}
