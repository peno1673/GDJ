package com.group.sharegram.schedule.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.http.ResponseEntity;

import com.group.sharegram.schedule.domain.ScheduleDTO;

@Mapper
public interface ScheduleMapper {
	public int insertSchedule(ScheduleDTO schedule);
}
