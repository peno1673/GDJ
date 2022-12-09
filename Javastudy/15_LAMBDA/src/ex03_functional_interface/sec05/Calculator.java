package ex03_functional_interface.sec05;


@FunctionalInterface // 추상메소드 1개가지고 있음(람다식으로 생성할 수있는 인터페이서)
public interface Calculator {
	public int add(int a, int b);
}
