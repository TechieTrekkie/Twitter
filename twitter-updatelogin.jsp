<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.security.*" %>
<%@ page import="java.awt.image.BufferedImage" %>

<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%@ page import="javax.xml.bind.DatatypeConverter" %>

<%@ page import="org.apache.commons.codec.binary.DigestUtils.*" %>
<%@ page import="org.apache.commons.codec.binary.*" %>
<%@ page import="org.apache.commons.codec.digest.*" %>

<%@ page import="java.lang.Runtime"%>
<%@ page import="java.lang.Process"%>

<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.imageio.ImageIO" %>

<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<!DOCTYPE html>
<html lang="en">
<%
	
 	//HttpSession session=request.getSession();
 	//session.setAttribute("email", emailid);
	//String email=(String)session.getAttribute("email");
	
	String login_ID = (String)session.getAttribute("id");
    
    String username = null;
    String full_name = null;
    String email=null;
    String phone=null;
    String birth_date=null;
    String profile_text=null;
    String avatar=null;

    //out.println(request.getInputStream());
    if(login_ID==null)
    {
        response.sendRedirect("twitter-signin.jsp");
    }

    ServletContext context = getServletContext();
	String directory = "";
	String tile_text_file = "";
	String name = "";
	String fn = "";

	MultipartRequest multi = new MultipartRequest(request, context.getRealPath(directory) + "/twitter_dir/images/avatars/uploadTemp", 1500 * 1024 * 1024);

	//MultipartRequest multi = new MultipartRequest(request, context.getRealPath(directory) + "/ups/images", 5 * 1024 * 1024);
                

	Enumeration files = multi.getFileNames();
		
    //while (files.hasMoreElements())
    //{
        //name = (String)files.nextElement();
 		//fn = multi.getFilesystemName(name);
		//String dude = multi.getParameter("user");	
		//out.println(dude);
	//}
	File imageFile = multi.getFile("avatar");

	username = multi.getParameter("username").toLowerCase();
	full_name = multi.getParameter("full-name");
	email = multi.getParameter("email");
	phone = multi.getParameter("phone");
	birth_date = multi.getParameter("birth_date");
	profile_text = multi.getParameter("profile_text");
	avatar=multi.getParameter("avatar");

	if(birth_date==null||birth_date.equals(""))
    {
		birth_date="1960-01-01";
	}
	
	out.println("<br>Username: "+username);
	out.println("<br>Full_name: "+full_name);
	out.println("<br>Email: "+email);
	out.println("<br>Phone: "+phone);
	out.println("<br>Birth_date: "+birth_date);
	out.println("<br>Profile_text: "+profile_text);
	out.println("<br>Avatar: "+avatar);

	Pattern pattern;
	Matcher matcher;

	String EMAIL_PATTERN = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}";

	pattern = Pattern.compile(EMAIL_PATTERN);

	matcher = pattern.matcher(email);
	
	boolean allowProceed=true;
	if(matcher.matches())//Verify Email
    {
		out.println("Email Error");

		allowProceed=false;
    }

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

    if(profile_text.length()>140)
	{
		out.println("Name Error");
    	allowProceed=false;
    }
	
	if(full_name.length()==0 || full_name.length()>30)
	{
		out.println("Name Error");
    	allowProceed=false;
    }


	java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/dazzam_twitter";   //location and name of database
    String userid = "dazzam";
    
    Scanner scan = new Scanner(new FileReader("/home/dazzam/public_html/twitter_dir/SQL_Login.txt"));
    String DBpassword=scan.nextLine();
    
    conn = DriverManager.getConnection(url, userid, DBpassword);      //connect to database

	/**********************************************************************/
    	///*

    //ServletContext context = getServletContext();
	//String directory = "";
	//String tile_text_file = "";
    //String name = "";
	//String fn = "";

	//MultipartRequest multi = new MultipartRequest(request, context.getRealPath(directory) + "/ups/images", 5 * 1024 * 1024);
                

	//Enumeration files = multi.getFileNames();
		
    //while (files.hasMoreElements())
    //{
    //    name = (String)files.nextElement();
 	//	fn = multi.getFilesystemName(name);
	//	String dude = multi.getParameter("user");	
	//	out.println(dude);
	//}

		//*/
    	if(allowProceed)
    	{
    		out.println("Success");
    	    //Insert tweet into database
    	    
			String updateLoginQuery = "UPDATE login_t SET username=?, full_name=?, email=?, phone=?, birth_date=?, profile_text=? WHERE login_ID=?;";
			java.sql.PreparedStatement updateLoginPS = conn.prepareStatement(updateLoginQuery); // create a statement
			updateLoginPS.setString(1, username); // set input parameter
			updateLoginPS.setString(2, full_name); // set input parameter
			updateLoginPS.setString(3, email); // set input parameter
			updateLoginPS.setString(4, phone); // set input parameter
			updateLoginPS.setString(5, birth_date); // set input parameter
			updateLoginPS.setString(6, profile_text); // set input parameter
			updateLoginPS.setString(7, login_ID); // set input parameter
			updateLoginPS.executeUpdate();

			if(!(imageFile==null))
			{
				String extension = "";
				int i = imageFile.getName().lastIndexOf('.');
				if (i > 0)
				{
    				extension = imageFile.getName().substring(i+1);
				}
	
				out.println(extension);
				File newImage=new File(context.getRealPath(directory) + "/twitter_dir/images/avatars/"+login_ID+"."+extension);
				
        		if (imageFile.exists())
        		{
            		imageFile.renameTo(newImage);
            		newImage.setReadable(true, false);
            		if(true)
            		{
            			//File jpgNewImage = new File(context.getRealPath(directory) + "/twitter_dir/images/avatars/"+login_ID+".jpg");
            			BufferedImage img = ImageIO.read(newImage);
            			int squareMaxLength=Math.min(img.getHeight(), img.getWidth());
            			img=img.getSubimage((img.getWidth()-squareMaxLength)/2, (img.getHeight()-squareMaxLength)/2, squareMaxLength, squareMaxLength);
            			ImageIO.write(img, "PNG", new File(context.getRealPath(directory) + "/twitter_dir/images/avatars/"+login_ID+".jpg"));
            			newImage.delete();
            			out.println(Arrays.toString(ImageIO.getWriterFormatNames()));
            			//jpgNewImage.setReadable(true, false);
            		}
            	}
            }
			response.sendRedirect("twitter-settings.jsp");
			
    	}
    	else
    	{
    		out.println("FAIL");
    		response.sendRedirect("twitter-settings.jsp");
    	}
	    
%>
