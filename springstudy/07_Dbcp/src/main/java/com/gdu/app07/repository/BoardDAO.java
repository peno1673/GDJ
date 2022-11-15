package com.gdu.app07.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.springframework.stereotype.Repository;

import com.gdu.app07.domain.BoardDTO;

/*
 * @Repository
 * @Component야
 * 
 * 
 * 
 * 
 * */
//@Repository // 트랜잭션 기능이 추가되어 있어
public class BoardDAO {

	private Connection con;
	private PreparedStatement ps;
	private ResultSet rs;
	private String sql;

		//Connection Pool을 관리하는 DataSource
	private DataSource dataSource;
	
	//BoardDAO가 생성되면
	//contxt.xml의 Resource를 읽어서 dataSOurce 객체를 만든다
	public BoardDAO() {
		//JNDI : Resource의 name을 이용해 읽어들이느 방식
		try {
			Context context = new InitialContext();
			dataSource = (DataSource)context.lookup("java:comp/env/jdbc/oracle11g");

		} catch (Exception e) {  //NamingException
			e.printStackTrace();
		}
	}
	
	
//	private Connection getConnection() {
//		Connection con = null;
//		try {
//			Class.forName("oracle.jdbc.OracleDriver");
//			con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "SCOTT", "TIGER");
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return con;
//	}

	private void close() {
		try {
			if (rs != null) {
				rs.close();
			}
			if (ps != null) {
				ps.close();
			}
			if (con != null) {
				con.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<BoardDTO> selectAllBoards() {
		List<BoardDTO> boards = new ArrayList<>();
		try {
			con = dataSource.getConnection();
			sql = "SELECT BOARD_NO, TITLE, CONTENT, WRITER, CREATE_DATE, MODIFY_DATE FROM BOARD ORDER BY BOARD_NO DESC";
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				BoardDTO board = new BoardDTO(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getString(6));
				boards.add(board);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return boards;
	}

	public BoardDTO selectBoardByNo(int board_no) {
		BoardDTO board = null;
		try {
			con = dataSource.getConnection();
			sql = "SELECT BOARD_NO, TITLE, CONTENT, WRITER, CREATE_DATE, MODIFY_DATE FROM BOARD WHERE BOARD_NO = ?";
			ps = con.prepareStatement(sql);
			ps.setInt(1, board_no);
			rs = ps.executeQuery();
			if (rs.next()) {
				board = new BoardDTO(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5),
						rs.getString(6));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return board;
	}

	public int insertBoard(BoardDTO board) {
		int result = 0;
		try {
			con = dataSource.getConnection();
			sql = "INSERT INTO BOARD(BOARD_NO, TITLE, CONTENT, WRITER, CREATE_DATE, MODIFY_DATE) VALUES(BOARD_SEQ.NEXTVAL, ? , ? , ? , "
					+ "TO_CHAR(SYSDATE, 'YYYY-MM-DD'),TO_CHAR(SYSDATE, 'YYYY-MM-DD'))";
			ps = con.prepareStatement(sql);
			ps.setString(1, board.getTitle());
			ps.setString(2, board.getContent());
			ps.setString(3, board.getWriter());
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}

		return result;
	}

	public int updateBoard(BoardDTO board) {
		int result = 0;
		try {
			con = dataSource.getConnection();
			sql = "UPDATE BOARD "
				+ "SET TITLE = ?, CONTENT = ?, MODIFY_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD') "
				+ "WHERE BOARD_NO = ?";
			ps = con.prepareStatement(sql);
			ps.setString(1, board.getTitle());
			ps.setString(2, board.getContent());
			ps.setInt(3, board.getBoard_no());
			result = ps.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	public int deleteBoard(int board_no) {
		int result = 0;
		try {
			con = dataSource.getConnection();
			sql = "DELETE FROM BOARD WHERE BOARD_NO = ?";
			ps = con.prepareStatement(sql);
			ps.setInt(1, board_no);
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

}
