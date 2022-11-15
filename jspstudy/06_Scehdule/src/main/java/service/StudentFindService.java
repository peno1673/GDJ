package service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import repository.StudentDao;

public class StudentFindService implements StudentService {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
	double begin = Double.parseDouble(request.getParameter("begin"));
	double end = Double.parseDouble(request.getParameter("end"));
	
	Map<String,Double> map = new HashMap<String, Double>();
	map.put("begin", begin);
	map.put("end", end);
	
	StudentDao dao = StudentDao.getInstance();
	request.setAttribute("students", dao.selectStudentsByAve(map));
	request.setAttribute("count", dao.selectStudentsByAveCount(map));
	request.setAttribute("average", dao.selectStudentsByAverage(map));
	
	return new ActionForward("/student/list.jsp", false);
	
	}

}
