package Test;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import domain.Board;
import repository.BoardDao;

public class BoardTest {

	@Test
	public void 목록테스트() {
		
		List<Board> boards = BoardDao.getinstance().selectAllBoards();
		assertEquals(5, boards.size());
	}

}
