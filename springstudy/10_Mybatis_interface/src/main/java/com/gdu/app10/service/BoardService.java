package com.gdu.app10.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gdu.app10.domain.BoardDTO;

public interface BoardService {
	public List<BoardDTO> getBoardList();
	public BoardDTO getBoardByNo(int boardNo);
	public void addBoard(HttpServletRequest request, HttpServletResponse response);
	public void modifyBoard(HttpServletRequest request, HttpServletResponse response);
	public void removeBoard(HttpServletRequest request, HttpServletResponse response);
	public void removeBoardList(HttpServletRequest request, HttpServletResponse response);
}
