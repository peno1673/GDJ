package Test;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Optional;

import org.junit.Test;

import domain.Board;
import repository.BoardDao;

public class BoardTest {

	/*
	 * @Test public void 목록테스트() {
	 * 
	 * List<Board> boards = BoardDao.getInstance().selectAllBoards();
	 * assertEquals(1, boards.size()); }
	 * 
	 * @Test public void 상세조회테스트() { Board board =
	 * BoardDao.getInstance().selectBoardByNo(4); assertEquals("공지 4",
	 * board.getTitle());
	 * 
	 * }
	 * 
	 * @Test public void as() { Board board =
	 * BoardDao.getInstance().selectBoardByNo(2); assertNotNull(board); }
	 */
	@Test
	public void 게시글삽입테스트() {
		Board board = new Board();
		board.setTitle("테스트");
		board.setContent("내용");
		int result = BoardDao.getInstance().insertBoard(board);
		assertEquals(1, result);
	}
	@Test
	public void 게시글수정테스트() {
		Board board = new Board();
		board.setTitle("테스트");
		board.setContent("내용");
		board.setBoardNo(11);
		int result = BoardDao.getInstance().updateBoard(board);
		assertEquals(1, result);
	}
	@Test
	public void 게시글삭제테스트() {
		int result = BoardDao.getInstance().deleteBoard(20);
		assertEquals(1, result);
	}
	
	
	
	
}
