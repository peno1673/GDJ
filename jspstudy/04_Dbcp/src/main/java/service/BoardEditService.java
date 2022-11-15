package service;

import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import domain.Board;
import repository.BoardDao;

public class BoardEditService implements BoardService {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("board_no"));
		 int board_no = Integer.parseInt(opt.orElse("0"));
		 
		 //DB에서 board_no 해당하는 Board 가져오기
		 Board board = BoardDao.getinstance().selectBoardByNo(board_no);
		
		 //게시글 정보를 Jsp로 보내기 위해서 request에 저장
		 request.setAttribute("board", board);
		 
		 ActionForward af = new ActionForward();
		 af.setView("/board/edit.jsp");
		 af.setRedirect(false);
		 return af;
		
	}

}
