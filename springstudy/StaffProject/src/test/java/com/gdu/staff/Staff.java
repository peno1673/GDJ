package com.gdu.staff;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.gdu.staff.config.DBConfig;
import com.gdu.staff.domain.StaffDTO;
import com.gdu.staff.mapper.StaffMapper;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {DBConfig.class})
public class Staff {

	@Autowired
	StaffMapper staffMapper;
	
//	@Test
	@Before
	public void 등록() {
		StaffDTO staff = new StaffDTO("99999", "김기획", "기획부", 5000);
		int result = staffMapper.insertStaff(staff);
		assertEquals(1, result);
	}
	
	@Test
	public void 조회() {
		StaffDTO staff = staffMapper.selectStaffFind("99999");
		assertNotNull(staff);
	}
	
	

}
