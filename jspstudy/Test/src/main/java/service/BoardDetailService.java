package service;

import java.io.PrintWriter;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.ActionForward;
import domain.Board;
import repository.BoardDao;

public class BoardDetailService implements BoardService {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("boardNo"));
		int boardNo = Integer.parseInt(opt.orElse("0"));
		
		Board board = BoardDao.getInstance().selectBoardByNo(boardNo);
		
		if(board == null) {
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + boardNo + "번 게시글의 정보가 없습니다.')");
			out.println("location.href='" + request.getContextPath() + "/final1/selectBoardlist.do'");
			out.println("</script>");
			out.close();
		} else {
			
			request.setAttribute("board", board);
			// detail.jsp로 포워딩
			ActionForward af = new ActionForward();
			af.setView("/final1/selectBoardDetail.jsp");
			af.setRedirect(false);
			return af;
		}
		
		return null;  
		
	}

}
