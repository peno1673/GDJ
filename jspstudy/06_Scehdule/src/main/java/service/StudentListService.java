package service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import repository.StudentDao;

public class StudentListService implements StudentService {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
	StudentDao dao = StudentDao.getInstance();
	request.setAttribute("students", dao.selectAllStudents());
	request.setAttribute("count", dao.selectAllStudentsCount());
	request.setAttribute("average", dao.selectAllStudentsAverage());
	
	return new ActionForward("/student/list.jsp", false);
	
	}

}
