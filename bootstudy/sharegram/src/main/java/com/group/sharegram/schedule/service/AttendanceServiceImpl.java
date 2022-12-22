package com.group.sharegram.schedule.service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.group.sharegram.schedule.domain.AttendanceDTO;
import com.group.sharegram.schedule.domain.EarlyDTO;
import com.group.sharegram.schedule.mapper.AttendanceMapper;
import com.group.sharegram.schedule.mapper.EarlyMapper;
import com.group.sharegram.util.PageUtil;

@Service
public class AttendanceServiceImpl implements AttendanceService {

	@Autowired
	private AttendanceMapper attendanceMapper;
	@Autowired
	private EarlyMapper earlyMapper;
	@Autowired
	private PageUtil pageUtil;

	@Override
	public Map<String, String> attendanceCheck(int empNo) {

		LocalDate now = LocalDate.now();
		String attStart = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"));
		AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(empNo).attStart(attStart).build();

		AttendanceDTO result = attendanceMapper.selectAttendanceCheck(attendanceDTO);

		String opt = Optional.ofNullable(result).map(AttendanceDTO::getAttStatus).orElse("null");
		String opt2 = Optional.ofNullable(result).map(AttendanceDTO::getAttEnd).orElse("null");
		String opt3 = Optional.ofNullable(result).map(AttendanceDTO::getAttStart).orElse("null");

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
		Map<String, String> attCheck = attendanceCheck(empNo);

		// isCheck가 false (비어있다==null 출퇴근 기록이없다) 출근을 한다
		if (attendance == 1 && attCheck.get("attStatus").contains("null")) {

			LocalDateTime now = LocalDateTime.now();
			String attStart = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분"));

			LocalTime status = LocalTime.now();
			LocalTime regular = LocalTime.parse("09:00:00"); // 지각 체크

			String attStatus = null;
			if (status.isBefore(regular)) {
				attStatus = "정상 출근";
			} else {
				attStatus = "지각";
			}

			AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(1).attStart(attStart).attStatus(attStatus)
					.build();

			insertAttendacne = attendanceMapper.insertAttendacne(attendanceDTO);
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("insertAttendacne", insertAttendacne);
			return new ResponseEntity<Object>(result, HttpStatus.OK);

			// 출근하고 퇴근체크
		} else if (attendance == 2 && attCheck.get("attEnd").contains("null")
				&& (attCheck.get("attStatus").contains("정상 출근") || attCheck.get("attStatus").contains("지각"))) {
			LocalDateTime now = LocalDateTime.now();
			String attEnd = now.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분"));

			LocalTime status = LocalTime.now();
			LocalTime regular = LocalTime.parse("17:50:00"); // 퇴근 체크

			String attStatus = null;
			if (status.isAfter(regular)) {
				attStatus = "정상 출근";
			} else { // 조퇴
				attStatus = "조퇴";
				EarlyDTO earlyDTO = EarlyDTO.builder().empNo(1) // 수정 필수
						.earlyContent("내용없음").earlyDate(attEnd).build();
				earlyMapper.insertEarly(earlyDTO);
			}
			
			System.out.println("조퇴 상대 체크 해야함" + attStatus);
			AttendanceDTO attendanceDTO = AttendanceDTO.builder().empNo(1).attStart(attCheck.get("attStart"))
					.attEnd(attEnd).attStatus(attStatus).build();

			int updateLeaveWork = attendanceMapper.updateLeaveWork(attendanceDTO);
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("updateLeaveWork", updateLeaveWork);

			return new ResponseEntity<Object>(result, HttpStatus.OK);

			// 출근 누르기전에 퇴근 누를경우
		} else if (attendance == 2 && attCheck.get("attStatus").contains("null")) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("notAttendance", 0);
			return new ResponseEntity<Object>(result, HttpStatus.OK);

			// 출근 누르고 출근 눌렀을경우
		} else if (attendance == 1 && attCheck.get("attStart") != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("alreadyAttendace", 0);
			return new ResponseEntity<Object>(result, HttpStatus.OK);

			// 퇴근누르고 퇴근 누를경우
		} else if (attendance == 2 && attCheck.get("attEnd") != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("alreadyLeaveWork", 0);
			return new ResponseEntity<Object>(result, HttpStatus.OK);

		} else {
			return new ResponseEntity<Object>(HttpStatus.BAD_REQUEST);
		}

	}

	@Override
	public ResponseEntity<Object> getAttendanceList(int page) {

		int totalRecord = attendanceMapper.selectAttendaceCount();
		pageUtil.setPageUtil(page, totalRecord);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begin", pageUtil.getBegin());
		map.put("end", 10);

		List<AttendanceDTO> attendances = attendanceMapper.selectAttendanceListByMap(map);

		List<LocalDateTime> startTime =	attendances.stream().filter( a -> a.getAttEnd() != null ).map(AttendanceDTO::getAttStart)
			.map(AttStart -> LocalDateTime.parse( AttStart, DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분"))).collect(Collectors.toList());
		List<LocalDateTime> endTime =	attendances.stream().map(AttendanceDTO::getAttEnd).filter(Objects::nonNull)
			.map(AttEnd -> LocalDateTime.parse( AttEnd, DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분"))).collect(Collectors.toList());
		
		
		List<String> working = new ArrayList<>();
		List<String> overWorking = new ArrayList<>();
		
		
		
		if(attendances.size() != startTime.size() ) {
			working.add("퇴근 후 정산");
			overWorking.add("퇴근 후 정산");
		}
							
		for(int i = 0; i < endTime.size() ; i++) {
				Duration workTime = Duration.between(startTime.get(i), endTime.get(i));
				long totalMinute = workTime.toMinutes()-60; //480분
				long hour = totalMinute / 60;
				long minute = totalMinute % 60; // 60분 못 넘김
				System.out.println(totalMinute);
				working.add(Long.toString(hour) + "시 " + Long.toString(minute)  + "분");
				
				if( totalMinute > 480 ){
					long totalOverWork = totalMinute -480;
					long OverWorkhour = totalOverWork / 60;
					long OverWorkminute = totalOverWork % 60 ;
					overWorking.add(Long.toString(OverWorkhour) + "시 " + Long.toString(OverWorkminute)  + "분");
				} else {
					overWorking.add("0분");
				}
				
		}
		

		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("attendanceList", attendances);
		result.put("working", working);
		result.put("overWorking", overWorking);
		result.put("PageUtil", pageUtil);

		return new ResponseEntity<Object>(result, HttpStatus.OK);
	}
	
	@Override
	public ResponseEntity<Object> removeAttendanceList(String attendacneNoList) {
		List<String> list = Arrays.asList(attendacneNoList.split("\\,"));
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("deleteResult", attendanceMapper.deleteAttendacneList(list));
		return new ResponseEntity<Object>(result ,HttpStatus.OK) ;
	}
	
	@Override
	public ResponseEntity<Object> getAttendacneByNo(int attNo) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("attendance", attendanceMapper.selectAttendacneByNo(attNo));
		return new ResponseEntity<Object>(result ,HttpStatus.OK);
	}
	
	@Override
	public ResponseEntity<Object> modifyAttendance(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("updateResult", attendanceMapper.updateAttendacne(map));
		return new ResponseEntity<Object>(result ,HttpStatus.OK); 
		
	}
}
