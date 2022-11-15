package service;

import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import domain.Board;
import repository.BoardDao;

public class BoardDetailService implements BoardService {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 요청 파라미터
		String str = request.getParameter("board_no");
		Optional<String> opt = Optional.ofNullable(str); // null일수있다
		int board_no = Integer.parseInt(opt.orElse("0")); // null이면 0

		// DB에서 게시글 정보 가져오기
		Board board = BoardDao.getinstance().selectBoardByNo(board_no);

		// 게시글 정보를 Jsp로 보내기 위해서 request에 저장
		request.setAttribute("board", board);

		// 어디로
		ActionForward af = new ActionForward();
		af.setView("/board/detail.jsp");
		af.setRedirect(false);
		return af;

	}

}
