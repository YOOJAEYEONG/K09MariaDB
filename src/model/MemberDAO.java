package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class MemberDAO {
	
	//멤버변수(클래스전체 멤버메소드에 접근가능)
	Connection con;	// 데이터 베이스와 연결을 위한 객체
	PreparedStatement psmt; 
	ResultSet rs;	// SQL & DB 질의에 의해 생성된 테이블을 저장하는 객체입니다.
	//Statement stmt;	// SQL 문을 데이터베이스에 보내기위한 객체
	
	//기본생성자
	public MemberDAO() {
		System.out.println("MemberDAO생성자호출");
	}
	public MemberDAO(String diver, String url) {
		
		try {
			//드라이버로드
			Class.forName(diver);
			String id = "kosmo61_user";
			String pw = "1234";
			
			con = DriverManager.getConnection(url, id, pw);
			System.out.println("DB연결 성공");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//방법1 : 회원의 존재 유무만 판단한다.
	public boolean isMember(String id, String pass) {
		
		//COUNT()의 실행결과 결과가 없으면 0을 반환한다. 
		//COUNT() => 0, 1, ~~~~99의 다중값 반환할 것임
		String sql = "SELECT COUNT(*) FROM member " +
				" WHERE id=? AND pass=? ";
		int isMember = 0;
		boolean isFlag = false;
		
		try {
			//prepare 객체로 쿼리문 전송
			psmt = con.prepareStatement(sql);
			//인파라미터 설정
			psmt.setString(1,id);
			psmt.setString(2,pass);
			//쿼리 실행
			rs = psmt.executeQuery();
			//실행된 결과를 가져오기위해 next()호출
			rs.next();/*여기서는 결과유무에 따라 true,false를 반환하고
				여기서는 count()함수를 썼기 때문에 무조건 0 또는 0이상의 값을 반환하게 된다.
			*/
			isMember = rs.getInt(1);
			System.out.println("afftected:"+ isMember);
			
			if(isMember==0)	isFlag = false;
			else			isFlag = true;
			
		} catch (Exception e) {
			isFlag = false;
			e.printStackTrace();
		}
		return isFlag;
	}
	
	
	
	
	//방법2 : 회원 인증후 MemberDTO객체로 회원정보를 반환한다.
	public MemberDTO getMemberDTO(String uid, String upass) {
		//DTO객체를 생성한다.
		MemberDTO memberDTO = new MemberDTO();
		
		String query = "SELECT id, pass, name FROM member " +
				" WHERE id=? AND pass=? ";
		
		try {
			//prepared 객체 생성
			psmt = con.prepareStatement(query);
			//쿼리문에 인파라미터 설정
			psmt.setString(1, uid);
			psmt.setString(2, upass);
			
			//오라클로 쿼리문 전송 및 실행결과를 ResultSet으로 반환받음;
			//지금상태에서는 결과유무를 모른다.
			rs = psmt.executeQuery();//SQL 질의 결과를 ResultSet에 저장합니다.
			
			/*
			실행된 결과를 가져오기위해 next()호출
			-결과가 1 개인 경우
				if(rs.next()) { }
			-결과가 2개 이상인 경우
				while(rs.next()) { }
				
				rs.next() : 반환된 레코드 한줄으 읽어온다 . 결과값이 여러개일경우 
				while()을통해 여러줄을 읽어온다.
			 */
			
			//오라클이 반환해준 ResultSet이 있는지 확인
			if(rs.next()) {
				// 이 함수에서 객체를 반환하는 이유?
				//  함수는 하나의 값많을 반황할 수 있기 때문에 회원 레코드의 여러 값을 
				//  객체로 만들어 반환하는 것이다.
				
				memberDTO.setId(rs.getString("id"));
				memberDTO.setPass(rs.getString("pass"));
				memberDTO.setName(rs.getString(3));//3번컬럼(오라클인덱스는1부터)
				//getter사용에서 컬럽 순서지정과 컬럽네임으로 얻어오는 방법에 주시
			}
			else {
				System.out.println("결과 셋이 없습니다.");
			}
		} catch (Exception e) {
			System.out.println("getMenberDTO오류:");
			e.printStackTrace();
		}
		return memberDTO;
	}
	
	
	//방법3 : 회원 인증후 MemberDTO객체로 회원정보를 반환한다.
	public Map<String, String> getMemberMap(String id, String pwd) {
		
		Map<String, String> maps = new HashMap<String, String>();
		
		String query = "SELECT id, pass, name FROM member " +
				" WHERE id=? AND pass=? ";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			psmt.setString(2, pwd);
	
			rs = psmt.executeQuery();
			
			if(rs.next()) {
				maps.put("id", rs.getString("id"));
				maps.put("pass", rs.getString("pass"));
				maps.put("name", rs.getString(3));
			}
			else {
				System.out.println("결과 맵이 없습니다.");
			}
		} catch (Exception e) {
			System.out.println("getMenberDTO오류:");
			e.printStackTrace();
		}
		return maps;
	}
}

























