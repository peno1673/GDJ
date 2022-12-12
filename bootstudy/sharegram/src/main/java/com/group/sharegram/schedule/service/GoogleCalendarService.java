package com.group.sharegram.schedule.service;

import java.io.IOException;
import java.security.GeneralSecurityException;

public interface GoogleCalendarService {
	
	public void getCalendar() throws GeneralSecurityException, IOException;
	public void getCalendarList() throws GeneralSecurityException, IOException ;
}
