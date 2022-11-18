package com.gdu.staff.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StaffDTO {
	
	private String sno;
	private String name;
	private String dept;
	private int salary;
	
}
