package ex08_access_modifier;

public class UserMain {

	public static void main(String[] args) {
		
		User user = new User();
		
		user.setId("admin");
		System.out.println(user.getId());
		
		user.setPassword("123456");
		System.out.println(user.getPassword());
		
		user.setEmail("admin@web.com");
		System.out.println(user.getEmail());
		
		user.setPoint(10000);
		System.out.println(user.getPoint());
		
		System.out.println(user.getVip());
		
	}

}
