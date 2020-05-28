package model;

import java.sql.Date;
/*
 * DTO (Data Trasfer Object)
 * 	: 데이터를 저장하기위한 객체로 멤버변수, 생성자, getter/ setter
 * 	메소드를 가지고 있는 클래스로 일반적인 자바빈(Bean)규약을 따른다.
 * 	***자바빈 : 00.JSP&Servlet 참고
 */
public class MemberDTO {
	//멤버변수 : 정보은닉을 위해 private으로 선언함.
	private String id;
	private String pass;
	private String name;
	private java.sql.Date regidate;
	public MemberDTO() {}
	public MemberDTO(String id, String pass, String name, Date regidate) {
		this.id = id;
		this.pass = pass;
		this.name = name;
		this.regidate = regidate;
	}
	
	
	public void setId(String id)		{	this.id = id;		}
	public void setPass(String pass)	{	this.pass = pass;	}
	public void setName(String name)	{	this.name = name;	}
	public void setRegidate(java.sql.Date regidate) {
		this.regidate = regidate;
	}
	
	
	
	public String getId()	{	return id;		}
	public String getPass()	{	return pass;	}
	public String getName()	{	return name;	}
	public java.sql.Date getRegidate()	{	return regidate;	}
	
	/*
	 * Object클래스에서 제공하는 메소드로 객체를 문자열 형태로 변형해서
	 * 반환해주는 역할을 한다. toString()을 오버라이딩 하면
	 * 객체 자체를 그대로 print()하는것이 가능하다.
	 */
	@Override
	public String toString() {
		return String.format("아이디:%s, 비밀번호:%s, 이름:%s",
				id, pass, name);
	}
}
