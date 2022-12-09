package ex03_functional_interface.sec01;

public class Main {
	public static void main(String[] args) {

		Myinterface1 my = () -> { System.out.println("집에 가고싶다."); };
		my.method();
		Myinterface1 you = () -> { System.out.println("너 집에 가고싶다."); };
		you.method();
	}
}
