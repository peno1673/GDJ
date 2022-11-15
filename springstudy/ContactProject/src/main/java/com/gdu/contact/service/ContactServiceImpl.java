package com.gdu.contact.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.gdu.contact.domain.ContactDTO;
import com.gdu.contact.repository.ContactDAO;

public class ContactServiceImpl implements ContactService {
	
	@Autowired
	private ContactDAO dao;
	
	@Override
	public List<ContactDTO> findAllContact() {
		
		return dao.selectAllContact();
		
	}

	@Override
	public ContactDTO findContactByNo(int no) {
		return dao.selectContactByNo(no);
	}

	@Override
	public int saveContact(ContactDTO contactDTO) {
		
		return dao.insertContact(contactDTO);
	}

	@Override
	public int moidfyContact(ContactDTO contactDTO) {
		return dao.updateBoard(contactDTO);
	}

	@Override
	public int removeContact(int no) {
		return dao.deleteContact(no);
	}
	
//	@Override
//	public int recentContact() {
//		return dao.recent();
//	}
}
