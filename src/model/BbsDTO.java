package model;

import java.sql.Date;

public class BbsDTO {
	/*
	DTO객체를 만들때 테이블 컬럼의 타입과는 상관없이 대부분의 멤버변수는 
	String형으로 정의하면된다.
	JSP에서 산술연산이 꼭 필요한 경우에만 int, double과 같이 숫자형으로 정의한다.
	*/
	private String num;		//게시판의 일련번호
	private String title;	//제목
	private String content;	//내용
	private String id;			//작성자아이디(member테이블참조)
	private java.sql.Date postDate;	//작성일
	private String visitcount;	//조회수
	//멤버변수추가 : board와 member테이블의 join을 위해 name추가
	private String name;
	//멀티게시판 구현을 위한 멤버변수 추가 : bname(게시판을 구분하기위한플래그컬럼)
	private String bname;
	
	

	public BbsDTO() {}
	
	
	public BbsDTO(String num, String title, String content, String id, Date postDate, String visitcount, String name) {
		super();
		this.num = num;
		this.title = title;
		this.content = content;
		this.id = id;
		this.postDate = postDate;
		this.visitcount = visitcount;
		this.name = name;
	}
	
	
	
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public java.sql.Date getPostDate() {
		return postDate;
	}
	public void setPostDate(java.sql.Date postDate) {
		this.postDate = postDate;
	}
	public String getVisitcount() {
		return visitcount;
	}
	public void setVisitcount(String visitcount) {
		this.visitcount = visitcount;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getBname() {
		return bname;
	}
	public void setBname(String bname) {
		this.bname = bname;
	}
	
	
	
	
}
