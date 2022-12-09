package ex03_functional_interface.sec05;

public class Main {
	public static void main(String[] args) {
		Calculator cal = ( x, y) -> x + y ;
		System.out.println(cal.add(10, 20));
	}
}
