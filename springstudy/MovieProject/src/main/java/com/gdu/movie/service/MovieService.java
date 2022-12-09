package com.gdu.movie.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;

import com.gdu.movie.domain.MovieDTO;

public interface MovieService {

	public ResponseEntity<Object> getMovieList();
	public int getMovieCount();
	
	public Map<String, Object> getMovieSerach(HttpServletRequest request);
}
