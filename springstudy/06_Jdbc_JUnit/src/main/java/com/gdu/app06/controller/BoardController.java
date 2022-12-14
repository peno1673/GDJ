package com.gdu.app06.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gdu.app06.domain.BoardDTO;
import com.gdu.app06.service.BoardService;

/*
	@Component
	안녕. 난 컨테이너에 저장되는 Bean으로 만들어지는 클래스에 붙이는 애너테이션이야.
	지금까지 거의 root-context.xml의 <bean> 태그나 @Configuration + @Bean으로 컨테이너에 Bean을 등록해 두었는데,
	이제 @Component를 자주 사용할거야.
	이것만 붙여두면 똑같이 Bean으로 컨테이너에 저장되거든.
	
	@Component로 만들어 진 Bean이 @Autowired되려면
	servlet-context.xml의 <context:component-scan> 태그에 @Component가 등록되어 있는 패키지 이름이 등록되어 있어야 해.
*/

@Controller  // 컨트롤러가 사용하는 @Component

public class BoardController {
	
	
	@Autowired  // 컨테이너에 생성된 Bean중에서 BoardService 타입의 Bean을 가져오세요.
	            // BoardService 타입은 BoardServiceImpl도 포함하는 타입이니까 BoardServiceImpl 객체를 가져올 수 있어.
	            // BoardServiceImpl은 @Service를 이용해서 @Component로 등록해 두었기 때문에 @Autowired 할 수 있어.
	private BoardService boardService;
	
	
	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	
	@GetMapping("/brd/list")
	public String list(Model model) {  // Model은 forward할 속성(Attribute)을 저장할 때 사용한다.
		model.addAttribute("boards", boardService.findAllBoards());
		return "board/list";  // board 폴더의 list.jsp로 forward
	}
	
	
	@GetMapping("/brd/write")
	public String write() {
		return "board/write";  // board 폴더의 write.jsp로 forward
	}
	
	
	@PostMapping("/brd/add")
	public String add(BoardDTO board) {
		boardService.saveBoard(board);  // saveBoard()로부터 0/1이 반환되지만 처리하지 않았다.
		return "redirect:/brd/list";
	}	
	
	
	@GetMapping("/brd/detail")
	public String detail(@RequestParam(value="board_no", required=false, defaultValue="0") int board_no
			           , Model model) {
		model.addAttribute("board", boardService.findBoardByNo(board_no));
		return "board/detail";  // board 폴더의 detail.jsp로 forward 
	}
	
	
	@PostMapping("/brd/edit")
	public String edit(int board_no
			         , Model model) {
		model.addAttribute("board", boardService.findBoardByNo(board_no));
		return "board/edit";  // board 폴더의 edit.jsp로 forward 
	}
	
	
	@PostMapping("/brd/modify")
	public String modify(BoardDTO board) {
		boardService.modifyBoard(board);  // modifyBoard()로부터 0/1이 반환되지만 처리하지 않았다.
		return "redirect:/brd/detail?board_no=" + board.getBoard_no();
	}
	
	
	@PostMapping("/brd/remove")
	public String remove(int board_no) {
		boardService.removeBoard(board_no);  // removeBoard()로부터 0/1이 반환되지만 처리하지 않았다.
		return "redirect:/brd/list";
	}
	
	
}
