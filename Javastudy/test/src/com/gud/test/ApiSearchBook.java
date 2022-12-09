package com.gud.test;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.swing.JOptionPane;

import org.json.JSONArray;
import org.json.JSONObject;

public class ApiSearchBook {
	public static void main(String[] args) {
		
		String clientId = "KsY8l45Al74AXgTVxEKH";
		String clientSecret ="bwbFr1f1Tj";
		
		try {
			String search = URLEncoder.encode(JOptionPane.showInputDialog("입력해주세요"), "UTF-8");
			
			String apiURL = "https://openapi.naver.com/v1/search/book?query=" + search;
			
			URL url = new URL(apiURL);
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("X-Naver-Client-Id", clientId);
			con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
			BufferedReader br = null;
			
			if( con.getResponseCode() == HttpURLConnection.HTTP_OK) {
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else {
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			StringBuilder sb = new StringBuilder();
			String line;
			
			while( (line = br.readLine()) != null ) {
				sb.append(line);
			}
			br.close();
			con.disconnect();
			
			JSONObject object = new JSONObject(sb.toString());
			JSONArray items = object.getJSONArray("items");
			
			File dir = new File("C:/download");
			if(dir.exists() == false ) {
				dir.mkdirs();
			}
			File file = new File(dir,URLDecoder.decode(search, "UTF-8") + ".html" );
			PrintWriter out = new PrintWriter(file);
			out.println("<!DOCTYPE html>");
			out.println("<html>");
			out.println("<head>");
			out.println("<meta charset=\"UTF-8\">");
			out.println("<title>검색 결과</title>");
			out.println("</head>");
			out.println("<body>");
			
			for(int i = 0 ; i<items.length() ; i++) {
				out.println("<a href=" + items.getJSONObject(i).get("link")  +">"+ items.getJSONObject(i).get("title") + "</a>");
				out.println("<br>");
				out.println("<img src="+ items.getJSONObject(i).get("image")  + ">" );
				out.println("<br>");
			}
			
			out.println("<body>");
			out.println("</body>");
			out.println("</html>");
			out.close();
			
			System.out.println("파일생성 성공");
			 
			//정상처리 문제
		} catch (Exception e) {
			//문제발생 처리 문제
			try {
				File dir = new File("C:/download/log");
				if(dir.exists() == false ) {
					dir.mkdirs();
				}
				
				
				LocalDateTime time = LocalDateTime.now();
		        String formatedNow = time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd a HH:mm:ss"));
				
				File file = new File(dir, "error_log.txt");
				PrintWriter out = new PrintWriter(file);
				out.println("예외메시지   " + e.getMessage() );
				out.println("예외발생시간   " + formatedNow );
				out.close();
				
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
	}
}
