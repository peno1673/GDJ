package com.gdu.app03.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.gdu.app03.domain.Notice;

@Configuration
public class SpringBeanConfig {
	
	@Bean
	public Notice notice1() {
		Notice notice = new Notice();
		notice.setNoticeNo(1);
		notice.setTitle("공지사항");
		return notice;
	}
	
	@Bean
	public Notice notice2() {
		return new Notice(2, "긴급공지");
	}
	
	
}
