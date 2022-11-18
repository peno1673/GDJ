package com.gdu.app13.batch;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.gdu.app13.service.UserService;

@EnableScheduling
@Component
public class SleepUserScheduler {
	
	
	@Autowired
	private UserService userService;
	
//	@Scheduled(cron = "0 0 1 * * *")// 매일 새벽 1시
	@Scheduled(cron = "0 44 12 * * *")
	public void execute() {
		System.out.println("슬립유저 핸들");
		userService.sleepUserHandle();
	}
}
