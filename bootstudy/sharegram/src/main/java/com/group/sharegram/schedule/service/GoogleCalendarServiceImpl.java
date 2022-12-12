package com.group.sharegram.schedule.service;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Service;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.CalendarScopes;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.Events;

@Service
public class GoogleCalendarServiceImpl implements GoogleCalendarService {

	private static final String APPLICATION_NAME = "Google Calendar API Java Quickstart";

	private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();

	private static final String CREDENTIALS_FOLDER = "credentials"; // Directory to store user credentials.

	private static final String CALENDAR_ID = "primary";

	private static final String TOKENS_DIRECTORY_PATH = "TOKENS_DIRECTORY_PATH";

	private static final List<String> SCOPES = Collections.singletonList(CalendarScopes.CALENDAR_READONLY);
	
	private static final String CREDENTIALS_FILE_PATH = "/credentials.json";
	
	
	private static Credential getCredentials(final NetHttpTransport HTTP_TRANSPORT) throws IOException {
		// 권한 경로
		InputStream in = GoogleCalendarServiceImpl.class.getResourceAsStream(CREDENTIALS_FILE_PATH);
		if (in == null) {
			throw new FileNotFoundException("Resource not found: " + CREDENTIALS_FILE_PATH);
		}
		
		GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, new InputStreamReader(in));

		//권한 요청
		GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(HTTP_TRANSPORT, JSON_FACTORY,
				clientSecrets, SCOPES)
				.setDataStoreFactory(new FileDataStoreFactory(new java.io.File(CREDENTIALS_FOLDER)))
				.setAccessType("offline").build();
		LocalServerReceiver receiver = new LocalServerReceiver.Builder().setPort(8088).build();
		Credential credential = new AuthorizationCodeInstalledApp(flow, receiver).authorize("user");
		// returns an authorized Credential object.
		return credential;
	}
	
	public static Event addEvent(Event event) throws IOException, GeneralSecurityException, GoogleJsonResponseException {

	       final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
	       Calendar service = new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
	               .setApplicationName(APPLICATION_NAME)
	               .build();
	       
	       System.out.println("addEvent");
	       return service.events().insert(CALENDAR_ID, event).execute();
	 }
	
	public static void delEvent(String eventKey) throws IOException, GeneralSecurityException, GoogleJsonResponseException {

	       final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
	       Calendar service = new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
	               .setApplicationName(APPLICATION_NAME)
	               .build();
	       service.events().delete(CALENDAR_ID, eventKey).execute();

	   }

	
	@Override
	public void getCalendar() throws GeneralSecurityException, IOException  {
		 // Build a new authorized API client service.
	    final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
	    Calendar service =
	        new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
	            .setApplicationName(APPLICATION_NAME)
	            .build();

	    // List the next 10 events from the primary calendar.
	    DateTime now = new DateTime(System.currentTimeMillis());
	    Events events = service.events().list("primary")
	        .setMaxResults(10)
	        .setTimeMin(now)
	        .setOrderBy("startTime")
	        .setSingleEvents(true)
	        .execute();
	    List<Event> items = events.getItems();
	    if (items.isEmpty()) {
	      System.out.println("No upcoming events found.");
	    } else {
	      System.out.println("Upcoming events");
	      for (Event event : items) {
	        DateTime start = event.getStart().getDateTime();
	        if (start == null) {
	          start = event.getStart().getDate();
	        }
	        System.out.printf("%s (%s)\n", event.getSummary(), start);
	      }
	    }
	}
	
	
	@Override
	public void getCalendarList() throws GeneralSecurityException, IOException {
		// key
//				String key = "e246df0435b84d071abad3ce5355e26e";  // 각자 발급 받은 service key
//				
//				// ApiURL
//				String apiURL = "https://www.googleapis.com/calendar/v3/calendars/calendarId";
//				apiURL += "?key=" + key + "&targetDt=" ;
//				
//				// API 요청
//				URL url = null;
//				HttpURLConnection con = null;
//				try {
//					url = new URL(apiURL);  // MalformedURLException
//					con = (HttpURLConnection) url.openConnection();  // IOException
//					con.setRequestMethod("GET");  // "GET"을 대문자로 지정
//				} catch (MalformedURLException e) {
//					e.printStackTrace();
//				} catch (IOException e) {
//					e.printStackTrace();
//				}
//				
//				// API 응답
//				StringBuilder sb = new StringBuilder();
//				try (BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()))) {  // try-catch-resources문을 쓰면 reader.close를 생략할 수 있다.
//					String line = null;
//					while((line = reader.readLine()) != null) {
//						sb.append(line);
//					}
//				} catch(Exception e) {
//					e.printStackTrace();
//				}
//				
//				// con 닫기
//				con.disconnect();
				
				final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
				// Initialize Calendar service with valid OAuth credentials
				Calendar service = new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
				    .setApplicationName("applicationName").build();
				com.google.api.services.calendar.model.Calendar calendar =
					    service.calendars().get("primary").execute();
				System.out.println("갯 서머리? " + calendar.getSummary());
				
				
	}
	



}
