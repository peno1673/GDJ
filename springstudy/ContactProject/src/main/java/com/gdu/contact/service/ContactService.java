package com.gdu.contact.service;

import java.util.List;

import com.gdu.contact.domain.ContactDTO;

public interface ContactService {
	
	public List<ContactDTO> findAllContact();
	public ContactDTO findContactByNo(int no);
	public int saveContact(ContactDTO contactDTO);
	public int moidfyContact(ContactDTO contactDTO);
	public int removeContact(int no);
//	public int recentContact();
}
