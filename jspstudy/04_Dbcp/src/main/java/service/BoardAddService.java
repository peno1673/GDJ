package service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import domain.Board;
import repository.BoardDao;

public class BoardAddService implements BoardService {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String title = request.getParameter("title");
		String content = request.getParameter("content");

		Board board = new Board();
		board.setTitle(title);
		board.setContent(content);

		int result = BoardDao.getinstance().insertBoard(board);

		System.out.println("삽입 결과 : " + result);

		ActionForward af = new ActionForward();
		af.setView(request.getContextPath() + "/board/list.do");
		af.setRedirect(true);
		return af;

	}

}
