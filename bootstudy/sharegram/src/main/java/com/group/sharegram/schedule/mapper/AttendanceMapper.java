package com.group.sharegram.schedule.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.schedule.domain.AttendanceDTO;

@Mapper
public interface AttendanceMapper {
	public int insertAttendacne(AttendanceDTO attendacne);
	public int updateLeaveWork(AttendanceDTO attendacne);
	public AttendanceDTO selectAttendanceCheck(AttendanceDTO attendacne);
}
