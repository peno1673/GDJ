package com.gdu.app16.controller;

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
}
