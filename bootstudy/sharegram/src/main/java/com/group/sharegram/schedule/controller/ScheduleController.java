package com.group.sharegram.schedule.controller;

import java.io.IOException;
import java.security.GeneralSecurityException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.group.sharegram.schedule.domain.ScheduleDTO;
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
//
	@GetMapping(value = "/schedule/list", produces = "application/json")
	public String Calander() throws GeneralSecurityException, IOException {
		calendarService.getCalendar();
		calendarService.getCalendarList();
		return "schedule/calander";
	}
	
	@ResponseBody
	@PostMapping(value="/schedule/write", produces = "application/json; charset=UTF-8")
	public ResponseEntity<Object> addSchedule(@RequestBody ScheduleDTO schedule) {
		System.out.println("");
		return scheduleService.addSchedule(schedule);
	}
	
	@GetMapping(value = "/schedule" , produces = "application/json")
	public String writeCalendar(HttpServletRequest request, Model model) {
		String start =  request.getParameter("start");
		String end = request.getParameter("end");
		
		model.addAttribute("start" , start);
		model.addAttribute("end" , end);
	return "schedule/calendarWrite";
	}
}
