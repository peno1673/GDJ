package com.gdu.app07.service;

import java.util.List;

import com.gdu.app07.domain.BoardDTO;
import com.gdu.app07.repository.BoardDAO;

import lombok.AllArgsConstructor;

@AllArgsConstructor
//@Service
public class BoardServiceImpl implements BoardService {
	
	
//	@Autowired
	
	private BoardDAO dao ;
	
	
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
