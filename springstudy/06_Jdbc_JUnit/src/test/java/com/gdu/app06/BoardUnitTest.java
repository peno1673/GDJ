package com.gdu.app06;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.List;

import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.gdu.app06.domain.BoardDTO;
import com.gdu.app06.repository.BoardDAO;


/*
	@RunWith(SpringJUnit4ClassRunner.class)

	안녕. 난 테스트를 수행하는 클래스야.
	JUnit4를 이용한 테스트를 수행해.
*/

@RunWith(SpringJUnit4ClassRunner.class)


/*

	@ContextConfiguration
	
	안녕. 난 어떤 컨테이너에 bean이 저장되어 있는지 알려주는 역할이야.
	
	1. root-context.xml에 <bean> 태그를 작성한 경우
	   @ContextConfiguration(locations={"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
	
	2. com.gdu.app06.config.SpringBeanConfig.java에 @Bean을 작성한 경우
	   @ContextConfiguration(classes={SpringBeanConfig.class})
	
	3. component-scan과 컴포넌트(@Component, @Service, @Repository 등)를 이용한 경우
	   @ContextConfiguration(locations={"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
*/

@ContextConfiguration(locations={"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})


@FixMethodOrder(MethodSorters.NAME_ASCENDING)  // 메소드 이름순으로 테스트 수행
public class BoardUnitTest {
	
	@Autowired
	private BoardDAO dao;  // DAO 단위로 Unit 테스트를 진행하기 때문에 BoardDAO가 필요
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BoardUnitTest.class);
	
	@Test
	public void test1_삽입테스트() {
		BoardDTO board = new BoardDTO(0, "테스트제목", "테스트내용", "테스트작성자", null, null);
		assertEquals(1, dao.insertBoard(board));  // dao.insertBoard(board) 결과가 1이면 테스트 성공
	}
	
	@Test
	public void test2_수정테스트() {
		BoardDTO board = new BoardDTO(1, "[수정]테스트제목", "[수정]테스트내용]", null, null, null);
		assertEquals(1, dao.updateBoard(board));
	}
	
	@Test
	public void test3_조회테스트() {
		BoardDTO board = dao.selectBoardByNo(1);
		LOGGER.debug(board.toString());
		assertNotNull(board);  // dao.selectBoardByNo(1) 결과가 null이 아니면 테스트 성공
	}
	
	@Test
	public void test4_목록테스트() {
		List<BoardDTO> list = dao.selectAllBoards();
		LOGGER.debug(list.toString());
		assertEquals(1, list.size());
	}
	
	@Test
	public void test5_삭제테스트() {
		assertEquals(1, dao.deleteBoard(1));
	}

}
