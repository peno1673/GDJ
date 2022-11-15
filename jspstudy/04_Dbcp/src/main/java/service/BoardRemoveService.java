package service;

import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import repository.BoardDao;

public class BoardRemoveService implements BoardService  {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("board_no"));
		int board_no = Integer.parseInt(opt.orElse("0"));
		
		int result = BoardDao.getinstance().deleteBoard(board_no);
		
		System.out.println("삭제 여부 "  + result);
		
		ActionForward af = new ActionForward();
		af.setView(request.getContextPath() + "/board/list.do");
		af.setRedirect(true);
		return af;
	}
	
	
}
