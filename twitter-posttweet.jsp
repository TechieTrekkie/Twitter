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
	out.println("IN");
	String tweet_text = request.getParameter("tweet_contents");
	String retweet_ID = request.getParameter("retweet_id");
    String reply_ID = request.getParameter("reply_id");
	String tweeter_ID = (String)session.getAttribute("id");
	//request.getParameter("id");
	String referer = request.getParameter("referer");
    boolean allowTweet=true;
	
	java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/dazzam_twitter";   //location and name of database
    String userid = "dazzam";
    
    Scanner in = new Scanner(new FileReader("/home/dazzam/public_html/twitter_dir/SQL_Login.txt"));
    String password=in.nextLine();
    
    conn = DriverManager.getConnection(url, userid, password);      //connect to database


    if(retweet_ID!=null)
    {
        String retweeted_tweeter_ID=null;
        String getRetweetedTweeterIDQuery = "SELECT tweeter_ID FROM tweets_t WHERE tweet_ID=?;";
        java.sql.PreparedStatement getRetweetedTweeterIDPS = conn.prepareStatement(getRetweetedTweeterIDQuery); // create a statement
        getRetweetedTweeterIDPS.setString(1, retweet_ID); // set input parameter
        java.sql.ResultSet getRetweetedTweeterIDRS = getRetweetedTweeterIDPS.executeQuery();
        while (getRetweetedTweeterIDRS.next())    // extract data from the ResultSet
        {
            retweeted_tweeter_ID = getRetweetedTweeterIDRS.getString("tweeter_ID");
        }
        if(retweeted_tweeter_ID.equals(tweeter_ID))//Check if it is your tweet
        {
            allowTweet=false;
        }

        String tweet_retweet_ID=null;
        int already_retweeted=0;
        String getIfRetweetedQuery = "SELECT retweet_ID FROM retweets_t WHERE retweeted_ID=?";
        java.sql.PreparedStatement getIfRetweetedPS = conn.prepareStatement(getIfRetweetedQuery); // create a statement
        getIfRetweetedPS.setString(1, retweet_ID); // set input parameter
        java.sql.ResultSet getIfRetweetedRS = getIfRetweetedPS.executeQuery();
        while (getIfRetweetedRS.next())    // extract data from the ResultSet
        {
            tweet_retweet_ID = getIfRetweetedRS.getString("retweet_ID");
            String getAuthorOfRetweetQuery = "SELECT count(*) FROM tweets_t WHERE tweet_ID=? AND tweeter_ID=?";
            java.sql.PreparedStatement getAuthorOfRetweetPS = conn.prepareStatement(getAuthorOfRetweetQuery); // create a statement
            getAuthorOfRetweetPS.setString(1, tweet_retweet_ID); // set input parameter
            getAuthorOfRetweetPS.setString(2, tweeter_ID);
            java.sql.ResultSet getAuthorOfRetweetRS = getAuthorOfRetweetPS.executeQuery();
            while (getAuthorOfRetweetRS.next())    // extract data from the ResultSet
            {
                already_retweeted = getAuthorOfRetweetRS.getInt("count(*)");
                if(already_retweeted!=0)
                {
                    allowTweet=false;
                    break;
                }
            }
        }

    }

	/**********************************************************************/
    if(tweet_text.length()!=0&&allowTweet)
    {		    		

        tweet_text=tweet_text.replaceAll("!!!hash!!!", "#");
        
    	tweet_text=tweet_text.substring(0, Math.min(140, tweet_text.length()));
    	//Insert tweet into database
    	String postTweetQuery = "INSERT INTO tweets_t (tweeter_ID,tweet_content) VALUES (?,?);";
    	java.sql.PreparedStatement postTweetPS = conn.prepareStatement(postTweetQuery); // create a statement
		postTweetPS.setString(1, tweeter_ID); // set input parameter
	    postTweetPS.setString(2, tweet_text);
	    postTweetPS.executeUpdate();
   	 
    	String tweet_ID="";
    	//Get new tweet ID
    	String getTweetIDQuery = "SELECT tweet_ID FROM tweets_t WHERE tweet_content = ? AND tweeter_ID = ? ORDER BY publish_date DESC LIMIT 1;";
    	java.sql.PreparedStatement getTweetIDPS = conn.prepareStatement(getTweetIDQuery); // create a statement
		getTweetIDPS.setString(1, tweet_text); // set input parameter
		getTweetIDPS.setString(2, tweeter_ID); // set input parameter
    	java.sql.ResultSet getTweetIDRS = getTweetIDPS.executeQuery();
    	while (getTweetIDRS.next())    // extract data from the ResultSet
    	{
    		tweet_ID = getTweetIDRS.getString("tweet_ID");
    	}

        if(reply_ID!=null)
        {
            String addReplyQuery = "INSERT INTO replies_t (replied_ID,reply_ID) VALUES (?,?);";
            java.sql.PreparedStatement addReplyPS = conn.prepareStatement(addReplyQuery); // create a statement
            addReplyPS.setString(1, reply_ID); // set input parameter
            addReplyPS.setString(2, tweet_ID);
            addReplyPS.executeUpdate();
        }

		if(retweet_ID!=null)
		{

			//Add tweet to retweets table if needed
			String addRetweetQuery = "INSERT INTO retweets_t (retweeted_ID,retweet_ID) VALUES (?,?);";
    		java.sql.PreparedStatement addRetweetPS = conn.prepareStatement(addRetweetQuery); // create a statement
			addRetweetPS.setString(1, retweet_ID); // set input parameter
	    	addRetweetPS.setString(2, tweet_ID);
	    	addRetweetPS.executeUpdate();
		}
		
		
	    String[] tweetWords = tweet_text.split(" ");
    	for(String word : tweetWords)
    	{
    		if(word.length()!=0 && word.charAt(0)=='#')
    		{
    			String hashtag_ID="-1";
    			//Get Hashtag ID
    			do
    			{
    				String getHashtagIDQuery = "SELECT hashtag_ID FROM hashtags_list_t WHERE hashtag_content = ?;";
    				java.sql.PreparedStatement getHashtagIDPS = conn.prepareStatement(getHashtagIDQuery); // create a statement
					getHashtagIDPS.setString(1, word.toLowerCase()); // set input parameter
    				java.sql.ResultSet getHashtagIDRS = getHashtagIDPS.executeQuery();
    				
    				while (getHashtagIDRS.next())    // extract data from the ResultSet
    				{
    					hashtag_ID = getHashtagIDRS.getString("hashtag_ID");
    				}
    				
    				if(hashtag_ID=="-1")
    				{
    					//Add Hashtag
    					String addHashtagQuery = "INSERT INTO hashtags_list_t (hashtag_content) VALUES (?);";
  						java.sql.PreparedStatement addHashtagPS = conn.prepareStatement(addHashtagQuery); // create a statement
						addHashtagPS.setString(1, word.toLowerCase()); // set input parameter
    					addHashtagPS.executeUpdate();
    				}
    			} while (hashtag_ID=="-1");
    		
    			//Add tweet to hashtags list
    			String addHashtagToTweetQuery = "INSERT INTO tweet_hashtags_t (tweet_ID, hashtag_ID) VALUES (?, ?);";
  				java.sql.PreparedStatement addHashtagToTweetPS = conn.prepareStatement(addHashtagToTweetQuery); // create a statement
				addHashtagToTweetPS.setString(1, tweet_ID); // set input parameter
				addHashtagToTweetPS.setString(2, hashtag_ID); // set input parameter
    			addHashtagToTweetPS.executeUpdate();
    		}
    	}
    }
    out.println(referer);
    response.sendRedirect(referer);
%>
