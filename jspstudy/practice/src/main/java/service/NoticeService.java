package service;

import javax.servlet.http.HttpServletRequest;

import common.ActionForward;

public interface NoticeService {
	public int getAllNotciesCnt();
	public ActionForward findAllNotices(HttpServletRequest request);
}
