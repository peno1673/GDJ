<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script>
	
	$(function(){
		fn_init();
		fn_fileCheck();
		fn_save();
	});
	
	function fn_init(){
		$('#title').val('');
		$('#content').val('');
		$('#files').val('');
		$('#file_list').text('');
	}
	
	function fn_fileCheck(){
		$('#files').change(function(){
			let regExt = /(.*)\.(jpg|png|gif)$/;  // 확장자 제한을 위한 정규식
			let maxSize = 1024 * 1024 * 10;
			let files = this.files;
			$('#file_list').empty();
			$.each(files, function(i, file){
				// 확장자 체크
				if(regExt.test(files[i].name) == false){
					alert('이미지만 첨부할 수 있습니다.');
					$(this).val('');  // 첨부된 파일이 모두 없어짐
					return;
				}
				if(file.size > maxSize){
					alert('10MB 이하의 파일만 첨부할 수 있습니다.');
					$(this).val('');
					return;
				}
				$('#file_list').append('<div>' + file.name + '</div>');
			});
		});
	}
	
	function fn_save(){
		$('#btn_add').click(function(){
			// ajax로 파일을 첨부하는 경우 FormData 객체를 만듬
			let formData = new FormData();
			formData.append('title', $('#title').val());
			formData.append('content', $('#content').val());
			let files = $('#files')[0].files;
			for(let i = 0; i < files.length; i++){
				formData.append('files', files[i]);
			}
			$.ajax({
				url: '${contextPath}/uploads',
				type: 'post',
				data: formData,
				contentType: false,
				processData: false,
				dataType: 'json',
				success: function(resData){
					if(resData.isUploadSuccess) {
						alert('업로드 되었습니다.');
					} else {
						alert('업로드를 실패했습니다.');
					}
					if(resData.isAttachSuccess) {
						alert('파일이 첨부되었습니다.');
						$('#attach_list').empty();
						let result = '';
						for(let i = 0; i < resData.thumbnailList.length; i++){
							result += '<div><img src="${contextPath}/uploads/display?path=' + encodeURIComponent(resData.path) + '&thumbnail=' + resData.thumbnailList[i] + '"></div>';
						}
						$('#attach_list').html(result);
					} else {
						alert('파일 첨부가 실패했습니다.');
					}
					fn_init();
				}
			});
		});
	}
	
</script>
</head>
<body>
	
	<h1>업로드</h1>
	
	<div>
		<div>
			<input type="button" value="등록" id="btn_add">
		</div>
		<div>
			<label for="title">제목</label>
			<input type="text" id="title" name="title" required="required">
		</div>
		<div>
			<label for="content">내용</label>
			<input type="text" id="content" name="content">
		</div>
		<div>
			<label for="files">첨부</label>
			<input type="file" id="files" name="files" multiple="multiple">
			<div id="file_list"></div>
		</div>
	</div>
	
	<div>
		<h3>첨부된 파일 확인</h3>
		<div id="attach_list"></div>
	</div>
	
</body>
</html>