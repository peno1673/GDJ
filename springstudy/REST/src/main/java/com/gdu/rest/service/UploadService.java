package com.gdu.rest.service;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface UploadService {
	public Map<String, Object> save(MultipartHttpServletRequest multipartRequest);
	public ResponseEntity<byte[]> display(String path, String thumbnail);
}
