package com.group.sharegram.schedule.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EarlyDTO {
	private int empNo;
	private String earlyContent; //조퇴사유
	private String earlyDate;  //조퇴일자
}