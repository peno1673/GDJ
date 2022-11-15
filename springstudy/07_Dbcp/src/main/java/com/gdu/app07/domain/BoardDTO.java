package com.gdu.app07.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BoardDTO {
	private int board_no;
	private String title, content, writer, create_date, modify_date;
	
}
