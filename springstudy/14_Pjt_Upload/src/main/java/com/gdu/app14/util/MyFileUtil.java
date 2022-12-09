package com.gdu.app14.util;

import java.io.File;
import java.util.Calendar;
import java.util.UUID;
import java.util.regex.Matcher;

import org.springframework.stereotype.Component;

@Component
public class MyFileUtil {
	// 파일명 : UUID값을 사용
	// 경로명 : 현재 날짜를 디렉토리로 생성해서 사용

	public String getFilename(String filename) {

		// 확장자 예외처리
		String extension = null;
		if (filename.endsWith("tar.gz")) {
			extension = "tar.gz";
		} else {
			// 파라미터로 전달된 filename의 확장자만 살려서 UUID, 확장자 방식으로 반환
			String[] arr = filename.split("\\."); // 정규식에서 . (마침표) 인식 : \. 또는 [.]
			extension = arr[arr.length - 1];
		}
		// UUID.확장자
		return UUID.randomUUID().toString().replaceAll("\\-", "") + "." + extension;
	}

	public String getTodayPath() {
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		String sep = Matcher.quoteReplacement(File.separator);
		return "storage" + sep + year + sep + makeZero(month) + sep + makeZero(day);
	}

	public String getYesterdayPath() {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, -1);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		String sep = Matcher.quoteReplacement(File.separator);
		return "storage" + sep + year + sep + makeZero(month) + sep + makeZero(day);
	}

	public String makeZero(int n) {
		
		return (n < 10) ? "0" + n : "" + n;
	}
}
