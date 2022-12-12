package com.group.sharegram.schedule.controller;

import java.io.IOException;
import java.security.GeneralSecurityException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.group.sharegram.schedule.service.GoogleCalendarService;
import com.group.sharegram.schedule.service.ScheduleService;

@Controller
public class ScheduleController {

	@Autowired
	private ScheduleService scheduleService;

	@Autowired
	private GoogleCalendarService calendarService;
	
//	@PostMapping(value = "/Schedule", produces = "application/json")
//	public ResponseEntity<Object> Calander(){
//		return  scheduleService.Calander();
//	}

	@GetMapping(value = "/schedule/list", produces = "application/json")
	public String Calander() throws GeneralSecurityException, IOException {
		calendarService.getCalendar();
		calendarService.getCalendarList();
		
		return "schedule/calander";
	}
}
