package com.gdu.app12.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.gdu.app12.domain.BbsDTO;
import com.gdu.app12.mapper.BbsMapper;
import com.gdu.app12.util.PageUtil;
import com.gdu.app12.util.SecurityUtil;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class BbsServiceImpl implements BbsService {

	private BbsMapper bbsMapper;
	private PageUtil pageUtil;
	private SecurityUtil securityUtil;
	
	@Override
	public void findBbsList(HttpServletRequest request, Model model) {
		
		// 파라미터 page, 전달되지 않으면 page=1로 처리
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		// 전체 게시글 개수
		int totalRecord = bbsMapper.selectBbsCount();
		
		// 페이징에 필요한 모든 계산 완료
		pageUtil.setPageUtil(page, totalRecord);
		
		// DB로 보낼 Map(begin + end)
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		// DB에서 목록 가져오기
		List<BbsDTO> bbsList = bbsMapper.selectBbsList(map);
		
		// 뷰로 보낼 데이터
		model.addAttribute("bbsList", bbsList);
		model.addAttribute("paging", pageUtil.getPaging(request.getContextPath() + "/bbs/list"));
		model.addAttribute("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		
	}

	@Override
	public int addBbs(HttpServletRequest request) {
		
		String writer = securityUtil.sha256(request.getParameter("writer"));
		String title = securityUtil.preventXSS(request.getParameter("title"));
		String ip = request.getRemoteAddr();
		
		BbsDTO bbs = new BbsDTO();
		bbs.setWriter(writer);
		bbs.setTitle(title);
		bbs.setIp(ip);
		
		return bbsMapper.insertBbs(bbs);
		
	}

	
	/*
		@Transactional
		안녕. 난 트랜잭션을 처리하는 애너테이션이야.
		INSERT/UPDATE/DELETE 중 2개 이상이 호출되는 서비스에 추가하면 되.
	*/
	@Transactional
	@Override
	public int addReply(HttpServletRequest request) {
		
		// 작성자, 제목
		String writer = securityUtil.preventXSS(request.getParameter("writer"));
		String title = securityUtil.preventXSS(request.getParameter("title"));
		
		// IP
		String ip = request.getRemoteAddr();
		
		// 원글의 DEPTH, GROUP_NO, GROUP_ORDER
		int depth = Integer.parseInt(request.getParameter("depth"));
		int groupNo = Integer.parseInt(request.getParameter("groupNo"));
		int groupOrder = Integer.parseInt(request.getParameter("groupOrder"));
		
		// 원글DTO(updatePreviousReply를 위함)
		BbsDTO bbs = new BbsDTO();
		bbs.setDepth(depth);
		bbs.setGroupNo(groupNo);
		bbs.setGroupOrder(groupOrder);
		
		// updatePreviousReply 쿼리 실행
		bbsMapper.updatePreviousReply(bbs);
		
		// 답글DTO
		BbsDTO reply = new BbsDTO();
		reply.setWriter(writer);
		reply.setTitle(title);
		reply.setIp(ip);
		reply.setDepth(depth + 1);            // 답글 depth : 원글 depth + 1
		reply.setGroupNo(groupNo);            // 답글 groupNo : 원글 groupNo
		reply.setGroupOrder(groupOrder + 1);  // 답글 groupOrder : 원글 groupOrder + 1
		
		// insertReply 쿼리 실행		
		return bbsMapper.insertReply(reply);
		
	}

	@Override
	public int removeBbs(int bbsNo) {
		return bbsMapper.deleteBbs(bbsNo);
	}

}
