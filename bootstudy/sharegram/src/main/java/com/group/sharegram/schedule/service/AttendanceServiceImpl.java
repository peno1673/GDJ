package com.group.sharegram.schedule.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.group.sharegram.schedule.domain.AttendanceDTO;
import com.group.sharegram.schedule.domain.EarlyDTO;
import com.group.sharegram.schedule.mapper.AttendanceMapper;

import ch.qos.logback.core.recovery.ResilientSyslogOutputStream;

@Service
public class AttendanceServiceImpl implements AttendanceService {

	@Autowired
	private AttendanceMapper attendanceMapper;

	@Override
	public boolean attendanceCheck(int empNo) {

		LocalDate now = LocalDate.now();
		String attStart = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"));
		AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(empNo).attStart(attStart).build();
		AttendanceDTO isCheck = attendanceMapper.selectAttendanceCheck(attendanceDTO);
		
		if (isCheck == null) {
			return false;
		} else {
			return true;
		}

	}

	@Override
	public ResponseEntity<Object> addAttendance(int attendance, int empNo) {
		int insertAttendacne = 0;
		empNo = 1;
		
		boolean isCheck = attendanceCheck(empNo);

		// isCheck가 false (비어있다==null) 출근을 한다
		if (attendance == 1 && isCheck == false ) {

			LocalDateTime now = LocalDateTime.now();
			String attStart = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분"));
			
			LocalTime status = LocalTime.now();
			LocalTime regular = LocalTime.parse("09:00:00"); //지각 체크
			
			
			String attStatus = null ;
			if(status.isBefore(regular)) {
				attStatus = "정상 출근";
				System.out.println("정상 출근");
			} else {
				attStatus = "지각";
				System.out.println("지각");
			}
			

			AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(1).attStart(attStart).attStatus(attStatus).build();
			System.out.println(attendanceDTO);

			insertAttendacne = attendanceMapper.insertAttendacne(attendanceDTO);
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("insertAttendacne", insertAttendacne);
			return new ResponseEntity<Object>(result, HttpStatus.OK);
			
		} else if( attendance == 2 && isCheck == true ){
			
			LocalDateTime now = LocalDateTime.now();
			String attEnd = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분"));
			
			LocalTime status = LocalTime.now();
			LocalTime regular = LocalTime.parse("18:00:00"); //조퇴 체크
			
			String attStatus = null ;
			if(status.isAfter(regular)) {
				attStatus = "정상 출근";
				System.out.println("정상 출근");
			} else {
				
				EarlyDTO earlyDTO = EarlyDTO.builder()
									.empNo(1)
									.earlyContent("null")
									.earlyDate(attStatus)
									.build();
						
			}
			
			AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(1).attEnd(attEnd).attStatus(attStatus).build();
//			attendanceMapper.updateLeaveWork();
			return new ResponseEntity<Object>(HttpStatus.BAD_REQUEST);
		} else {
			return new ResponseEntity<Object>(HttpStatus.BAD_REQUEST);
		}
		
	}

	@Override
	public ResponseEntity<Object> leaveWork(int leave) {
		return null;
	}
}
