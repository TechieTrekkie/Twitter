<%@ page language="java" %>
<%@ page import="java.lang.Runtime"%>
<%@ page import="java.lang.Process"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
	    	java.sql.Connection conn = null;
                ServletContext context = getServletContext();
        	String directory = "";
                String name = "";
		String tile_text_file = "";
		String fn = "";
/*                
 		Class.forName("com.mysql.jdbc.Driver").newInstance();
                String url = "jdbc:mysql://127.0.0.1/jemma_twitter";

                String id = "jemma";
                String pwd = "dalton";
		String user= request.getParameter("user"); 
		int status =0;

                conn = DriverManager.getConnection(url, id, pwd);
		java.sql.Statement stmt = conn.createStatement();
		java.sql.PreparedStatement ps = conn.prepareStatement("update jemma_twitter.TwitterUsers set icon=(?) where UserID=(?)");						//used at the filename and inside the database			

*/

 //      	MultipartRequest multi = new MultipartRequest(request, context.getRealPath(directory) + "/dwitter/userimages", 5 * 1024 * 1024);
       	MultipartRequest multi = new MultipartRequest(request, context.getRealPath(directory) + "/ups/images", 5 * 1024 * 1024);
                Enumeration files = multi.getFileNames();
		
        	while (files.hasMoreElements())
        	{
                name = (String)files.nextElement();
 		fn = multi.getFilesystemName(name);
		}

		//ps.setString(1,fn);
		//ps.setString(2,user);

		//status = ps.executeUpdate();
		
		String redirectURL="";
//		if(status>0) redirectURL="twitter-home.jsp?UserID="+user;
//		response.sendRedirect(redirectURL); 
%>
