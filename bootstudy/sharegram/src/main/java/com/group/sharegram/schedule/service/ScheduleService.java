package com.group.sharegram.schedule.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;

public interface ScheduleService {
	public ResponseEntity<Object> addCalendar(HttpServletRequest request);
	
}
