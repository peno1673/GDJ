package ex02_lambda.sec03;

public class Main {

	public static void main(String[] args) {

		Soil soil = new Soil();

		//		soil.selloil(new Car() {
		//			
		//			@Override
		//			public void addOil() {
		//				int oil = 30;
		//				soil.setTotalOil(soil.getTotalOil() - oil);
		//				soil.setEarning(soil.getEarning() + oil * soil.getPayPerLiter());
		//				System.out.println("감사");
		//			}
		//		});
		soil.selloil(() -> {
			int oil = 30;
			soil.setTotalOil(soil.getTotalOil() - oil);
			soil.setEarning(soil.getEarning() + oil * soil.getPayPerLiter());
			System.out.println("감사");
		});

		System.out.println(soil.getTotalOil());
		System.out.println(soil.getEarning());
	}
}
