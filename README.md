# 배치운영환경

개발된 배치 job을 등록 및 실행하고 실행현황을 모니터링하며 처리결과를 확인하기 위한 전자정부 표준프레임크의 배치 운영환경이다.

- 배치운영환경 소개, 설치, 가이드 그리고 원격지 운영에 관한 설명은 아래를 참조한다.
  https://www.egovframe.go.kr/wiki/doku.php?id=egovframework:bopr
- 본 프로젝트는 다음 URL의 설치방법대로 생성한 소스이다.
  https://www.egovframe.go.kr/wiki/doku.php?id=egovframework:bopr:%EC%84%A4%EC%B9%98

본 프로젝트에서 다음과 같은 순서로 추가 작업을 진행한다.

## 1. 데이터베이스 설정

src/main/resources/egovframework/egovProps/ 경로의 globals.properties 파일에서 데이터베이스 설정을 한다.
DBA와 협조 하에 설정한다.

```
#oracle
Globals.DriverClassName=oracle.jdbc.driver.OracleDriver
Globals.Url=jdbc:oracle:thin:@127.0.0.1:1521:bopr
Globals.UserName = root
Globals.Password =
```

## 2. 데이터베이스 스키마 생성

데이터베이스에 접속하여 Schema 를 다음과 같은 순서로 실행한다.
생성 스크립트는 src/script/oracle/ 에 존재한다.

1. schema-create-oracle.sql
2. bopr_create_oracle.sql
3. schema-insert-oralce.sql
4. bopr_insert_oracle.sql

## 3. 배치 운영 시스템 기동

1. 톰켓 서버에 올려 기동한다.
2. 브라우저를 실행시켜 서버에 접속한다. 아이디는 admin 비밀번호는 qwerqwer 이다.

## 4. FTP 설정

job xml 파일을 등록할 때 ftp 전송으로 하기 때문에 ftp 서버가 설치 구동되어 있으야 한다.
ftp 서버가 구동되어 있으면 다음 화면에서 job 배포경로를 지정해 주어야 한다.

- 관리자 메뉴 > 연동 서비스 관리 > FTP 연동 서비스 를 선택
- ftp 연동 등록 또는 수정하여 사용자ID, 비밀번호 그리고 배포경로를 입력 후 저장한다.

## 5. job 등록

다음 url을 참고하여 job을 등록한다.

- https://www.egovframe.go.kr/wiki/doku.php?id=egovframework:bopr:%EA%B0%80%EC%9D%B4%EB%93%9C:%EB%B0%B0%EC%B9%98%EC%A0%95%EB%B3%B4:%EB%B0%B0%EC%B9%98%EC%A0%95%EB%B3%B4%EA%B4%80%EB%A6%AC

## 6. 기타사항

스케쥴관리 및 기타 모니터링 관련한 사항은 아래 url을 참고한다.

- https://www.egovframe.go.kr/wiki/doku.php?id=egovframework:bopr

# 배치 운영 시스템 JBOSS 서버로 배포

본 프로젝트를 JBOSS 서버로 배포할 때 유의사항은 다음과 같다.

## 1. 전자정부 표준프레임워크 pom.xml

전자정부 표준프레임워크를 적용한 웹애플리케이션을 빌드할 때 spring-modules-validation 버전을 명시하도록 pom.xml을 수정한다.

```
	<dependencies>
		<!-- 표준프레임워크 실행환경 -->
    <dependency>
			<groupId>egovframework.rte</groupId>
			<artifactId>egovframework.rte.ptl.mvc</artifactId>
			<version>${egovframework.rte.version}</version>
			<exclusions>
				<exclusion>
					<artifactId>commons-logging</artifactId>
					<groupId>commons-logging</groupId>
				</exclusion>
				<exclusion>
					<artifactId>spring-modules-validation</artifactId>
					<groupId>org.springmodules</groupId>
				</exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>egovframework.rte</groupId>
			<artifactId>spring-modules-validation</artifactId>
			<version>0.9</version>
		</dependency>
```

## 2. jboss-web.xml 추가 (옵션 사항임)

/webapp/WEB-INF/jboss-web.xml 파일을 추가하여 빌드한다.

```
<!-- jboss-web.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
	<context-root>/</context-root>
</jboss-web>
```

위와 같이 설정된 애플리케이션은 http://127.0.0.1:8080/ 으로 접근할 수 있다.

```
<!-- jboss-web.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
	<context-root>/demo</context-root>
</jboss-web>
```

위와 같이 설정된 애플리케이션은 http://127.0.0.1:8080/demo 로 접근할 수 있다.

## 3. JBOSS EAP 7.x 또는 Wildfly 적용 시 오류 대처 방안

### 3-1. 로그인페이지로 이동 시 발생하는 NullPointerException

#### 분석 및 검토
- 표준프레임워크 포털 Q&A 에 문의하였었던 내용과 동일하다
  https://www.egovframe.go.kr/home/qainfo/qainfoRead.do?menuNo=69&qaId=QA_00000000000017320
- context-egovuserdetailshelper.xml 에서 여러 beans 에서 참조하는 egovUserDetailsService 인스턴스가 null 인 것으로 판단된다.

```
18:39:34,132 ERROR [io.undertow.request] (default task-3) UT005023: Exception handling request to /uat/uia/egovLoginUsr.do: java.lang.NullPointerException
	at deployment.egovFrameWork_BOPR-webapp.war//egovframework.com.cmm.util.EgovUserDetailsHelper.getAuthenticatedUser(EgovUserDetailsHelper.java:44)
	at deployment.egovFrameWork_BOPR-webapp.war//egovframework.com.sec.security.filter.EgovSpringSecurityLoginFilter.doFilter(EgovSpringSecurityLoginFilter.java:86)
	at io.undertow.servlet@2.2.8.Final//io.undertow.servlet.core.ManagedFilter.doFilter(ManagedFilter.java:61)
	at io.undertow.servlet@2.2.8.Final//io.undertow.servlet.handlers.FilterHandler$FilterChainImpl.doFilter(FilterHandler.java:131)
	at deployment.egovFrameWork_BOPR-webapp.war//org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:317)
```

- context-egovuserdetailshelper.xml 에 egovUserDetailsSecurityService 가 정의되어 있다.

```
<!-- 2. 스프링 시큐리티를 이용한 인증을 사용할 빈 -->
<!-- 3.시큐리티(Security) 인증  -->
<beans profile="security">
	<!--인증된 유저의 LoginVO, 권한, 인증 여부를 확인 할 수있는 서비스 클래스-->
	<bean id="egovUserDetailsHelper" class="egovframework.com.cmm.util.EgovUserDetailsHelper">
        <property name="egovUserDetailsService" ref="egovUserDetailsSecurityService" />
    </bean>
    <!-- 2. 스프링 시큐리티를 이용한 인증을 사용할 빈 -->
    <bean id="egovUserDetailsSecurityService" class="egovframework.com.sec.ram.service.impl.EgovUserDetailsSecurityServiceImpl"/>
</beans>
```

- EgovUserDetailsSecurityServiceImpl.java > getAuthenticatedUser

```
public class EgovUserDetailsSecurityServiceImpl extends EgovAbstractServiceImpl implements EgovUserDetailsService {

	@Override
	public Object getAuthenticatedUser() {

		// 이 메소드의 경우 인증이 되지 않더라도 null을 리턴하지 않기 때문에
		// 명시적으로 인증되지 않은 경우 null을 리턴하도록 수정함
		if (EgovUserDetailsHelper.isAuthenticated()) {
			return EgovUserDetailsHelper.getAuthenticatedUser();
		}

		return null;
	}

	@Override
	public List<String> getAuthorities() {
		return EgovUserDetailsHelper.getAuthorities();
	}

	@Override
	public Boolean isAuthenticated() {
		return EgovUserDetailsHelper.isAuthenticated();
	}

}
```

#### 해결 방법

EgovSpringSecurityLoginFilter.java 에서 EgovUserDetailsHelper.getAuthenticatedUser() 에서 null 을 리턴하기 때문으로 requestURL.contains(loginURL) 로 대체한다.

```
		//System.out.println(">>>>> EgovUserDetailsHelper.getAuthenticatedUser()="+EgovUserDetailsHelper.getAuthenticatedUser());
		//System.out.println(">>>>> EgovUserDetailsHelper.isAuthenticated()::::::"+EgovUserDetailsHelper.isAuthenticated());
		if (requestURL.contains(loginURL) || requestURL.contains(loginProcessURL)) {
			
			if(isRemotelyAuthenticated != null && isRemotelyAuthenticated.equals("true")){
```

디버깅하여 BatchBoprMainController 의 selectMainList 메소드에 break point를 걸어보면 EgovUserDetailsHelper.isAuthenticated() 와 EgovUserDetailsHelper.getAuthenticatedUser() 가 null로 리턴된다.
null 이 되는 원인을 살펴보면 해결할 수 있을 것이다.

```
    @RequestMapping(value = "/main/Main.do")
    public String selectMainList(@ModelAttribute("mainVO") MainVO mainVOTmp, final HttpServletRequest request, ModelMap model) throws Exception {

    	MainVO mainVO = mainVOTmp;
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	if (isAuthenticated) {
    		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
        	
        	mainVO.setUserId(loginVO.getId());
    		/** 설정정보 읽어오기 **/
        	mainVO = mainService.selectSetupInfo(mainVO); 
```