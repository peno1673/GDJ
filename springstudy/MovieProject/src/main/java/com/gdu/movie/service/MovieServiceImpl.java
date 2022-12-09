package com.gdu.movie.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.gdu.movie.domain.MovieDTO;
import com.gdu.movie.mapper.MovieMapper;

@Service
public class MovieServiceImpl implements MovieService {

	@Autowired
	private MovieMapper movieMapper;

	@Override
	public ResponseEntity<Object> getMovieList() {
//		Map<String, Object> result = new HashMap();
//		result.put("message","전체" + movieMapper.selectAllMoviesCount() + "개의 목록을 반환합니다.");
//		result.put("list", movieMapper.selectAllMovies());
		return result;
	}

	@Override
	public int getMovieCount() {
		 return movieMapper.selectAllMoviesCount();
	}
	
	@Override
	public Map<String, Object> getMovieSerach(HttpServletRequest request) {
		String column = request.getParameter("column");
		String searchText =	request.getParameter("searchText");
		System.out.println(column);
		System.out.println(searchText);
		
		File file = new File("게임.txt");
		System.out.println(file);
		
		Map<String, Object> map = new HashMap();
		map.put("column", column);
		map.put("searchText", searchText);
		
		List<MovieDTO> result = movieMapper.selectMoviesByQuery(map);
		System.out.println(result.toString());
		if( result.isEmpty()) {
//			Map<String, Object> fail = new HashMap();
//			fail.put("message" , searchText);
//			fail.put("list" , null);
//			fail.put("stats" ,HttpStatus.NOT_FOUND );
//			
			return null ;
		} else {
			return null;
		}
		
	}
}
