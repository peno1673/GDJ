package com.gdu.app07.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gdu.app07.domain.BoardDTO;
import com.gdu.app07.service.BoardService;

@Controller
public class BoardController {
	
//	@Autowired
	private BoardService boardService;
	
	
	public BoardController(BoardService boardService) {
		super();
		this.boardService = boardService;
	}

	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	@GetMapping("brd/list")
	public String list(Model model) {
		model.addAttribute("boards", boardService.findAllBoards());
		System.out.println(boardService.findAllBoards());
		return "board/list"; 
	}
	@GetMapping("brd/detail")
	public String detail(@RequestParam(value = "board_no" , required=false, defaultValue = "0") int board_no
						, Model model) {
		model.addAttribute("board",boardService.findBoardByNo(board_no) );
		return "board/detail";
	}
	
	@GetMapping("brd/write")
	public String write() {
		return "board/write";
	}
	
	@PostMapping("brd/add")
	public String add(BoardDTO boardDTO) {
		boardService.saveBoard(boardDTO); //saveBoard()로부터 0/1이 반환되지만 처리하지 않았다.
		return "redirect:/brd/list";
	}
	
	@PostMapping("brd/remove")
	public String remove(@RequestParam(value = "board_no" , required=false, defaultValue = "0") int board_no) {
		boardService.removeBoard(board_no);
		return "redirect:/brd/list";
	}
	
	@PostMapping("brd/edit")
	public String edit(int board_no
			         , Model model) {
		model.addAttribute("board", boardService.findBoardByNo(board_no));
		return "board/edit";  // board 폴더의 edit.jsp로 forward 
	}
	
	@PostMapping("brd/modify")
	public String modify(BoardDTO boardDTO) {
		boardService.modifyBoard(boardDTO);
		return "redirect:/brd/detail?board_no=" + boardDTO.getBoard_no();
	}
	
}
