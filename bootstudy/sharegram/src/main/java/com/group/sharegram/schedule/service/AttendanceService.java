package com.group.sharegram.schedule.service;

import org.springframework.http.ResponseEntity;

public interface AttendanceService {
	public boolean attendanceCheck(int empNo);
	public ResponseEntity<Object> addAttendance(int attendance , int empNo);
	public ResponseEntity<Object> leaveWork(int leave);
}
