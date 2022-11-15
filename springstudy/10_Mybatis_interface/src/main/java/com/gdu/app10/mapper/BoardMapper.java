package com.gdu.app10.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.app10.domain.BoardDTO;

/*
 * 
 * 
 * 
 * */
@Mapper
public interface BoardMapper {
	public List<BoardDTO> selectAllBoards();

	public BoardDTO selectBoardByNo(int boardNo);

	public int insertBoard(BoardDTO boardDTO);

	public int updateBoard(BoardDTO boardDTO);

	public int deleteBoard(int boardNo);

}
