package com.dpt.demo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.websocket.Session;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class login {

	@Value("${spring.datasource.url}")
	private String url;

	@Value("${spring.datasource.username}")
	private String DBusername;

	@Value("${spring.datasource.password}")
	private String DBpassword;

	private String userId = "";

	private String errorMessage="";
	
	@RequestMapping(value = "login", method = RequestMethod.POST)
	public ModelAndView login(String userName, String password) throws ClassNotFoundException {

		
		Class.forName("com.mysql.jdbc.Driver");
		// validate user credentials
		String query = "select * from Employee where username='" + userName + "' and password='"+password+"'";
		try (Connection con = DriverManager.getConnection(url, DBusername, DBpassword);
				Statement st = con.createStatement();
				ResultSet rs = st.executeQuery(query)) {
			if (rs.next()) {
				System.out.println(
						rs.getString(1) + " " + rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4));
				userId = rs.getString(4);
			}
		} catch (SQLException ex) {
			System.out.println(ex.getMessage());
			errorMessage=ex.getMessage();
		}

		ModelAndView mv;
		if (userId != "")
		{			
			mv = new ModelAndView("user");
			mv.addObject("username", userId);
		}
		else
		{
			
			mv = new ModelAndView("login");
			mv.addObject("errorMessage", errorMessage);
		}

		return mv;
	}
	
	
	
	@RequestMapping(value = "login", method = RequestMethod.GET)
	public ModelAndView registerform()
	{
		ModelAndView mv=new ModelAndView("login");
		
		return mv;		
	}

}
