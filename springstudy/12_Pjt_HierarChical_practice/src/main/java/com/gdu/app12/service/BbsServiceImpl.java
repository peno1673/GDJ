package com.gdu.app12.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.gdu.app12.domain.BbsDTO;
import com.gdu.app12.mapper.BbsMapper;
import com.gdu.app12.util.PageUtil;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class BbsServiceImpl implements BbsService {

	private BbsMapper bbsMapper;
	private PageUtil pageUtil;
	
	@Override
	public void findAllBbsList(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Optional<String> opt2 = Optional.ofNullable(request.getParameter("recordPerPage"));
		int recordPerPage = Integer.parseInt(opt2.orElse("10"));
		
		int totalRecord = bbsMapper.selectAllBbsCount();
		
		pageUtil.setPageUtil(page, totalRecord ,recordPerPage );
		
		Map<String, Object> map = new HashMap<>();
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		List<BbsDTO> bbsList = bbsMapper.selectAllBbsList(map);
		
		model.addAttribute("bbsList", bbsList);
		model.addAttribute("paging", pageUtil.getPaging(request.getContextPath()+"/bbs/list"));
		model.addAttribute("beginNo", totalRecord - (page -1) * pageUtil.getRecordPerPage());
		model.addAttribute("recordPerPage", recordPerPage);
	}

	@Override
	public int addBbs(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int addReply(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int removeBbs(int bbsNo) {
		// TODO Auto-generated method stub
		return 0;
	}

}
