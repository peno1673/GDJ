package com.gdu.app06.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gdu.app06.domain.BoardDTO;
import com.gdu.app06.repository.BoardDAO;


/*
	@Service
	안녕. 난 Service에 추가하는 @Component야.
	@Component를 포함하고 있어서 자동으로 컨테이너에 저장되지.
*/

@Service  // Service에서 사용하는 @Component

public class BoardServiceImpl implements BoardService {

	
	@Autowired  // 컨테이너에 생성된 Bean중에서 BoardDAO 타입의 Bean을 가져오시오.
	            // BoardDAO에는 @Repository라는 @Component를 등록해 놓았기 때문에 @Autowired 할 수 있어.
	private BoardDAO dao;
	
	
	@Override
	public List<BoardDTO> findAllBoards() {
		return dao.selectAllBoards();
	}

	@Override
	public BoardDTO findBoardByNo(int board_no) {
		return dao.selectBoardByNo(board_no);
	}

	@Override
	public int saveBoard(BoardDTO board) {
		return dao.insertBoard(board);
	}

	@Override
	public int modifyBoard(BoardDTO board) {
		return dao.updateBoard(board);
	}

	@Override
	public int removeBoard(int board_no) {
		return dao.deleteBoard(board_no);
	}

}
