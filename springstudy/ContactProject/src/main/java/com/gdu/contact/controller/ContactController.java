package com.gdu.contact.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gdu.contact.domain.ContactDTO;
import com.gdu.contact.service.ContactService;

@Controller
public class ContactController {
	
	@Autowired
	private ContactService contactService;
	
	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	@GetMapping("ctt/list")
	public String list(Model model) {
		model.addAttribute("contacts", contactService.findAllContact());
		return "contact/list";
	}
	
	@GetMapping("ctt/write")
	public String write() {
		return "contact/insert";
	}
	
	@PostMapping("ctt/add")
	public String add(ContactDTO contactDTO
			 , RedirectAttributes redirectAttributes) {
		contactService.saveContact(contactDTO);
		
//		System.out.println(contactService.recentContact());
		System.out.println();
		return "redirect:/ctt/list";
	}
	
	@GetMapping("ctt/detail")
	public String detail(@RequestParam(value = "no" , required=false, defaultValue = "0")int no
						, Model model) {
		model.addAttribute("contact",contactService.findContactByNo(no) );
		return "contact/detail";
	}
	
	@PostMapping("ctt/edit")
	public String modify(ContactDTO contactDTO) {
		contactService.moidfyContact(contactDTO);
		return "redirect:/ctt/list";
	}
	
	@PostMapping("ctt/remove")
	public String remove(@RequestParam(value = "no" , required=false, defaultValue = "0") int no) {
		contactService.removeContact(no);
		return "redirect:/ctt/list";
	}
	
	
}
