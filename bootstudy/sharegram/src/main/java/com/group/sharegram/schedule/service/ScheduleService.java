package com.group.sharegram.schedule.service;

import org.springframework.http.ResponseEntity;

import com.group.sharegram.schedule.domain.ScheduleDTO;

public interface ScheduleService {
	public ResponseEntity<Object> addSchedule(ScheduleDTO  schedule);
	
}
