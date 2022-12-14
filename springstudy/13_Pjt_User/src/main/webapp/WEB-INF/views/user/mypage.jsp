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
<script>

	$(function(){
		// 비밀번호 수정
		fn_showHide();
		fn_init();
		fn_pwCheck();
		fn_pwCheckAgain();
		fn_pwSubmit();
		// 일반정보 수정
		fn_nameCheck();
		fn_mobileCheck();
		fn_birthyear();
		fn_birthmonth();
		fn_birthdate();
		fn_emailCheck();
		fn_modify();
		fn_cancel();
		fn_retire();
	});
	
	// 비밀번호 수정
	var pwPass = false;
	var rePwPass = false;
	
	function fn_showHide(){
		$('#modify_pw_area').hide();
		$('#btn_edit_pw').click(function(){
			fn_init();
			$('#modify_pw_area').show();
		});
		$('#btn_edit_pw_cancel').click(function(){
			fn_init();
			$('#modify_pw_area').hide();
		});
	}
	
	function fn_init(){
		$('#pw').val('');
		$('#re_pw').val('');
		$('#msg_pw').text('');
		$('#msg_re_pw').text('');
	}
	
	function fn_pwCheck(){
		$('#pw').keyup(function(){
			let pwValue = $(this).val();
			let regPw = /^[0-9a-zA-Z!@#$%^&*]{8,20}$/;
			let validatePw = /[0-9]/.test(pwValue)        // 숫자가 있으면 true, 없으면 false
			               + /[a-z]/.test(pwValue)        // 소문자가 있으면 true, 없으면 false
			               + /[A-Z]/.test(pwValue)        // 대문자가 있으면 true, 없으면 false
			               + /[!@#$%^&*]/.test(pwValue);  // 특수문자8종이 있으면 true, 없으면 false
			if(regPw.test(pwValue) == false || validatePw < 3){
				$('#msg_pw').text('8~20자의 소문자, 대문자, 숫자, 특수문자(!@#$%^&*)를 3개 이상 조합해야 합니다.');
				pwPass = false;
			} else {
				$('#msg_pw').text('사용 가능한 비밀번호입니다.');
				pwPass = true;
			}
		});
	}
	
	function fn_pwCheckAgain(){
		$('#re_pw').keyup(function(){
			let rePwValue = $(this).val();
			if(rePwValue != '' && rePwValue != $('#pw').val()){
				$('#msg_re_pw').text('비밀번호를 확인하세요.');
				rePwPass = false;
			} else {
				$('#msg_re_pw').text('');
				rePwPass = true;
			}
		});
	}
	
	function fn_pwSubmit(){
		$('#frm_edit_pw').submit(function(event){
			if(pwPass == false || rePwPass == false){
				alert('비밀번호 입력을 확인하세요.');
				event.preventDefault();
				return;
			}
		});
	}
	
	// 일반정보 수정
	var namePass = true;
	var mobilePass = true;
	var emailPass = true;
	
	function fn_nameCheck(){
		$('#name').keyup(function(){
			let nameValue = $(this).val();
			namePass = (nameValue != '');
		});
	}
	
	function fn_mobileCheck(){
		$('#mobile').keyup(function(){
			let mobileValue = $(this).val();
			let regMobile = /^010[0-9]{7,8}$/;
			if(regMobile.test(mobileValue) == false){
				$('#msg_mobile').text('휴대전화를 확인하세요.');
				mobilePass = false;
			} else {
				$('#msg_mobile').text('');
				mobilePass = true;
			}
		});
	}
	
	function fn_birthyear(){
		let year = new Date().getFullYear();
		let strYear = '<option value="">년도</option>';
		for(let y = year - 100; y <= year + 1; y++){
			strYear += '<option value="' + y + '">' + y + '</option>';
		}
		$('#birthyear').append(strYear);
		$('#birthyear').val('${loginUser.birthyear}').prop('selected', true);
	}
	
	function fn_birthmonth(){
		let strMonth = '<option value="">월</option>';
		for(let m = 1; m <= 12; m++){
			if(m < 10){
				strMonth += '<option value="0' + m + '">' + m + '월</option>';
			} else {
				strMonth += '<option value="' + m + '">' + m + '월</option>';
			}
		}
		$('#birthmonth').append(strMonth);
		$('#birthmonth').val('${loginUser.birthday.substring(0,2)}').prop('selected', true);
	}
	
	function fn_birthdate(){
		$('#birthdate').empty();
		$('#birthdate').append('<option value="">일</option>');
		let endDay = 0;
		let strDay = '';
		switch($('#birthmonth').val()){
		case '02':
			endDay = 29; break;
		case '04':
		case '06':
		case '09':
		case '11':
			endDay = 30; break;
		default:
			endDay = 31; break;
		}
		for(let d = 1; d <= endDay; d++){
			if(d < 10){
				strDay += '<option value="0' + d + '">' + d + '일</option>';
			} else {
				strDay += '<option value="' + d + '">' + d + '일</option>';
			}
		}
		$('#birthdate').append(strDay);
		$('#birthdate').val('${loginUser.birthday.substring(2)}').prop('selected', true);
	}
	
	function fn_emailCheck(){
		$('#email').keyup(function(){
			let regEmail = /^[a-zA-Z0-9-_]+@[a-zA-Z0-9]+(\.[a-zA-Z]{2,}){1,2}$/;
			let emailValue = $(this).val();
			if(regEmail.test(emailValue) == false){
				$('#msg_email').text('이메일 형식이 올바르지 않습니다.');
				emailPass = false;
				return;
			}
			$.ajax({
				type: 'get',
				url: '${contextPath}/user/checkReduceEmail',
				data: 'email=' + $('#email').val(),
				dataType: 'json',
				success: function(resData){
					if(resData.isUser){
						$('#msg_email').text('이미 사용중인 이메일입니다.');
						emailPass = false;
					} else {
						$('#msg_email').text('');
						emailPass = true;
					}
				}
			});
		});
	}
	
	function fn_modify(){
		$('#frm_edit').submit(function(event){
			if(namePass == false){
				alert('이름을 확인하세요.');
				event.preventDefault();
				return;
			} else if(mobilePass == false){
				alert('휴대전화번호를 확인하세요.');
				event.preventDefault();
				return;
			} else if($('#birthyear').val() == '' || $('#birthmonth').val() == '' || $('#birthdate').val() == ''){
				alert('생년월일을 확인하세요.');
				event.preventDefault();
				return;
			} else if(emailPass == false){
				alert('이메일을 확인하세요.');
				event.preventDefault();
				return;
			}
		});
	}
	
	function fn_cancel(){
		$('#btn_cancel').click(function(){
			location.href='${contextPath}';
		});			
	}

	function fn_retire(){
		$('#btn_retire').click(function(){
			if (confirm('동일한 아이디로 재가입이 불가능합니다. 회원 탈퇴하시겠습니까?')){
				$('#lnk_retire').submit();
			}
		});
	}
	
</script>
</head>
<body>

	<div>
	
		<h1>마이페이지</h1>
		
		<div>
			<input type="button" value="비밀번호변경" id="btn_edit_pw">
		</div>
		<div id="modify_pw_area">
			<form id="frm_edit_pw" action="${contextPath}/user/modify/pw" method="post">
				<!-- 비밀번호 -->
				<div>
					<label for="pw">비밀번호</label>
					<input type="password" name="pw" id="pw">
					<span id="msg_pw"></span>
				</div>
				
				<!-- 비밀번호 재확인 -->
				<div>
					<label for="re_pw">비밀번호 확인</label>
					<input type="password" id="re_pw">
					<span id="msg_re_pw"></span>
				</div>
				<div>
					<button>비밀번호 변경하기</button>
					<input type="button" value="비밀번호변경취소하기" id="btn_edit_pw_cancel">
				</div>
			</form>
		</div>
	
		<div>
		
			<div>* 표시는 필수 입력사항입니다.</div>
		
			<hr>
			
			<form id="frm_edit" action="${contextPath}/user/modify" method="post">
			
				<!-- hidden -->
				<input type="hidden" name="id" value="${loginUser.id}">
			
				<!-- 아이디 -->
				<div>
					아이디 ${loginUser.id}
				</div>
				
				<!-- 가입일 -->
				<div>
					가입일 ${loginUser.joinDate}
				</div>
				
				<!-- 이름 -->
				<div>
					<label for="name">이름*</label>
					<input type="text" name="name" id="name" value="${loginUser.name}">
				</div>
				
				<!-- 성별 -->
				<div>
					<span>성별*</span>
					<input type="radio" name="gender" id="none" value="NO" checked="checked">
					<label for="none">선택 안함</label>
					<input type="radio" name="gender" id="male" value="M">
					<label for="male">남자</label>
					<input type="radio" name="gender" id="female" value="F">
					<label for="female">여자</label>
					<script>
						$(':radio[name="gender"][value="${loginUser.gender}"]').prop('checked', true);
					</script>
				</div>
			
				<!-- 휴대전화 -->
				<div>
					<label for="mobile">휴대전화*</label>
					<input type="text" name="mobile" id="mobile" value="${loginUser.mobile}">
					<span id="msg_mobile"></span>
				</div>
			
				<!-- 생년월일 -->
				<div>
					<label for="birthyear">생년월일*</label>
					<select name="birthyear" id="birthyear"></select>
					<select name="birthmonth" id="birthmonth"></select>
					<select name="birthdate" id="birthdate"></select>				
				</div>
				<script>
					
				</script>
				
				<!-- 주소 -->
				<div>
					<input type="text" onclick="fn_execDaumPostcode()" name="postcode" id="postcode" placeholder="우편번호" readonly="readonly" value="${loginUser.postcode}">
					<input type="button" onclick="fn_execDaumPostcode()" value="우편번호 찾기"><br>
					<input type="text" name="roadAddress" id="roadAddress" placeholder="도로명주소"  readonly="readonly" value="${loginUser.roadAddress}">
					<input type="text" name="jibunAddress" id="jibunAddress" placeholder="지번주소"  readonly="readonly" value="${loginUser.jibunAddress}"><br>
					<span id="guide" style="color:#999;display:none"></span>
					<input type="text" name="detailAddress" id="detailAddress" placeholder="상세주소" value="${loginUser.detailAddress}">
					<input type="text" name="extraAddress" id="extraAddress" placeholder="참고항목" readonly="readonly" value="${loginUser.extraAddress}">
					<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
					    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
					    function fn_execDaumPostcode() {
					        new daum.Postcode({
					            oncomplete: function(data) {
					                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
					
					                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
					                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					                var roadAddr = data.roadAddress; // 도로명 주소 변수
					                var extraRoadAddr = ''; // 참고 항목 변수
					
					                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
					                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
					                    extraRoadAddr += data.bname;
					                }
					                // 건물명이 있고, 공동주택일 경우 추가한다.
					                if(data.buildingName !== '' && data.apartment === 'Y'){
					                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					                }
					                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					                if(extraRoadAddr !== ''){
					                    extraRoadAddr = ' (' + extraRoadAddr + ')';
					                }
					
					                // 우편번호와 주소 정보를 해당 필드에 넣는다.
					                document.getElementById('postcode').value = data.zonecode;
					                document.getElementById("roadAddress").value = roadAddr;
					                document.getElementById("jibunAddress").value = data.jibunAddress;
					                
					                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
					                if(roadAddr !== ''){
					                    document.getElementById("extraAddress").value = extraRoadAddr;
					                } else {
					                    document.getElementById("extraAddress").value = '';
					                }
					
					                var guideTextBox = document.getElementById("guide");
					                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
					                if(data.autoRoadAddress) {
					                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
					                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
					                    guideTextBox.style.display = 'block';
					
					                } else if(data.autoJibunAddress) {
					                    var expJibunAddr = data.autoJibunAddress;
					                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
					                    guideTextBox.style.display = 'block';
					                } else {
					                    guideTextBox.innerHTML = '';
					                    guideTextBox.style.display = 'none';
					                }
					            }
					        }).open();
					    }
					</script>
				</div>
				
				<!-- 이메일 -->
				<div>
					<label for="email">이메일*</label>
					<input type="text" name="email" id="email" value="${loginUser.email}">
					<span id="msg_email"></span>
				</div>
				
				
				<!-- 선택 정보 동의 변경 -->
				<div>
					<div>위치정보 동의여부</div>
					<label><input type="radio" name="location" value="on">동의함</label>
					<label><input type="radio" name="location" value="off">동의 안함</label>
					<br><br>
					<script>
						if('${loginUser.agreeCode}' == '1' || '${loginUser.agreeCode}' == '3'){
							$(':radio[name="location"][value="on"]').prop('checked', true);				
						} else {
							$(':radio[name="location"][value="off"]').prop('checked', true);
						}
					</script>
			
					<div>프로모션 동의여부</div>
					<label><input type="radio" name="promotion" value="on">동의함</label>
					<label><input type="radio" name="promotion" value="off">동의 안함</label>
					<br><br>
					<script>
						if('${loginUser.agreeCode}' == '2' || '${loginUser.agreeCode}' == '3'){
							$(':radio[name="promotion"][value="on"]').prop('checked', true);				
						} else {
							$(':radio[name="promotion"][value="off"]').prop('checked', true);
						}
					</script>
				</div>
				
				<hr>
				
				<!-- 버튼 -->
				<div>
					<button>수정완료</button>
					<input type="button" value="취소하기" id="btn_cancel">
					<input type="button" value="회원탈퇴" id="btn_retire">
				</div>
			
			</form>
			
			<!-- 회원탈퇴용 form -->
			<form id="lnk_retire" action="${contextPath}/user/retire" method="post"></form>
			
		</div>
	
	</div>
	
</body>
</html>