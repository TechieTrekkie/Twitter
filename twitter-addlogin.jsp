<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.security.*" %>

<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%@ page import="javax.xml.bind.DatatypeConverter" %>

<%@ page import="org.apache.commons.codec.binary.DigestUtils.*" %>
<%@ page import="org.apache.commons.codec.binary.*" %>
<%@ page import="org.apache.commons.codec.digest.*" %>

<!DOCTYPE html>
<html lang="en">
<%
	
 	//HttpSession session=request.getSession();
 	//session.setAttribute("email", emailid);
	//String email=(String)session.getAttribute("email");
	
	String full_name = new String();
	String email = new String();
	String password = new String();
	String username = new String();
	
	full_name = request.getParameter("full-name");
	email = request.getParameter("email");
	password = request.getParameter("password");
	username = request.getParameter("username").toLowerCase();
	
	Pattern pattern;
	Matcher matcher;

	String EMAIL_PATTERN = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}";

	pattern = Pattern.compile(EMAIL_PATTERN);

	matcher = pattern.matcher(email);
	
	boolean allowProceed=true;
	
	char[] full_name_array = full_name.toCharArray();
	for(char c:full_name_array)
	{
		if(c!=' '&&!Character.isLetterOrDigit(c))
		{
			out.println("Name Error2");
			allowProceed=false;
		}
	}
	
	char[] username_array = username.toCharArray();
	for(char c:username_array)
	{
		if(!Character.isLetterOrDigit(c))
		{
			out.println("Username Error");
			allowProceed=false;
		}
	}
	
	if(username.length()==0 || username.length()>15)
	{
		out.println("Username Error");
    	allowProceed=false;
    }
	
	if(full_name.length()==0 || full_name.length()>30)
	{
		out.println("Name Error");
    	allowProceed=false;
    }
    	
    if(matcher.matches())
    {
		out.println("Email Error");

		allowProceed=false;
    }
    try
    {
    if(password.length()<6)
    {
		out.println("Password Error");
    	allowProceed=false;
    }
	} catch(Exception ex){
	}
	String salt=null;


	java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/dazzam_twitter";   //location and name of database
    String userid = "dazzam";
    
    Scanner in = new Scanner(new FileReader("/home/dazzam/public_html/twitter_dir/SQL_Login.txt"));
    String DBpassword=in.nextLine();
    
    conn = DriverManager.getConnection(url, userid, DBpassword);      //connect to database

	/**********************************************************************/
	//Get salt for person
	
	SecureRandom randGen=SecureRandom.getInstance("SHA1PRNG", "SUN");

	byte[] output = new byte[24];
	randGen.nextBytes(output);
	String encodedSalt = DatatypeConverter.printBase64Binary(output);
    /**********************************************************************/
    
	String getUsernamesQuery = "SELECT username FROM login_t;";
    java.sql.PreparedStatement getUsernamesPS = conn.prepareStatement(getUsernamesQuery); // create a statement
    java.sql.ResultSet getUsernamesRS = getUsernamesPS.executeQuery();
    
    while (getUsernamesRS.next())    // extract data from the ResultSet
    {
    	if(username==getUsernamesRS.getString("username"))
    	{
    		allowProceed=false;
    	}
    }
    	
	/**********************************************************************/
	
    //Get hashed Salt and Password
		String base = encodedSalt+password;
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
    	
    	
    	if(allowProceed)
    	{
    	    //Insert tweet into database
			String addLoginQuery = "INSERT INTO login_t (full_name,email,username,password,salt, salted_password) VALUES (?,?,?,?,?,?);";
			java.sql.PreparedStatement addLoginPS = conn.prepareStatement(addLoginQuery); // create a statement
			addLoginPS.setString(1, full_name); // set input parameter
			addLoginPS.setString(2, email); // set input parameter
			addLoginPS.setString(3, username); // set input parameter
			addLoginPS.setString(4, password); // set input parameter
			addLoginPS.setString(5, encodedSalt); // set input parameter
			addLoginPS.setString(6, hashedPass); // set input parameter
			addLoginPS.executeUpdate();
			
			response.sendRedirect("twitter-verifylogin.jsp?login-param="+username+"&login-password="+password);
    	}
    	else
    	{
    		out.println("FAIL");
    	}
	    
%>
