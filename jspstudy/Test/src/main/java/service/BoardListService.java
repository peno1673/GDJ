package service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import repository.BoardDao;

public class BoardListService implements BoardService {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		
		request.setAttribute("boards", BoardDao.getInstance().selectAllBoards());
		
		ActionForward af =new ActionForward();
		af.setView("/final1/selectBoardlist.jsp");
		af.setRedirect(false);
		return af;
	}

}
