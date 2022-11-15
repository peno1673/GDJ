package service;

import java.io.PrintWriter;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import repository.MemberDao;

public class MemberDeleteService implements MemberService {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		Optional<String> opt = Optional.ofNullable(request.getParameter("memberNo"));
		int memberNo = Integer.parseInt(opt.orElse("0"));

		response.setContentType("application/json");

		int result = MemberDao.getInstance().deleteMember(memberNo);

		try {
			JSONObject obj = new JSONObject();
			obj.put("isSuccess", result > 0);
			
			// 응답 ($.ajax의 success 프로퍼티로 전달)
			PrintWriter out = response.getWriter();
			out.println(obj.toString());
			out.close();
		} catch (Exception e) {
			response.setContentType("text/plain; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("잘못된 회원 번호가 전달되었습니다."
					+ "");
			out.close();
		}
	}

}