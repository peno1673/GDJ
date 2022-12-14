package com.gdu.rest.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MyController {

	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	@GetMapping("/member/handle")
	public String memberHandle() {
		return "member/handle";
	}
	
	@GetMapping("/upload/handle")
	public String uploadHandle() {
		return "upload/handle";
	}
	
}
