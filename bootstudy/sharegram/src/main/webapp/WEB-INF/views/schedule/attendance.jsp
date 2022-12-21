<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script src="${contextPath}/resources/js/moment-with-locales.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet" href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.css">

<script>
$(function(){
	/* fn_checkAll();
	fn_checkOne();
	fn_add();
	fn_init(); */
	fn_list();
	/* fn_changePage();
	fn_detail();
	fn_modify();
	fn_remove(); 
	fn_PageUtil();
	*/
});

/* function fn_checkAll(){
	$('#check_all').click(function(){
		$('.check_one').prop('checked', $('#check_all').prop('checked'));
	});
}

function fn_checkOne(){
	$(document).on('click', '.check_one', function(){
		let checkCount = 0;
		for(let i = 0; i < $('.check_one').length; i++){
			checkCount += $($('.check_one')[i]).prop('checked');				
		}
		$('#check_all').prop('checked', checkCount == $('.check_one').length);
	});
}

function fn_add(){
	$('#btn_add').click(function(){
		// 추가할 회원 정보를 JSON으로 만든다.
		let member = JSON.stringify({
			'id': $('#id').val(),
			'name': $('#name').val(),
			'gender': $(':radio[name=gender]:checked').val(),
			'address': $('#address').val()
		});
		console.log( $('#name').val() )
		// 추가할 회원 정보를 DB로 보낸다.
		$.ajax({
			type: 'post',
			url: '${contextPath}/members',
			data: member,  // 파라미터 이름 없음(본문에 member를 포함시켜서 전송)
			contentType: 'application/json',  // 요청 데이터의 MIME-TYPE
			dataType: 'json',
			success: function(resData){
				console.log(resData)
				if(resData.insertResult > 0) {
					alert('회원이 등록되었습니다.');
					fn_list();
					fn_init();
				} else {
					alert('회원이 등록되지 않았습니다.');
				}
			},
			error: function(jqXHR){
				alert('에러코드(' + jqXHR.status + ') ' + jqXHR.responseText);
			}
		});
	});
}

function fn_init(){
	$('#id').val('').prop('readonly', false);
	$('#name').val('');
	$(':radio[name=gender]').prop('checked', false);
	$('#address').val('');
}
 */
// 전역변수
var page = 1;

function fn_list(){
	$.ajax({
		type: 'get',
		url: '${contextPath}/attendance' ,
		dataType: 'json',
		success: function(resData){
			console.log(resData)
			// 근태목록
			$('#attendace_list').empty();
			$.each(resData , function(i, list){
				console.log(list.attendanceList);
				let tr = '<tr>';
				/* tr += '<td><input type="checkbox" class="check_one" value="'+ member.memberNo +'"></td>';  */
				tr += '<td>' + list.empNo + '</td>'; 
				/* tr += '<td>' + list.empDTO.name + '</td>';
				tr += '<td>' + list.empDTO.depDTO.deptName + '</td>';
				tr += '<td>' + list.empDTO.posDTO.jobName + '</td>';
				tr += '<td>' + list.attStart + '</td>';
				tr += '<td>' + list.attEnd + '</td>';
				tr += '<td>' + list.working + '</td>';
				tr += '<td>' + list.overWorking + '</td>';
				tr += '<td>' + list.attStatus + '</td>'; */
				/* tr += '<td><input type="button" value="조회" class="btn_detail" data-member_no="'+ member.memberNo +'"></td>'; */
				tr += '</tr>';
				$('#attendace_list').append(tr);  
			});
			
		
		} 
	});
}



</script>

</head>
<body>
	
	<h1>근태 페이지</h1>
	<div>
		<input type="button" value="선택삭제" id="btn_remove">
		<table border="1">
			<thead>
				<tr>
				<!-- 	<td><input type="checkbox" id="check_all"></td> -->
					<td>사원번호</td>
					<td>이름</td>
					<td>부서명</td>
					<td>직급명</td>
					<td>출근시간</td>
					<td>퇴근시간</td>
					<td>근무시간</td>
					<td>연장근무시간</td>
					<td>근무상태</td>
				</tr>
			</thead>
			<tbody id="attendace_list"></tbody>
			<tfoot>
				<tr>
					<td colspan="9">
						<div id="paging"></div>
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
	
</body>
</html>