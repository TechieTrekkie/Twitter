<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html lang="en">
<%
    //HttpSession session=request.getSession();
    //session.setAttribute("email", emailid);
    //String email=(String)session.getAttribute("email");

    String followed_ID = request.getParameter("followed_id");
    String login_ID = (String)session.getAttribute("id");
    //request.getParameter("id");
    String referer = request.getParameter("referer");
    
    java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/dazzam_twitter";   //location and name of database
    String userid = "dazzam";
    
    Scanner in = new Scanner(new FileReader("/home/dazzam/public_html/twitter_dir/SQL_Login.txt"));
    String password=in.nextLine();
    
    conn = DriverManager.getConnection(url, userid, password);      //connect to database

    /**********************************************************************/

    String timesFollowed=null;

    String checkIfFollowedQuery = "SELECT count(*) FROM following_t WHERE followed_ID = ? AND follower_ID = ?;";
    java.sql.PreparedStatement checkIfFollowedPS = conn.prepareStatement(checkIfFollowedQuery); // create a statement
    checkIfFollowedPS.setString(1, followed_ID); // set input parameter
    checkIfFollowedPS.setString(2, login_ID); // set input parameter
    java.sql.ResultSet checkIfFollowedRS = checkIfFollowedPS.executeQuery();
    while (checkIfFollowedRS.next())    // extract data from the ResultSet
    {
        timesFollowed = checkIfFollowedRS.getString("count(*)");
    }

    if(timesFollowed.equals("0"))//If not followed yet, follow
    {
        String addFollowerQuery = "INSERT INTO following_t (followed_ID,follower_ID) VALUES (?,?);";
        java.sql.PreparedStatement addFollowerPS = conn.prepareStatement(addFollowerQuery); // create a statement
        addFollowerPS.setString(1, followed_ID); // set input parameter
        addFollowerPS.setString(2, login_ID);
        addFollowerPS.executeUpdate();
    }
    else//If already followed, unfollow
    {
        String removeFollowerQuery = "DELETE FROM following_t WHERE followed_ID=? AND follower_ID=?;";
        java.sql.PreparedStatement removeFollowerPS = conn.prepareStatement(removeFollowerQuery); // create a statement
        removeFollowerPS.setString(1, followed_ID); // set input parameter
        removeFollowerPS.setString(2, login_ID);
        removeFollowerPS.executeUpdate();
    }
    out.println(referer);
    response.sendRedirect(referer);
%>
