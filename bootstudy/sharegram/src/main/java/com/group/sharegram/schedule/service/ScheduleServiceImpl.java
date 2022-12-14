package com.group.sharegram.schedule.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.group.sharegram.schedule.domain.ScheduleDTO;
import com.group.sharegram.schedule.mapper.ScheduleMapper;

@Service
public class ScheduleServiceImpl implements ScheduleService {
	
	@Autowired
	ScheduleMapper scheduleMapper;
	
	@Override
	public ResponseEntity<Object> addSchedule(ScheduleDTO schedule) {
		
		schedule.setEmpNo(7);
		Map<String, Object> result = new HashMap<String, Object>();
		int ScheduleResult = scheduleMapper.insertSchedule(schedule);
		result.put("insertResult" , ScheduleResult );
		
		if(ScheduleResult > 0) {
			HttpHeaders headers = new HttpHeaders();
//			headers.add("Content-Type", MediaType.APPLICATION_JSON_VALUE);
			System.out.println(result);
			new ResponseEntity<Object>(result,  HttpStatus.OK);
		} else {
			new ResponseEntity<Object>( HttpStatus.INTERNAL_SERVER_ERROR);  
		}
		return null;
	}
}
