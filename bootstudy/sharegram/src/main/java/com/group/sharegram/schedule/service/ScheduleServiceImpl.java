package com.group.sharegram.schedule.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class ScheduleServiceImpl implements ScheduleService {
	@Override
	public ResponseEntity<Object> addCalendar(HttpServletRequest request) {
		
		Map<String, Object> result = new HashMap<>();
		
		
		return null;
	}
}
