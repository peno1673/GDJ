package com.gdu.rest.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.rest.service.UploadService;

@RestController
public class UploadController {

	@Autowired
	private UploadService uploadService;
	
	@PostMapping(value="/uploads", produces="application/json")
	public Map<String, Object> save(MultipartHttpServletRequest multipartRequest){
		return uploadService.save(multipartRequest);
	}
	
	@GetMapping("/uploads/display")
	public ResponseEntity<byte[]> display(@RequestParam String path, @RequestParam String thumbnail){
		return uploadService.display(path, thumbnail);
	}
	
}
