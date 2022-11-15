package service;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import domain.Board;
import repository.BoardDao;

public class BoardInsertService implements BoardService {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception  {
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String writer = request.getParameter("writer");

		Board board = Board.builder().title(title).content(content).writer(writer).build();

		int result = BoardDao.getInstance().insertBoard(board);
		
		PrintWriter out = response.getWriter();
		if(result > 0) {
			out.println("<script>");
			out.println("alert('삽입 성공.')");
			out.println("location.href='" + request.getContextPath() + "/final1/insertPage.do'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('삽입 실패.')");
			out.println("history.back()");  // history.go(-1)
			out.println("</script>");
		}
		out.close();	
		
		return null;
	}
}
