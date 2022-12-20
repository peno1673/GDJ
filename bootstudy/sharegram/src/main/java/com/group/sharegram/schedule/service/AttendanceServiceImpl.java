package com.group.sharegram.schedule.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.group.sharegram.schedule.domain.AttendanceDTO;
import com.group.sharegram.schedule.domain.EarlyDTO;
import com.group.sharegram.schedule.mapper.AttendanceMapper;
import com.group.sharegram.schedule.mapper.EarlyMapper;

@Service
public class AttendanceServiceImpl implements AttendanceService {

	@Autowired
	private AttendanceMapper attendanceMapper;

	@Autowired
	private EarlyMapper earlyMapper;

	@Override
	public Map<String, String> attendanceCheck(int empNo) {

		LocalDate now = LocalDate.now();
		String attStart = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"));
		AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(empNo).attStart(attStart).build();
		AttendanceDTO result = attendanceMapper.selectAttendanceCheck(attendanceDTO);
		String opt = Optional.ofNullable(result).map(AttendanceDTO::getAttStatus).orElse("null");
		String opt2 = Optional.ofNullable(result).map(AttendanceDTO::getAttEnd).orElse("null");
		String opt3 = Optional.ofNullable(result).map(AttendanceDTO::getAttStart).orElse("null");

		System.out.println("opt : " + opt);
		System.out.println("getClass : " + opt.getClass());
		Map<String, String> map = new HashMap<>();
		map.put("attStatus", opt);
		map.put("attEnd", opt2);
		map.put("attStart", opt3);

		return map;
	}

	@Override
	public ResponseEntity<Object> addAttendance(int attendance, int empNo) {
		int insertAttendacne = 0;
		empNo = 1;
		System.out.println("attendance : " + attendance);
		Map<String, String> attCheck = attendanceCheck(empNo);
		System.out.println("-----");
		System.out.println("statusCheck : " + attCheck);
		System.out.println("AttStatus  " + attCheck.get("attStatus"));
		System.out.println("AttStart  " + attCheck.get("attStart"));
		System.out.println("AttEnd  " + attCheck.get("attEnd"));
		System.out.println("-----");
		
		// isCheck가 false (비어있다==null 출퇴근 기록이없다) 출근을 한다
		if (attendance == 1 && attCheck.get("attStatus").contains("null")) {

			LocalDateTime now = LocalDateTime.now();
			String attStart = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분"));

			LocalTime status = LocalTime.now();
			LocalTime regular = LocalTime.parse("09:00:00"); // 지각 체크

			String attStatus = null;
			if (status.isBefore(regular)) {
				attStatus = "정상 출근";
				System.out.println("정상 출근");
			} else {
				attStatus = "지각";
				System.out.println("지각");
			}

			AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(1).attStart(attStart).attStatus(attStatus)
					.build();
			System.out.println(attendanceDTO);

			insertAttendacne = attendanceMapper.insertAttendacne(attendanceDTO);
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("insertAttendacne", insertAttendacne);
			return new ResponseEntity<Object>(result, HttpStatus.OK);

			//출근하고 퇴근체크
		} else if (attendance == 2 
				&& attCheck.get("attEnd").contains("null") && (attCheck.get("attStatus").contains("정상 출근")
						|| attCheck.get("attStatus").contains("지각")) ) {
			System.err.println("퇴근 왜돼?");
			LocalDateTime now = LocalDateTime.now();
			String attEnd = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분"));

			LocalTime status = LocalTime.now();
			LocalTime regular = LocalTime.parse("18:00:00"); // 퇴근 체크

			String attStatus = null;
			if (status.isAfter(regular)) {
				attStatus = "정상 출근";
				System.out.println("정상 출근");
			} else { // 조퇴
				attStatus = "조퇴";
				System.out.println("조퇴");
				EarlyDTO earlyDTO = EarlyDTO.builder().empNo(1) // 수정 필수
						.earlyContent("내용없음").earlyDate(attEnd).build();
				earlyMapper.insertEarly(earlyDTO);
			}

			AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(1).attEnd(attEnd).attStatus(attStatus).build();

			int updateLeaveWork = attendanceMapper.updateLeaveWork(attendanceDTO);
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("updateLeaveWork", updateLeaveWork);

			return new ResponseEntity<Object>(result, HttpStatus.OK);

			
			//출근 누르기전에 퇴근 누를경우
		} else if (attendance == 2 && attCheck.get("attStatus").contains("null")) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("notAttendance", 0);
			return new ResponseEntity<Object>(result, HttpStatus.OK);
			
			//출근 누르고 출근 눌렀을경우
		} else if (attendance == 1 && attCheck.get("attStart") != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("alreadyAttendace", 0);
			return new ResponseEntity<Object>(result, HttpStatus.OK);
			
			//퇴근누르고 퇴근 누를경우
		} else if (attendance == 2 && attCheck.get("attEnd") != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("alreadyLeaveWork", 0);
			return new ResponseEntity<Object>(result, HttpStatus.OK);
			
			
		} else {
			return new ResponseEntity<Object>(HttpStatus.BAD_REQUEST);
		}

	}
	
	@Override
	public ResponseEntity<Object> getAttendanceList() {
		Map<String , Object > map = new HashMap<>();
		map.put("list", attendanceMapper.test());
		return new ResponseEntity<Object>(map, HttpStatus.OK);
	}
	
	
}
