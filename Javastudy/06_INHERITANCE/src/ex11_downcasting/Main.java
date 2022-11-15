package ex11_downcasting;

public class Main {

	public static void main(String[] args) {
		
		Car[] cars = new Car[10];
		
		for(int i = 0; i < cars.length; i++) {
			if(Math.random() < 0.33) {
				cars[i] = new Car();
			} else if(Math.random() < 0.66) {
				cars[i] = new Ev();
			} else {
				cars[i] = new Hybrid();
			}
		}
		/*
        Car이면 drive() 호출
        Ev이면 charge() 호출
        Hybrid이면 addOil() 호출
		*/
		for(int i = 0; i < cars.length; i++) {
			if(cars[i] instanceof Hybrid) {  // 후손부터 먼저 체크함
				((Hybrid) cars[i]).addOil();
			} else if(cars[i] instanceof Ev) {
				((Ev) cars[i]).charge();
			} else if(cars[i] instanceof Car) {
				cars[i].drive();
			} 
		}
		
	}

}
