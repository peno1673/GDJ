package ex03_functional_interface.sec04;

public class Main {
	public static void main(String[] args) {
		Myinterface3 my = () -> 10;
		
		System.out.println(my.method());
		
		Myinterface3 you = () -> 20;
		System.out.println(you.method());
	}
}
