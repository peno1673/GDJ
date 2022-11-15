package com.gud.app02;

import static org.junit.Assert.*;

import org.springframework.web.bind.annotation.RequestMapping;

public class Test {

	@org.junit.Test
	public void test() {
		fail("Not yet implemented");
	}
	
	@org.junit.Test
	@RequestMapping("flower")
	public String flower() {
		// return "/gallery/flower"
		return "gallery/flower";
	}

}
