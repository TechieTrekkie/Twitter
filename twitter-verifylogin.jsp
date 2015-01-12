<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.security.*" %>

<%@ page import="org.apache.commons.codec.binary.DigestUtils.*" %>
<%@ page import="org.apache.commons.codec.binary.*" %>
<%@ page import="org.apache.commons.codec.digest.*" %>

<!DOCTYPE html>
<html lang="en">
<%
	
 	//HttpSession session=request.getSession();
 	//session.setAttribute("email", emailid);
	//String email=(String)session.getAttribute("email");
	
	String login_param = request.getParameter("login-param");
	String login_password = request.getParameter("login-password");
	
	int numItems = 0;
	String salt=null;
	String login_ID = null;


	java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/dazzam_twitter";   //location and name of database
    String userid = "dazzam";
    
    Scanner in = new Scanner(new FileReader("/home/dazzam/public_html/twitter_dir/SQL_Login.txt"));
    String password=in.nextLine();
    
    conn = DriverManager.getConnection(url, userid, password);      //connect to database

	/**********************************************************************/
	//Get salt for person
	
	String getSaltQuery = "SELECT salt FROM login_t WHERE (username=? OR email=?)";

    java.sql.PreparedStatement getSaltPS = conn.prepareStatement(getSaltQuery); // create a statement
    getSaltPS.setString(1, login_param); // set input parameter
    getSaltPS.setString(2, login_param); // set input parameter
    
    java.sql.ResultSet getSaltRS = getSaltPS.executeQuery();
    
    while (getSaltRS.next())    // extract data from the ResultSet
    {
    	salt = getSaltRS.getString("salt");
    }

    /**********************************************************************/

	//Check verify login
    String getLoginInfoQuery = "SELECT count(*), login_ID FROM login_t WHERE (username=? OR email=?) AND salted_password=?";

    java.sql.PreparedStatement getLoginInfoPS = conn.prepareStatement(getLoginInfoQuery); // create a statement
    getLoginInfoPS.setString(1, login_param); // set input parameter
    getLoginInfoPS.setString(2, login_param); // set input parameter
    
    /****************************/
    //Get hashed Salt and Password
		String base = salt+login_password;
		String hashedPass=null;
		try{
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(base.getBytes("UTF-8"));
			StringBuffer hexString = new StringBuffer();

			for (int i = 0; i < hash.length; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if(hex.length() == 1) hexString.append('0');
				hexString.append(hex);
			}

			hashedPass=hexString.toString();
		} catch(Exception ex){
			throw new RuntimeException(ex);
		}
	/****************************/	
		
    getLoginInfoPS.setString(3, hashedPass); // set input parameter
    
    java.sql.ResultSet getLoginInfoRS = getLoginInfoPS.executeQuery();
    
    while (getLoginInfoRS.next())    // extract data from the ResultSet
    {
    	numItems = getLoginInfoRS.getInt("count(*)");
    	login_ID = getLoginInfoRS.getString("login_ID");
    }
    
    if(numItems==1)
    {
    	//Good
    	out.println("success");
    	session.setAttribute("id", login_ID);
    	
    	/**********************************************************************/

		//Get Username from login_ID
    	String getUsernameQuery = "SELECT username FROM login_t WHERE login_ID = ?";
	
    	java.sql.PreparedStatement getUsernamePS = conn.prepareStatement(getUsernameQuery); // create a statement
    	getUsernamePS.setString(1, login_ID); // set input parameter
    	java.sql.ResultSet getUsernameRS = getUsernamePS.executeQuery();
    
    	while (getUsernameRS.next())    // extract data from the ResultSet
    	{
    		String username = getUsernameRS.getString("username");

    		session.setAttribute("username", username);
    	}
    
    	/**********************************************************************/
    	
    	//Get Full Name from tweeter_ID
    	String getFullNameQuery = "SELECT full_name FROM login_t WHERE login_ID = ?";
    	
    	java.sql.PreparedStatement getFullNamePS = conn.prepareStatement(getFullNameQuery); // create a statement
    	getFullNamePS.setString(1, login_ID); // set input parameter
    	java.sql.ResultSet getFullNameRS = getFullNamePS.executeQuery();
    	while (getFullNameRS.next())    // extract data from the ResultSet
    	{
    		String full_name = getFullNameRS.getString("full_name");
    		
    		session.setAttribute("full_name", full_name);
    	}    		
    				
    	/**********************************************************************/
    
    
    	response.sendRedirect("twitter-home.jsp"); 
    }
    else
    {
    	//Bad Login
	    out.println("fail");
	    out.println(salt);
	    out.println(login_password);
	    out.println(hashedPass);
    }
%>
