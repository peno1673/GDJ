package ex02_lambda.sec03;

public class Soil {
	
	private int totalOil = 1000;
	private int payPerLiter = 2000;
	private int earning;
	
	public void selloil(Car car) {
		car.addOil();
	}

	public int getTotalOil() {
		return totalOil;
	}

	public void setTotalOil(int totalOil) {
		this.totalOil = totalOil;
	}

	public int getPayPerLiter() {
		return payPerLiter;
	}

	public void setPayPerLiter(int payPerLiter) {
		this.payPerLiter = payPerLiter;
	}

	public int getEarning() {
		return earning;
	}

	public void setEarning(int earning) {
		this.earning = earning;
	}

	
	
}
