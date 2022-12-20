package com.group.sharegram.schedule.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.group.sharegram.schedule.domain.EarlyDTO;

@Mapper
public interface EarlyMapper {
	public int insertEarly(EarlyDTO earlyDTO);
}
