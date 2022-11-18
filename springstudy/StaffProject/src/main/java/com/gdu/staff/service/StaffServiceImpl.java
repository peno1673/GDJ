package com.gdu.staff.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.gdu.staff.domain.StaffDTO;
import com.gdu.staff.mapper.StaffMapper;

@Service
public class StaffServiceImpl implements StaffService {

	@Autowired
	private StaffMapper staffMapper;

	@Override
	public List<StaffDTO> getStaffList() {
		return staffMapper.selectStaffList();
	}

	@Override
	public ResponseEntity<String> addStaff(StaffDTO staffDTO) {
		
		try {
			switch (staffDTO.getDept()) {
			case "기획부":
				staffDTO.setSalary(5000);
				break;
			case "개발부":
				staffDTO.setSalary(6000);
				break;
			case "영업부":
				staffDTO.setSalary(7000);
				break;
			default:
				staffDTO.setSalary(4000);
				break;
			}
			System.out.println(staffDTO);
			System.out.println(staffMapper.insertStaff(staffDTO));		
			return new ResponseEntity<String>("사원 등록이 성공했습니다.", HttpStatus.OK);
		} catch(Exception e) {
	        return new ResponseEntity<String>("사원 등록이 실패했습니다,", HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	   
	}
	
	@Override
	public StaffDTO findStaff(String sno) {
		
//			System.out.println(staffMapper.selectStaffFind(sno));
			StaffDTO findStaff = staffMapper.selectStaffFind(sno);
			if(findStaff != null) {
				return findStaff;
			} else {
				return null;
			}
	}
}
