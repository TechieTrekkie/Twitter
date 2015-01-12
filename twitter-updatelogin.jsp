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

	username = request.getParameter("username").toLowerCase();
	full_name = request.getParameter("full-name");
	email = request.getParameter("email");
	phone = request.getParameter("phone");
	birth_date = request.getParameter("birth_date");
	profile_text = request.getParameter("profile_text");
	avatar=request.getParameter("avatar");

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
    	/*

    String contentType = request.getContentType();
out.println("Content type is :: " +contentType);
//if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) {
DataInputStream in = new DataInputStream(request.getInputStream());
int formDataLength = request.getContentLength();
out.println(formDataLength);
byte dataBytes[] = new byte[formDataLength];
int byteRead = 0;
int totalBytesRead = 0;
while (totalBytesRead < formDataLength) {
byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
totalBytesRead += byteRead;
}

String file = new String(dataBytes);
String saveFile = file.substring(file.indexOf("filename=\"") + 10);
saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1,saveFile.indexOf("\""));

//out.print(dataBytes);

int lastIndex = contentType.lastIndexOf("=");
String boundary = contentType.substring(lastIndex + 1,contentType.length());
//out.println(boundary);
int pos;
pos = file.indexOf("filename=\"");

pos = file.indexOf("\n", pos) + 1;

pos = file.indexOf("\n", pos) + 1;

pos = file.indexOf("\n", pos) + 1;


int boundaryLocation = file.indexOf(boundary, pos) - 4;
int startPos = ((file.substring(0, pos)).getBytes()).length;
int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;

FileOutputStream fileOut = new FileOutputStream(saveFile);


//fileOut.write(dataBytes);
fileOut.write(dataBytes, startPos, (endPos - startPos));
fileOut.flush();
fileOut.close();

out.println("File saved as " +saveFile);

//}*/
    	
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
			
			response.sendRedirect("twitter-settings.jsp");
			
    	}
    	else
    	{
    		out.println("FAIL");
    	}
	    
%>
