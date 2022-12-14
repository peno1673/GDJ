package com.gdu.rest.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.rest.domain.AttachDTO;
import com.gdu.rest.domain.UploadDTO;

@Mapper
public interface UploadMapper {
	public int insertUpload(UploadDTO upload);
	public int insertAttach(AttachDTO attach);
}
