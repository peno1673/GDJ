package com.gdu.app13.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gdu.app13.mapper.UserMapper;
import com.gdu.app13.util.SecurityUtil;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class UserServiceImpl implements UserService {

	private UserMapper usersMapper;
	private SecurityUtil securityUtil;

	@Override
	public Map<String, Object> isReduceId(String id) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("isUser", usersMapper.selectUserById(id) != null);
		result.put("isRetireUser", usersMapper.selectRetireUserById(id) != null);

		return result;
	}

	@Override
	public Map<String, Object> isReduceEmail(String email) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("isUser", usersMapper.selectUserByEmail(email) != null);
		return result;
	}
	
	@Override
	public Map<String, Object> sendAuthCode(String email) {
		
		String authCode = securityUtil.getAuthCode(6);
		System.out.println("인증코드 : " + authCode);
//		String authCdoe = securityUtil.generateRandomString(6);
		
		Properties properties = new Properties();
		properties.put("mail.smtp.host", "smtp.gmail.com");
		properties.put("mail.smtp.port", "587");
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");
		
		String username="lm574947@gmail.com";
		String password="ixjidynqrrgmfext";
		
		Session session = Session.getInstance(properties, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
			
		});
		
		try {
			Message message = new MimeMessage(session);
			
			message.setFrom(new InternetAddress(username, "인증코드관리자")); //보내는 사람
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(email) );
			message.setSubject("[]인증 요청 메일입니다");
			message.setContent("인증번호 <strong>" + authCode + "</strong>", "text/html; charset=UTF-8" );
			
			Transport.send(message); 
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("authCode", authCode);
		return result;
	}
}
