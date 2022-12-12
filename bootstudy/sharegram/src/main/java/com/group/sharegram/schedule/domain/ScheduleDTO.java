package com.group.sharegram.schedule.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScheduleDTO {
	private int scheduleNo;
	private int empNo;
	private String scheduleTitle;
	private String scheduleCountent;
	private String scheduleStart;
	private String scheduleEnd;
	private String scheduleTimeStart;
	private String scheduleTimeENd;
	private String scheduleCategory;
	private String scheduleStatus;
	private String scheduleAllday;
	private String scheduleColorW;
}
