package com.gdu.movie.batch;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.gdu.movie.domain.MovieDTO;
import com.gdu.movie.mapper.MovieMapper;

@EnableScheduling
@Component
public class MovieJob {

	@Autowired
	private MovieMapper movieMapper;
	
	@Scheduled(cron = "20 0 * * * *")
	public void execute() throws Exception {
		
		Map<String, Object> map = new HashMap();
		map.put("column", "GENRE");
		map.put("searchText", "코미디");
		List<MovieDTO> result = movieMapper.selectMoviesByQuery(map);
		File file = new File("","코미디.txt");
		System.out.println("스케쥴러 result : " + result);
		if(file.exists()) {
			file.delete();
		} else {
			file.createNewFile();
		}
		
		
		StringBuilder sb = new StringBuilder();
		try (BufferedWriter bw = new BufferedWriter(new FileWriter(file)) ) { // try-catch-resources문은
																										// 자원의 close를
								
			
			// 생략할 수 있다.
//			String line = null;
//			while ((line = bw. ) != null) {
//				sb.append(line);
//			}
			bw.write(result.toString());
			
//			System.out.println(sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		

	}

}
