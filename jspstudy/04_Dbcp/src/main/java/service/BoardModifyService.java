package service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import domain.Board;
import repository.BoardDao;

public class BoardModifyService implements BoardService {

	//요청 파라미터
	// <input type="text"> <textarea> 태그 요소는 입력 값이 없을때 문자열("")f로 전달
	// optional
	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		int board_no = Integer.parseInt(request.getParameter("board_no"));
		
		Board board = new Board();
		board.setTitle(title);
		board.setContent(content);
		board.setBoard_no(board_no);
		
		int result = BoardDao.getinstance().updateBoard(board);
		
		//수정 결과는 콘솔에서 확은
		System.out.println("수정 결과 : " + result);
		
		ActionForward af = new ActionForward();
		af.setView(request.getContextPath() + "/board/detail.do?board_no=" + board_no);
		af.setRedirect(true);
		return af;

	}
	
	
}
