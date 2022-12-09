package ex03_functional_interface.sec03;

public class Main {
	public static void main(String[] args) {
		Myinterface2 my = (x)-> System.out.println(x);
		
		my.method(10);
	}
}
