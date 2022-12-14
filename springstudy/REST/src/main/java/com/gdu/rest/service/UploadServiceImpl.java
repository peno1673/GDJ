package com.gdu.rest.service;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.rest.domain.AttachDTO;
import com.gdu.rest.domain.UploadDTO;
import com.gdu.rest.mapper.UploadMapper;
import com.gdu.rest.util.MyFileUtil;

import net.coobird.thumbnailator.Thumbnails;

@Service
public class UploadServiceImpl implements UploadService {

	@Autowired
	private UploadMapper uploadMapper;
	
	@Autowired
	private MyFileUtil myFileUtil;
	
	@Transactional
	@Override
	public Map<String, Object> save(MultipartHttpServletRequest multipartRequest) {
		
		/*  UPLOAD 테이블에 저장하기 */
		
		// 전달된 파라미터
		String title = multipartRequest.getParameter("title");
		String content = multipartRequest.getParameter("content");
		
		// DB로 보낼 UploadDTO
		UploadDTO upload = UploadDTO.builder()
				.title(title)
				.content(content)
				.build();
		
		// DB에 UploadDTO 저장
		int uploadResult = uploadMapper.insertUpload(upload);  // <selectKey>에 의해서 인수 upload에 uploadNo값이 저장된다.

		/* ATTACH 테이블에 저장하기 */
		
		// 첨부된 파일 목록
		List<MultipartFile> files = multipartRequest.getFiles("files");  // <input type="file" name="files">

		// 썸네일 이름 목록
		List<String> thumbnailList = new ArrayList<>();

		// 첨부 결과
		int attachResult;
		if(files.get(0).getSize() == 0) {  // 첨부가 없는 경우 (files 리스트에 [MultipartFile[field="files", filename=, contentType=application/octet-stream, size=0]] 이렇게 저장되어 있어서 files.size()가 1이다.
			attachResult = 1;
		} else {
			attachResult = 0;
		}
		
		// path의 scope 조정
		String path = null;
		
		// 첨부된 파일 목록 순회(하나씩 저장)
		for (MultipartFile multipartFile : files) {
			
			try {
				
				// 첨부가 있는지 점검
				if(multipartFile != null && multipartFile.isEmpty() == false) {  // 둘 다 필요함
					
					// 원래 이름
					String origin = multipartFile.getOriginalFilename();
					origin = origin.substring(origin.lastIndexOf("\\") + 1);  // IE는 origin에 전체 경로가 붙어서 파일명만 사용해야 함
					
					// 저장할 이름
					String filesystem = myFileUtil.getFilename(origin);
					
					// 저장할 경로
					path = myFileUtil.getTodayPath();
					
					// 저장할 경로 만들기
					File dir = new File(path);
					if(dir.exists() == false) {
						dir.mkdirs();
					}
					
					// 첨부할 File 객체
					File file = new File(dir, filesystem);
					
					// 첨부파일 서버에 저장(업로드 진행)
					multipartFile.transferTo(file);

					// AttachDTO 생성
					AttachDTO attach = AttachDTO.builder()
							.path(path)
							.origin(origin)
							.filesystem(filesystem)
							.uploadNo(upload.getUploadNo())
							.build();
					
					// DB에 AttachDTO 저장
					attachResult += uploadMapper.insertAttach(attach);
					
					// 첨부파일의 Content-Type 확인
					String contentType = Files.probeContentType(file.toPath());  // 이미지의 Content-Type(image/jpeg, image/png, image/gif)

					// 첨부파일이 이미지이면 썸네일을 만듬 (없어도 되지만 한 번 더 확인)
					if(contentType != null && contentType.startsWith("image")) {
					
						// 썸네일 서버에 저장(썸네일 정보는 DB에 저장되지 않음)
						Thumbnails.of(file)
							.size(100, 100)
							.toFile(new File(dir, "s_" + filesystem));  // 썸네일의 이름은 s_로 시작함
						
						// 썸네일 이름 List에 추가
						thumbnailList.add("s_" + filesystem);
					
					}

				}
				
			} catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		
		// 응답할 데이터
		Map<String, Object> map = new HashMap<>();
		map.put("isUploadSuccess", uploadResult == 1);  // 갤러리 성공 유무
		map.put("isAttachSuccess", attachResult == files.size());  // 첨부 성공 유무
		map.put("thumbnailList", thumbnailList);  // 썸네일 이름 목록
		map.put("path", path);  // 썸네일이 저장된 경로
		return map;
		
	}
	
	@Override
	public ResponseEntity<byte[]> display(String path, String thumbnail) {
		
		File file = new File(path, thumbnail);
		
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), null, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}
	
}
