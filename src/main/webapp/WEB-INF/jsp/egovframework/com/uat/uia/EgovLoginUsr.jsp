<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovLoginUsr.jsp
  * @Description : Login 인증 화면
  * @Modification Information
  * @
  * @  수정일         수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2009.03.03    박지욱          최초 생성
  *   2011.09.25    서준식          사용자 관리 패키지가 미포함 되었을때에 회원가입 오류 메시지 표시
  *   2011.10.27    서준식          사용자 입력 탭 순서 변경
  *  @author 공통서비스 개발팀 박지욱
  *  @since 2009.03.03
  *  @version 1.0
  *  @see
  *
  *  Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<link href="<c:url value='/css/egovframework/bopr/egovBopr.css' />" rel="stylesheet" type="text/css">
<title>전자정부 배치운영환경 로그인페이지</title>
<script type="text/javaScript" language="javascript">

function checkLogin(userSe) {
    // 일반회원
    if (userSe == "GNR") {
        document.loginForm.rdoSlctUsr[0].checked = true;
        document.loginForm.rdoSlctUsr[1].checked = false;
        document.loginForm.rdoSlctUsr[2].checked = false;
        document.loginForm.userSe.value = "GNR";
    // 기업회원
    } else if (userSe == "ENT") {
        document.loginForm.rdoSlctUsr[0].checked = false;
        document.loginForm.rdoSlctUsr[1].checked = true;
        document.loginForm.rdoSlctUsr[2].checked = false;
        document.loginForm.userSe.value = "ENT";
    // 업무사용자
    } else if (userSe == "USR") {
        document.loginForm.rdoSlctUsr[0].checked = false;
        document.loginForm.rdoSlctUsr[1].checked = false;
        document.loginForm.rdoSlctUsr[2].checked = true;
        document.loginForm.userSe.value = "USR";
    }
}

function actionLogin() {

    if (document.loginForm.id.value =="") {
        alert("아이디를 입력하세요");
    } else if (document.loginForm.password.value =="") {
        alert("비밀번호를 입력하세요");
    } else {
        document.loginForm.action="<c:url value='/uat/uia/actionLogin.do'/>";
        //document.loginForm.j_username.value = document.loginForm.userSe.value + document.loginForm.username.value;
        //document.loginForm.action="<c:url value='/j_spring_security_check'/>";
        document.loginForm.submit();
    }
}

function actionCrtfctLogin() {
    document.defaultForm.action="<c:url value='/uat/uia/actionCrtfctLogin.do'/>";
    document.defaultForm.submit();
}

function goFindId() {
    document.defaultForm.action="<c:url value='/uat/uia/egovIdPasswordSearch.do'/>";
    document.defaultForm.submit();
}

function goRegiUsr() {
	
	//사용자 등록화면으로 이동
	document.loginForm.action="<c:url value='/main/JoinView.do'/>";
    document.loginForm.submit();
    
}

function goGpkiIssu() {
    document.defaultForm.action="<c:url value='/uat/uia/egovGpkiIssu.do'/>";
    document.defaultForm.submit();
}

function setCookie (name, value, expires) {
    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
}

function getCookie(Name) {
    var search = Name + "=";
    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
        offset = document.cookie.indexOf(search);
        if (offset != -1) { // 쿠키가 존재하면
            offset += search.length;
            // set index of beginning of value
            end = document.cookie.indexOf(";", offset);
            // 쿠키 값의 마지막 위치 인덱스 번호 설정
            if (end == -1)
                end = document.cookie.length;
            return unescape(document.cookie.substring(offset, end));
        }
    }
    return "";
}

function saveid(form) {
    var expdate = new Date();
    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
    if (form.checkId.checked)
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
    else
        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
    setCookie("saveid", form.id.value, expdate);
}

function getid(form) {
    form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
}

function fnInit() {
    var message = document.loginForm.message.value;
    if (message != "") {
        alert(message);
    }

    getid(document.loginForm);
    // 포커스
    //document.loginForm.rdoSlctUsr.focus();
}

function press() {

    if (event.keyCode==13) {
    	actionLogin();
    }
}
</script>
</head>
<body onLoad="fnInit();">
<form name="loginForm" action ="<c:url value='/uat/uia/actionLogin.do'/>" method="post">
<div id="wrapLogin">
	
	<div id="loginContent">
		<div class="loginBg">
			<div id="login">
				<div class="boxLogin">
					<ul class="idpwInput">
						<li><label for="id" class="disp_none">아이디입력</label><input type="text" name="id" id="id" title="아이디 입력" onkeypress="press();" tabindex="1" autocomplete="off" placeholder="ID" /></li>
						<li>
							<label for="pw" class="disp_none">비밀번호입력</label><input type="password" name="password" id="password" title="비밀번호 입력" onkeypress="press();" tabindex="2" autocomplete="off" placeholder="비밀번호" />
							<div class="btnLogin"><a href="#LINK" onClick="javascript:actionLogin();" tabindex="3"><img src="<c:url value='/images/egovframework/bopr/login/btn_login.jpg' />"  alt="로그인" /></a></div>
						</li>
						<li>
							<p><a href="#LINK" onClick="javascript:goRegiUsr();" style="margin-right: 10px;" tabindex="4" title="회원가입 화면으로 이동"><img src="<c:url value='/images/egovframework/bopr/login/btn_member_regi.gif' />" alt="회원가입" title="회원가입" /></a>
							<label for="checkId" class="disp_none">ID저장</label>
							<input class="check" type="checkbox" name="checkId" onClick="javascript:saveid(document.loginForm);" id="checkId" tabindex="5"/>ID저장<p>
						</li>						
					</ul>					
				</div>
			</div>
		</div>
	</div>

	<!-- footer -->
	<div id="footerLogin">
		<div class="lobFooter">
			<h2><img src="<c:url value='/images/egovframework/bopr/login/img_mopaslogo.jpg' />"  alt="안전행정부 로고" /></h2>
			<address><img src="<c:url value='/images/egovframework/bopr/login/img_copyright_text.jpg' />"  alt="(우)110-751 서울특별시 종로구 세종로55 정부중앙청사
			COPYRIGHT(C)2010 MINISTRY OF REPUBLIC AMINISTRATION AND SECURITY. ALL RIGHT RESERVED" /></address>
			<div class="monitor"><img src="<c:url value='/images/egovframework/bopr/login/img_monitoring.jpg' />" alt="egovframe 전자정부 배치운영환경" /></div>
		</div>
	</div>
	<!-- //footer -->
</div>
	<!-- Hidden값 -->
	<input type="hidden" name="message" value="${message}">
	<input type="hidden" name="userSe"  value="GNR"/>
    <input type="hidden" name="j_username" />
</form>

</body>
</html>


