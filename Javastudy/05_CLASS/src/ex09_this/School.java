package ex09_this;

public class School {

	// 필드
	private Student[] students;
	private int idx;  // students 배열의 인덱스. students 배열에 저장된 학생수와 같다.
	
	// 생성자
	public School(int cnt) {
		students = new Student[cnt];
	}
	
	// 메소드
	public void addStudent(Student student) {
		if(idx == students.length) {
			System.out.println("Full");
			return;
		}
		students[idx++] = student;
	}
	
	public void printStudents() {
		
		/*
		for(int i = 0; i < idx; i++) {
			System.out.println(students[i].getName() + ", " + students[i].getStuNo());
		}
		*/
		
		for(Student student : students) {
			if(student != null) {
				System.out.println(student.getName() + ", " + student.getStuNo());
			}
		}
		
	}
	
}
