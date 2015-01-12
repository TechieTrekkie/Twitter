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

	/**********************************************************************/

    String timesFavorited=null;

    String checkIfFavoritedQuery = "SELECT count(*) FROM favorites_t WHERE tweet_ID = ? AND login_ID = ?;";
    java.sql.PreparedStatement checkIfFavoritedPS = conn.prepareStatement(checkIfFavoritedQuery); // create a statement
    checkIfFavoritedPS.setString(1, tweet_ID); // set input parameter
    checkIfFavoritedPS.setString(2, login_ID); // set input parameter
    java.sql.ResultSet checkIfFavoritedRS = checkIfFavoritedPS.executeQuery();
    while (checkIfFavoritedRS.next())    // extract data from the ResultSet
    {
        timesFavorited = checkIfFavoritedRS.getString("count(*)");
    }

    if(timesFavorited.equals("0"))//If not favorited yet, favorite
    {
        String addFavoriteQuery = "INSERT INTO favorites_t (tweet_ID,login_ID) VALUES (?,?);";
        java.sql.PreparedStatement addFavoritePS = conn.prepareStatement(addFavoriteQuery); // create a statement
        addFavoritePS.setString(1, tweet_ID); // set input parameter
        addFavoritePS.setString(2, login_ID);
        addFavoritePS.executeUpdate();
    }
    else//If already favorited, unfavorite
    {
        String removeFavoriteQuery = "DELETE FROM favorites_t WHERE tweet_ID=? AND login_ID=?;";
        java.sql.PreparedStatement removeFavoritePS = conn.prepareStatement(removeFavoriteQuery); // create a statement
        removeFavoritePS.setString(1, tweet_ID); // set input parameter
        removeFavoritePS.setString(2, login_ID);
        removeFavoritePS.executeUpdate();
    }
    out.println(referer);
    response.sendRedirect(referer);
%>
