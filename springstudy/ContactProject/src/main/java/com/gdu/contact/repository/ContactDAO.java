package com.gdu.contact.repository;

import java.beans.JavaBean;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.gdu.contact.domain.ContactDTO;

@JavaBean
public class ContactDAO {

	private Connection con;
	private PreparedStatement ps;
	private ResultSet rs;
	private String sql;

	private Connection getConnection() {
		Connection con = null;
		try {
			Class.forName("oracle.jdbc.OracleDriver");
			con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "SCOTT", "TIGER");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return con;
	}

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

	public List<ContactDTO> selectAllContact() {
		List<ContactDTO> contacts = new ArrayList<ContactDTO>();
		try {
			con = getConnection();
			sql = "SELECT NO, NAME, TEL, ADDR, EMAIL, NOTE FROM CONTACT";
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				ContactDTO contact = ContactDTO.builder().no(rs.getInt(1)).name(rs.getString(2)).tel(rs.getString(3))
						.addr(rs.getString(4)).email(rs.getString(5)).note(rs.getString(6)).build();
				contacts.add(contact);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return contacts;
	}

	public int insertContact(ContactDTO contactDTO) {
		int result = 0;
		try {
			con = getConnection();
			sql = "INSERT INTO CONTACT (NO , NAME, TEL, ADDR, EMAIL, NOTE) VALUES( CONTACT_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
			ps = con.prepareStatement(sql);
			ps.setString(1, contactDTO.getName());
			ps.setString(2, contactDTO.getTel());
			ps.setString(3, contactDTO.getAddr());
			ps.setString(4, contactDTO.getEmail());
			ps.setString(5, contactDTO.getNote());
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}

	public ContactDTO selectContactByNo(int no) {
		ContactDTO contact =null;
		try {
			con = getConnection();
			sql = "SELECT NO, NAME, TEL, ADDR, EMAIL, NOTE FROM CONTACT WHERE NO = ?";
			ps = con.prepareStatement(sql);
			ps.setInt(1, no);
			rs = ps.executeQuery();
			while (rs.next()) {
				contact = ContactDTO.builder().no(rs.getInt(1)).name(rs.getString(2)).tel(rs.getString(3))
						.addr(rs.getString(4)).email(rs.getString(5)).note(rs.getString(6)).build();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return contact;
	}
	
	public int updateBoard(ContactDTO contactDTO) {
		int result = 0;
		try {
			con = getConnection();
			sql = "UPDATE CONTACT SET NAME = ?, TEL = ?, ADDR = ?, EMAIL = ?,  NOTE = ? WHERE NO = ?";
			ps = con.prepareStatement(sql);
			ps.setString(1, contactDTO.getName());
			ps.setString(2, contactDTO.getTel());
			ps.setString(3, contactDTO.getAddr());
			ps.setString(4, contactDTO.getEmail());
			ps.setString(5, contactDTO.getNote());
			ps.setInt(6, contactDTO.getNo());
			result = ps.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
	
	public int deleteContact(int no) {
		int result = 0;
		try {
			con = getConnection();
			sql = "DELETE FROM CONTACT WHERE NO = ?";
			ps = con.prepareStatement(sql);
			ps.setInt(1, no);
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
	
//	public int recent() {
//		int result = 0;
//		try {
//			con = getConnection();
//			sql = "SELETE MAX(NO) FROM CONTACT";
//			ps = con.prepareStatement(sql);
//			result= ps.executeUpdate();
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			close();
//		}
//		return result;
//	}

}
