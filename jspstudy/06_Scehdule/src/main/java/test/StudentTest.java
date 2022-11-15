package test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.jupiter.api.Assertions.fail;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.junit.jupiter.api.Test;

import common.ActionForward;
import domain.Student;
import lombok.Builder;
import repository.StudentDao;

@Builder
class StudentTest {

	
//	@Test
//	public void 삽입() {
//		String name = "테스터";
//		int kor = 50;
//		int eng = 50;
//		int math = 50;
//		
//		double ave = (kor + eng + math) / 3.0;
//		String grade;
//		
//		switch((int)(ave / 10)) {
//		case 10: case 9: grade = "A"; break;
//		case 8: grade = "B"; break;
//		case 7: grade = "C"; break;
//		case 6: grade = "D"; break;
//		default: grade = "F";
//		}
//		// DB로 보낼 Student student 생성
//		Student student = Student.builder()
//				.name(name)
//				.kor(kor)
//				.eng(eng)
//				.math(math)
//				.ave(ave)
//				.grade(grade)
//				.build();
//		
//		int result = StudentDao.getInstance().insertStudent(student);
//		assertEquals(1, result);
//	}
//	@Test
//	public void 목록() {
//		assertEquals(6, StudentDao.getInstance().selectAllStudents().size());
//	}
//	@Test
//	public void 상세() {
//		assertNotNull( StudentDao.getInstance().selectStudentByNo(7));
//	}
//	@Test
//	public void 수정() {
//		Student student = Student.builder()
//				.name("테스터")
//				.kor(60)
//				.eng(60)
//				.math(60)
//				.stuNo(7)
//				.build();
//		assertEquals(1, StudentDao.getInstance().updateStudent(student));
//	}
//	@Test
//	public void 수정() {
//		Student student = Student.builder()
//				.name("테스터")
//				.kor(60)
//				.eng(60)
//				.math(60)
//				.stuNo(7)
//				.build();
//		assertEquals(1, StudentDao.getInstance().updateStudent(student));
//	}
	
	
	
	

}
