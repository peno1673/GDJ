<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script src="${contextPath}/resources/js/moment-with-locales.js"></script>
<script
	src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script
	src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet"
	href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.css">

<link rel='stylesheet'
	href="${contextPath}/resources/fullcalendar/lib/main.css" />
<link rel='stylesheet'
	href="${contextPath}/resources/css/fullcalendar.css">


<script src="${contextPath}/resources/fullcalendar/lib/main.js"></script>
<script src='${contextPath}/resources/fullcalendar/lib/locales-all.js'></script>
<!-- <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css' rel='stylesheet'>
<link href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css' rel='stylesheet'> -->
<script>

$(function () {
	
	  var calendarEl = document.getElementById('calendar');
	  var calendar = new FullCalendar.Calendar(calendarEl, {
	    googleCalendarApiKey: 'AIzaSyCwPYapKCl7z89E7azAvNTr4IsfP4uo4YQ',
	    initialView: 'dayGridMonth',
	    firstDay: 1, //월요일부터 달력시작
	    locale: 'ko',
	    selectable: true, // 사용자가 클릭하고 드래그하여 여러 날짜 또는 시간 슬롯을 강조 표시할 수 있습니다.
	    expandRows: true, // 화면에 맞게 높이 재설정
	    nowIndicator: true, // 지금 시간 빨간색으로 마크
	    businessHours: true,
	    editable: true,
	    navLinks: true,
	    height: 700,
	    aspectRatio: 0.3,
	    eventAdd: function (obj) {
	      // 이벤트가 추가되면 발생하는 이벤트
	      console.log(obj);
	      console.log(obj.event.startStr);
	    },
	    eventChange: function (obj) {
	      // 이벤트가 수정되면 발생하는 이벤트
	      console.log(obj);
	    },
	    eventRemove: function (obj) {
	      // 이벤트가 삭제되면 발생하는 이벤트
	      console.log(obj);
	    },
	   
	    eventTimeFormat : {
	        year: 'numeric',
	    	month: '2-digit',
	        day: '2-digit',
	        weekday: 'long',
	        hour : '2-digit',
	        minute : '2-digit',
	    },
	    

	    //헤더
	    headerToolbar: {
	      start: 'title',
	      center: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek, addEventButton',
	      end: 'today prevYear,prev,next,nextYear',
	    },

	    //업무시간
	    businessHours: {
	      daysOfWeek: [1, 2, 3, 4, 5],
	      startTime: '09:00',
	      endTime: '18:00',
	    },

	    // 날짜 클릭시 데이트 반환 나중에 지우기
	    dateClick: function (info) {
	      alert('Date: ' + info.dateStr);
	    },

	   
	    navLinkDayClick: function (date, jsEvent) {
	      console.log('day', date.toISOString());
	      console.log('coords', jsEvent.pageX, jsEvent.pageY);
	    },
	    

	    events: [
	      // 일정 데이터 추가 , DB의 event를 가져오려면 JSON 형식으로 변환해 events에 넣어주면된다.
	      {
	        title: '일정',
	        start: '2022-12-13',
	        end: '2022-12-17',
	        backgroundColor : 'Brown',
	        textColor : 'red',
	      },
	    ],
	    eventSources: [
	      {
	        googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
	        className: '대한민국 공유일',
	        color: 'red',
	      },
	    ],
	    
	    eventDrop: function (info){
            console.log(info);
            if(confirm("'"+ info.event.title +"' 매니저의 일정을 수정하시겠습니까 ?")){
            }
            var events = new Array(); // Json 데이터를 받기 위한 배열 선언
            var obj = new Object();
			
            
            obj.title = info.event._def.title;
            obj.start = info.event._instance.range.startStr;
            obj.end = info.event._instance.range.endStr;
            
            
            events.push(obj);

            //console.log(events);
            console.log('---------');
            console.log(obj);
            console.log('---------');
            $(function deleteData() {
                $.ajax({
                    url: "/full-calendar/calendar-admin-update",
                    method: "PATCH",
                    dataType: "json",
                    data: JSON.stringify(events),
                    contentType: 'application/json',
                })
            })
        },
	    
		select : function (addCalendar) { // 캘린더에서 이벤트를 생성할 수 있다.
	    	let title = prompt('일정을 입력해주세요.');
	        	if (title) {
	            	calendar.addEvent({
	                	title: title,
	                	start: addCalendar.start,
	                	end: addCalendar.end,
	                	allDay: addCalendar.allDay,
	             	 })
	          	}
		 }, 
	    
	  });
	  calendar.render();
	});

</script>
</head>
<body>

	<div id='calendar'></div>

</body>
</html>