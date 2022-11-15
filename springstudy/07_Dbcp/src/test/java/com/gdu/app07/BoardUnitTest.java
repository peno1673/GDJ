package com.gdu.app07;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.gdu.app07.config.BoardAppContext;
import com.gdu.app07.domain.BoardDTO;
import com.gdu.app07.repository.BoardDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {BoardAppContext.class})
public class BoardUnitTest {
	@Autowired
	private BoardDAO dao;
	
	@Test
	public void 삽입테스트() {
		BoardDTO board = new BoardDTO(0, "테스트계획", "내용", "작성자" ,null,null);
		assertEquals(1, dao.insertBoard(board));
	}
	
}
