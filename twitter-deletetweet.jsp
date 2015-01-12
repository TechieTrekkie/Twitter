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

    String tweet_ID = request.getParameter("tweet_id");
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

    String tweetTweeter_ID=null;

    String getTweetTweeterQuery = "SELECT tweeter_ID FROM tweets_t WHERE tweet_ID=?;";//Get person who actually tweeted tweet

    java.sql.PreparedStatement getTweetTweeterPS = conn.prepareStatement(getTweetTweeterQuery); // create a statement
    getTweetTweeterPS.setString(1, tweet_ID); // set input parameter
    java.sql.ResultSet getTweetTweeterRS = getTweetTweeterPS.executeQuery();
    
    while (getTweetTweeterRS.next())
    {
        tweetTweeter_ID=getTweetTweeterRS.getString("tweeter_ID");
    }
    if(tweetTweeter_ID.equals(login_ID))//Validate that login_ID submitted the tweet
    {
        String getRepliesQuery = "SELECT reply_ID FROM replies_t WHERE replied_ID=?;";//Get any replies to tweet
        java.sql.PreparedStatement getRepliesPS = conn.prepareStatement(getRepliesQuery); // create a statement
        getRepliesPS.setString(1, tweet_ID); // set input parameter
        java.sql.ResultSet getRepliesRS = getRepliesPS.executeQuery();
        while (getRepliesRS.next())    // extract data from the ResultSet
        {
            String reply_ID = getRepliesRS.getString("reply_ID");
            //Delete Reply
            String removeReplyQuery = "DELETE FROM tweets_t WHERE tweet_ID=?;";
            java.sql.PreparedStatement removeReplyPS = conn.prepareStatement(removeReplyQuery); // create a statement
            removeReplyPS.setString(1, reply_ID); // set input parameter
            removeReplyPS.executeUpdate();
        }
        /**********************************************************************/
        //Delete Tweet
        String removeTweetQuery = "DELETE FROM tweets_t WHERE tweet_ID=? AND tweeter_ID=?;";
        java.sql.PreparedStatement removeTweetPS = conn.prepareStatement(removeTweetQuery); // create a statement
        removeTweetPS.setString(1, tweet_ID); // set input parameter
        removeTweetPS.setString(2, login_ID);
        removeTweetPS.executeUpdate();
    
        out.println(referer);
        response.sendRedirect(referer);
    }
%>
