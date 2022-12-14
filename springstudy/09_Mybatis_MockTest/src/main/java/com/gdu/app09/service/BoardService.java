package com.gdu.app09.service;

import java.util.List;

import com.gdu.app09.domain.BoardDTO;

public interface BoardService {
	public List<BoardDTO> getBoardList();
	public BoardDTO getBoardByNo(int boardNo);
	public int addBoard(BoardDTO board);
	public int modifyBoard(BoardDTO board);
	public int removeBoard(int boardNo);
}
