<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%@ page import="java.io.*" %>

<!doctype html>
<html lang="en">
<%

 	//HttpSession session=request.getSession();
 	//session.setAttribute("email", emailid);
	//String email=(String)session.getAttribute("email");
	
	//String login_ID = request.getParameter("id");
	String login_ID=(String)session.getAttribute("id");
	
	String username = null;
	String full_name = null;
	String numFollowers = null;
	String numFollowing = null;
	String numTweets = null;

	if(login_ID==null)
	{
		response.sendRedirect("twitter-signin.jsp"); 
	}

	java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/dazzam_twitter";   //location and name of database
    String userid = "dazzam";
    
    Scanner in = new Scanner(new FileReader("/home/dazzam/public_html/twitter_dir/SQL_Login.txt"));
    String password=in.nextLine();
    
    conn = DriverManager.getConnection(url, userid, password);      //connect to database

    /**********************************************************************			
	**********************************************************************/
    
    //Get Various Information from login_ID
    String getLoginInfoQuery = "SELECT username, full_name FROM login_t WHERE login_ID = ?";

    java.sql.PreparedStatement getLoginInfoPS = conn.prepareStatement(getLoginInfoQuery); // create a statement
    getLoginInfoPS.setString(1, login_ID); // set input parameter
    java.sql.ResultSet getLoginInfoRS = getLoginInfoPS.executeQuery();
    
    while (getLoginInfoRS.next())    // extract data from the ResultSet
    {
        username = getLoginInfoRS.getString("username");
        full_name = getLoginInfoRS.getString("full_name");
    }

    /**********************************************************************/

    //Get number of followers of login_ID
    String getNumFollowersQuery = "SELECT count(follower_ID) FROM following_t WHERE followed_ID=?";

    java.sql.PreparedStatement getNumFollowersPS = conn.prepareStatement(getNumFollowersQuery); // create a statement
    getNumFollowersPS.setString(1, login_ID); // set input parameter
    java.sql.ResultSet getNumFollowersRS = getNumFollowersPS.executeQuery();
    
    while (getNumFollowersRS.next())    // extract data from the ResultSet
    {
    	numFollowers = getNumFollowersRS.getString("count(follower_ID)");
    }
    
    /**********************************************************************/
    
    //Get number of people login_ID is following
    String getNumFollowingQuery = "SELECT count(followed_ID) FROM following_t WHERE follower_ID=?";

    java.sql.PreparedStatement getNumFollowingPS = conn.prepareStatement(getNumFollowingQuery); // create a statement
    getNumFollowingPS.setString(1, login_ID); // set input parameter
    java.sql.ResultSet getNumFollowingRS = getNumFollowingPS.executeQuery();
    
    while (getNumFollowingRS.next())    // extract data from the ResultSet
    {
    	numFollowing = getNumFollowingRS.getString("count(followed_ID)");
    }
    
    /**********************************************************************/
    
    //Get number of tweets tweeted by login_ID
    String getNumTweetsQuery = "SELECT count(tweeter_ID) FROM tweets_t WHERE tweeter_ID=?";

    java.sql.PreparedStatement getNumTweetsPS = conn.prepareStatement(getNumTweetsQuery); // create a statement
    getNumTweetsPS.setString(1, login_ID); // set input parameter
    java.sql.ResultSet getNumTweetsRS = getNumTweetsPS.executeQuery();
    
    while (getNumTweetsRS.next())    // extract data from the ResultSet
    {
    	numTweets = getNumTweetsRS.getString("count(tweeter_ID)");
    }
       
    /**********************************************************************/

%>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dwitter &middot Favorites View</title>
    <meta name="description" content="">
    <meta name="author" content="">
    <style type="text/css">
    	body {
    		padding-top: 60px;
    		padding-bottom: 40px;
    	}
    	.sidebar-nav {
    		padding: 9px 0;
    	}
    </style>
    <link rel="icon" type="image/png" href="images/brand.png">
    <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
</head>
<body class="user-style-theme1">
	<div class="navbar navbar-default navbar-fixed-top">
			<div class="container-fluid">
                <i class="nav-home"></i> 
				<div class="navbar-header">
      				<ul class="nav">
      					<li>
      				  		<a class="navbar-brand" href="#">
        						<img alt="Brand" src="images/brand.png" height="30" width="30">
      						</a>
      					</li>
						<li><a href="twitter-home.jsp">Home</a></li>
						<li><a href="twitter-users.jsp">Find People</a></li>
						<li class="active"><a href="twitter-favorites.jsp">Favorites</a></li>
					</ul>
					<ul class="nav pull-right">
					  <li role="presentation" class="dropdown">
    						<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-expanded="false" style="padding-left: 4px;">
      						<%=full_name%> <span class="caret"></span>
    						</a>
    						<ul class="dropdown-menu" role="menu">
    							<li><a href="twitter-profile.jsp?profile=<%=login_ID%>">View Profile</a></li>
            					<li><a href="twitter-settings.jsp">Change Settings</a></li>
            					<li class="divider"></li>
            					<li><a href="twitter-signout.jsp">Log Out</a></li>
    						</ul>
  						</li>
					</ul>
					<p class="navbar-text pull-right">Logged in as</p>
                </div>
			</div>
	</div>

    <div class="container wrap">
        <div class="row">

            <!-- left column -->
            <div class="span4" id="secondary">
                <div class="module mini-profile">
                    <div class="content">
                        <div class="account-group" style="height: 54px;">
                            <a href="twitter-profile.jsp?profile=<%=login_ID%>">
                                <img class="avatar size64" src='<%="images/avatars/"+login_ID+".jpg"%>' onerror="this.src='images/avatars/default.png'" alt='<%=full_name%>' height="54" width="54">
                                <b class="fullname"><%=full_name%></b>
                                <small class="metadata">@<%=username%></small>
                            </a>
                        </div>
                    </div>
                    <div class="js-mini-profile-stats-container">
                        <ul class="stats">
                            <li><a href="twitter-profile.jsp?profile=<%=login_ID%>"><strong><%=numTweets%></strong>Tweets</a></li>
                            <li><a href="twitter-following.jsp?profile=<%=login_ID%>"><strong><%=numFollowing%></strong>Following</a></li>
                            <li><a href="twitter-followers.jsp?profile=<%=login_ID%>"><strong><%=numFollowers%></strong>Followers</a></li>
                        </ul>
                    </div>
                    <form action="twitter-posttweet.jsp" class="posttweet" method="post">
                        <textarea class="tweet-box" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile" name="tweet_contents"></textarea>
                        <input type="hidden" name="id" value=<%=login_ID%>> </input>
                        <input type="hidden" name="referer" value="twitter-favorites.jsp"></input>
                        <button type="submit" class="btn btn-default">Submit</button>
                    </form>
                </div>

                <div class="module other-side-content">
                    <div class="content"
                    	<p>
                    		<strong>Trending</strong>
                    		<br>
                    	<%
                    		String trending_hashtag_ID=null;
    								
    						String getTrendingHashtagIDQuery = "SELECT hashtag_ID FROM tweet_hashtags_t GROUP BY hashtag_ID ORDER BY COUNT(hashtag_ID) DESC LIMIT 5;";
    						java.sql.PreparedStatement getTrendingHashtagIDPS = conn.prepareStatement(getTrendingHashtagIDQuery); // create a statement
    						java.sql.ResultSet getTrendingHashtagIDRS = getTrendingHashtagIDPS.executeQuery();
    			
    						while (getTrendingHashtagIDRS.next())    // extract data from the ResultSet
    						{
    							trending_hashtag_ID = getTrendingHashtagIDRS.getString("hashtag_ID");
    							
    							String trending_hashtag_content=null;
    								
    							String getTrendingHashtagContentQuery = "SELECT hashtag_content FROM hashtags_list_t WHERE hashtag_ID=?;";
    							java.sql.PreparedStatement getTrendingHashtagContentPS = conn.prepareStatement(getTrendingHashtagContentQuery); // create a statement
    							getTrendingHashtagContentPS.setString(1, trending_hashtag_ID); // set input parameter
    							java.sql.ResultSet getTrendingHashtagContentRS = getTrendingHashtagContentPS.executeQuery();
    			
    							while (getTrendingHashtagContentRS.next())    // extract data from the ResultSet
    							{
    								trending_hashtag_content = getTrendingHashtagContentRS.getString("hashtag_content");
    							}
    						
                    	%>
                    		<a href="twitter-hashtag.jsp?hashID=<%=trending_hashtag_ID%>"><%=trending_hashtag_content%></a>
                        	<br>
                        	
                        	<%
                        	}//End Trending While
                        	%>
                        </p>
                    </div>
                </div>
            </div>

            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title"><%=full_name%>'s Favorite Tweets</h2>
                        </div>
                    </div>
                    
                    <!-- all tweets -->
                    <div class="stream home-stream">
                    <%
                    
    					/**********************************************************************/
                    
                    	//Get tweets to display for login_ID
    					String TweetsToShowQuery = "SELECT * FROM tweets_t WHERE (tweet_ID IN (SELECT tweet_ID FROM favorites_t WHERE login_ID=?)) AND tweet_ID NOT IN (SELECT reply_ID AS tweet_ID FROM replies_t) ORDER BY publish_date DESC;";

    					java.sql.PreparedStatement TweetsToShowPS = conn.prepareStatement(TweetsToShowQuery); // create a statement
    					TweetsToShowPS.setString(1, login_ID); // set input parameter
    					java.sql.ResultSet TweetsToShowRS = TweetsToShowPS.executeQuery();
    					
    					while (TweetsToShowRS.next())    // Go through all tweets
    					{
    						String tweet_ID=TweetsToShowRS.getString("tweet_ID");
    						String publish_date_string=TweetsToShowRS.getString("publish_date");
    						String tweeter_ID=TweetsToShowRS.getString("tweeter_ID");
    						String tweet_content=TweetsToShowRS.getString("tweet_content");
    						
    						String retweeted_tweet_ID=null;
    						String retweeter_ID=tweeter_ID;
    						String retweeter_username=null;
    						String retweet_date_string=publish_date_string;
                            String retweeter_tweet_ID=tweet_ID;
    						Boolean isRetweet=false;
    						
    						String getRetweetedTweetQuery = "SELECT retweeted_ID FROM retweets_t WHERE retweet_ID=?;";

    						java.sql.PreparedStatement getRetweetedTweetPS = conn.prepareStatement(getRetweetedTweetQuery); // create a statement
    						getRetweetedTweetPS.setString(1, tweet_ID); // set input parameter
    						java.sql.ResultSet getRetweetedTweetRS = getRetweetedTweetPS.executeQuery();
    						
    						if(getRetweetedTweetRS.next())    //If it is a retweet
    						{
    							isRetweet=true;
    							retweeted_tweet_ID=getRetweetedTweetRS.getString("retweeted_ID"); 
    							
    							//Get Retweet content and Info
    							String RetweetedTweetToShowQuery = "SELECT * FROM tweets_t WHERE tweet_ID =?;";

    							java.sql.PreparedStatement RetweetedTweetToShowPS = conn.prepareStatement(RetweetedTweetToShowQuery); // create a statement
    							RetweetedTweetToShowPS.setString(1, retweeted_tweet_ID); // set input parameter
    							java.sql.ResultSet RetweetedTweetToShowRS = RetweetedTweetToShowPS.executeQuery();
    							
    							while (RetweetedTweetToShowRS.next())    // Go through all tweets
    							{
    								tweet_ID=RetweetedTweetToShowRS.getString("tweet_ID");
    								publish_date_string=RetweetedTweetToShowRS.getString("publish_date");
    								tweeter_ID=RetweetedTweetToShowRS.getString("tweeter_ID");
    								tweet_content=RetweetedTweetToShowRS.getString("tweet_content");
    							}					
    						}
                            else
                            {
                                retweeted_tweet_ID=tweet_ID;
                                retweeter_ID=tweeter_ID;
                            }
    						
    						
    						String time_to_display=null;
    						String tweeter_username=null;
    						String tweeter_name=null;
                            String times_retweeted=null;
                            String times_favorited=null;
                            String timesFollowed=null;
                            String num_replies=null;
                            int already_retweeted=0;
                            int already_favorited=0;
    						String tweet_content_raw=tweet_content;
    						String[] tweetContentArray = tweet_content.split(" ");
    						
    						tweet_content="";
    						for(String word : tweetContentArray)//Check for hashtags
    						{
    							word=word.replaceAll("&", "&amp;");
    							word=word.replaceAll("<", "&#60;");
    							word=word.replaceAll(">", "&gt;");
    							if(word.length()!=0 && word.charAt(0)=='#')
    							{
    								String hashtag_ID=null;
    								
    								String getHashtagIDQuery = "SELECT hashtag_ID FROM hashtags_list_t WHERE hashtag_content = ?;";
    								java.sql.PreparedStatement getHashtagIDPS = conn.prepareStatement(getHashtagIDQuery); // create a statement
									getHashtagIDPS.setString(1, word.toLowerCase()); // set input parameter
    								java.sql.ResultSet getHashtagIDRS = getHashtagIDPS.executeQuery();
    			
    								while (getHashtagIDRS.next())    // extract data from the ResultSet
    								{
    									hashtag_ID = getHashtagIDRS.getString("hashtag_ID");
    								}
    								
    								word="<a href=\"twitter-hashtag.jsp?hashID="+hashtag_ID+"\">"+word+"</a>";
    							}
                                else if(word.length()!=0 && word.charAt(0)=='@')
                                {
                                    String atReply_ID=null;
                                    
                                    String getAtReplyIDQuery = "SELECT login_ID FROM login_t WHERE username = ?;";
                                    java.sql.PreparedStatement getAtReplyIDPS = conn.prepareStatement(getAtReplyIDQuery); // create a statement
                                    getAtReplyIDPS.setString(1, word.replaceAll("@", "").toLowerCase()); // set input parameter
                                    java.sql.ResultSet getAtReplyIDRS = getAtReplyIDPS.executeQuery();
                
                                    while (getAtReplyIDRS.next())    // extract data from the ResultSet
                                    {
                                        atReply_ID = getAtReplyIDRS.getString("login_ID");
                                    }
                                    if(atReply_ID!=null)
                                    {
                                        word="<a href=\"twitter-profile.jsp?profile="+atReply_ID+"\">"+word+"</a>";
                                    }
                                }
    							tweet_content=tweet_content+" "+word;
    						}
    						
	   						java.sql.Timestamp publish_date = java.sql.Timestamp.valueOf(publish_date_string);//Get date for tweet
	   						long timeSincePublish=System.currentTimeMillis()-publish_date.getTime();
	   						
	   						
	   						timeSincePublish=((timeSincePublish/1000)/60);
	   						String units = "m";
	   						//Convert to Minutes
	   						if(timeSincePublish>60)//More than 1 hour has passed
	   						{
	   							timeSincePublish=timeSincePublish/60;
	   							units = "h";
	   							//Convert to Hours
	   						
	   							if(timeSincePublish>24)
	   							{
	   								timeSincePublish=timeSincePublish/24;
	   								units = "d";
	   								//Convert to Days
	   						
	   								if(timeSincePublish>30)
	   								{
	   									timeSincePublish=timeSincePublish/30;
	   									units = "months";
	   									//Convert to Months
	   									
	   									if(timeSincePublish>12)
	   									{
	   										timeSincePublish=timeSincePublish/12;
	   										units = "years";
	   										//Convert to Years
	   									}
	   								}
	   							}
	   						}
	   						time_to_display = Long.toString(timeSincePublish)+" "+units;
	   						
	   						    						
    						//Get Username from tweeter_ID
        					String getTweeterUsernameQuery = "SELECT username FROM login_t WHERE login_ID = ?";
        					java.sql.PreparedStatement getTweeterUsernamePS = conn.prepareStatement(getTweeterUsernameQuery); // create a statement
        					getTweeterUsernamePS.setString(1, tweeter_ID); // set input parameter
        					java.sql.ResultSet getTweeterUsernameRS = getTweeterUsernamePS.executeQuery();
        					while (getTweeterUsernameRS.next())    // extract data from the ResultSet
        					{
        						tweeter_username = getTweeterUsernameRS.getString("username");
        					}
        					
        					if(isRetweet)//If was retweet, get username of person that retweeted
        					{
        						//Get Username from retweeter_ID
        						String getRetweeterUsernameQuery = "SELECT username FROM login_t WHERE login_ID = ?";
        						java.sql.PreparedStatement getRetweeterUsernamePS = conn.prepareStatement(getRetweeterUsernameQuery); // create a statement
        						getRetweeterUsernamePS.setString(1, retweeter_ID); // set input parameter
        						java.sql.ResultSet getRetweeterUsernameRS = getRetweeterUsernamePS.executeQuery();
        						while (getRetweeterUsernameRS.next())    // extract data from the ResultSet
        						{
        							retweeter_username = getRetweeterUsernameRS.getString("username");
        						}	
        					}
        					
        					//Get Tweeter Full Name from tweeter_ID
        					String getTweeterNameQuery = "SELECT full_name FROM login_t WHERE login_ID = ?";
        					java.sql.PreparedStatement getTweeterNamePS = conn.prepareStatement(getTweeterNameQuery); // create a statement
        					getTweeterNamePS.setString(1, tweeter_ID); // set input parameter
        					java.sql.ResultSet getTweeterNameRS = getTweeterNamePS.executeQuery();
        					while (getTweeterNameRS.next())    // extract data from the ResultSet
        					{
        						tweeter_name = getTweeterNameRS.getString("full_name");
        					} 	

                            //Get Number of times ReTweeted
                            String getTimesRetweetedQuery = "SELECT count(retweeted_ID) FROM retweets_t WHERE retweeted_ID=?";
                            java.sql.PreparedStatement getTimesRetweetedPS = conn.prepareStatement(getTimesRetweetedQuery); // create a statement
                            getTimesRetweetedPS.setString(1, tweet_ID); // set input parameter
                            java.sql.ResultSet getTimesRetweetedRS = getTimesRetweetedPS.executeQuery();
                            while (getTimesRetweetedRS.next())    // extract data from the ResultSet
                            {
                                times_retweeted = getTimesRetweetedRS.getString("count(retweeted_ID)");
                            }

                            //Check if login_Id retweeted message
                            String tweet_retweet_ID=null;
                            String getIfRetweetedQuery = "SELECT retweet_ID FROM retweets_t WHERE retweeted_ID=?";
                            java.sql.PreparedStatement getIfRetweetedPS = conn.prepareStatement(getIfRetweetedQuery); // create a statement
                            getIfRetweetedPS.setString(1, tweet_ID); // set input parameter
                            java.sql.ResultSet getIfRetweetedRS = getIfRetweetedPS.executeQuery();
                            while (getIfRetweetedRS.next())    // extract data from the ResultSet
                            {
                                tweet_retweet_ID = getIfRetweetedRS.getString("retweet_ID");

                                String getAuthorOfRetweetQuery = "SELECT count(*) FROM tweets_t WHERE tweet_ID=? AND tweeter_ID=?";
                                java.sql.PreparedStatement getAuthorOfRetweetPS = conn.prepareStatement(getAuthorOfRetweetQuery); // create a statement
                                getAuthorOfRetweetPS.setString(1, tweet_retweet_ID); // set input parameter
                                getAuthorOfRetweetPS.setString(2, login_ID);
                                java.sql.ResultSet getAuthorOfRetweetRS = getAuthorOfRetweetPS.executeQuery();
                                while (getAuthorOfRetweetRS.next())    // extract data from the ResultSet
                                {
                                    already_retweeted = getAuthorOfRetweetRS.getInt("count(*)");
                                    if(already_retweeted!=0)
                                    {
                                        break;
                                    }
                                }
                            }

                            //Get Number of times Favorited
                            String getTimesFavoritedQuery = "SELECT count(tweet_ID) FROM favorites_t WHERE tweet_ID=?";
                            java.sql.PreparedStatement getTimesFavoritedPS = conn.prepareStatement(getTimesFavoritedQuery); // create a statement
                            getTimesFavoritedPS.setString(1, tweet_ID); // set input parameter
                            java.sql.ResultSet getTimesFavoritedRS = getTimesFavoritedPS.executeQuery();
                            while (getTimesFavoritedRS.next())    // extract data from the ResultSet
                            {
                                times_favorited = getTimesFavoritedRS.getString("count(tweet_ID)");
                            }   		

                            //Get If login_ID already Favorited
                            String getIfFavoritedQuery = "SELECT count(*) FROM favorites_t WHERE tweet_ID=? AND login_ID=?";
                            java.sql.PreparedStatement getIfFavoritedPS = conn.prepareStatement(getIfFavoritedQuery); // create a statement
                            getIfFavoritedPS.setString(1, tweet_ID); // set input parameter
                            getIfFavoritedPS.setString(2, login_ID);
                            java.sql.ResultSet getIfFavoritedRS = getIfFavoritedPS.executeQuery();
                            while (getIfFavoritedRS.next())    // extract data from the ResultSet
                            {
                                already_favorited = getIfFavoritedRS.getInt("count(*)");
                            }

                            //Get Number of times Favorited
                            String getNumRepliesQuery = "SELECT count(reply_ID) FROM replies_t WHERE replied_ID=?";
                            java.sql.PreparedStatement getNumRepliesPS = conn.prepareStatement(getNumRepliesQuery); // create a statement
                            getNumRepliesPS.setString(1, tweet_ID); // set input parameter
                            java.sql.ResultSet getNumRepliesRS = getNumRepliesPS.executeQuery();
                            while (getNumRepliesRS.next())    // extract data from the ResultSet
                            {
                                num_replies = getNumRepliesRS.getString("count(reply_ID)");
                            }

                            //Check if already following person tweeting
                            String checkIfFollowedQuery = "SELECT count(*) FROM following_t WHERE followed_ID = ? AND follower_ID = ?;";
                            java.sql.PreparedStatement checkIfFollowedPS = conn.prepareStatement(checkIfFollowedQuery); // create a statement
                            checkIfFollowedPS.setString(1, retweeter_ID); // set input parameter
                            checkIfFollowedPS.setString(2, login_ID); // set input parameter
                            java.sql.ResultSet checkIfFollowedRS = checkIfFollowedPS.executeQuery();
                            while (checkIfFollowedRS.next())    // extract data from the ResultSet
                            {
                                timesFollowed = checkIfFollowedRS.getString("count(*)");
                            }
                    %>
                        <!-- start tweet -->
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                	<%
                                		if(isRetweet)
                                		{
                                	%>
                                		<div class="stream-item-header">
                                		    <small class="username" style="font-size: 14px;">
                                    	        <a href="twitter-profile.jsp?profile=<%=retweeter_ID%>">
                                    	            <span class="icon-retweet"></span> @<%=retweeter_username%> retweeted
                                    	        </a>
                                    	    </small>
                                		</div>
                                	<%
                                		}//End if is retweet
                                	%>
                                    <div class="stream-item-header">
                                        <small class="time">
                                            <a href="#" class="tweet-timestamp" title="Tweet_Title">
                                                <span class="_timestamp"><%=time_to_display%></span>
                                            </a>
                                        </small>
    
                                        <a class="account-group">
             								<a href="twitter-profile.jsp?profile=<%=tweeter_ID%>">
                                            	<img class="avatar" src='<%="images/avatars/"+tweeter_ID+".jpg"%>' onerror="this.src='images/avatars/default.png'" alt='<%=tweeter_name%>'>
                                            </a>
                                            <a href="twitter-profile.jsp?profile=<%=tweeter_ID%>">
                                            	<strong class="fullname"><%=tweeter_name%></strong>
                                            	<span>&rlm;</span>
                                            	<span class="username">
                                                	<s><%="@"+tweeter_username%></s>
                                            	</span>
                                            </a>
                                        </a>
                                    </div><!-- end stream-item-header -->
                                    <p class="js-tweet-text">
                                        <%=tweet_content%>
                                    </p>
                                    <span>
                                        <div class="btn-group" role="group">
                                            <a href="#<%=tweet_ID%>replies" title"Replies" data-toggle="modal">
                                               <button type="button" class="btn btn-xs btn-default" style="margin-left: 6px; padding-left: 12px; padding-right: 12px;padding-bottom: 2px;padding-top: 2px;width: 55.81818175315857px;">
                                                   <span class="icon-share-alt"></span>
                                                   <%if(!num_replies.equals("0")){%> <%=num_replies%><%}%>
                                                </button>
                                            </a>
                                            <a href="<%if(already_retweeted!=0||tweeter_ID.equals(login_ID)){%>#<%}else{%>twitter-posttweet.jsp?tweet_contents=<%=tweet_content_raw.replaceAll("#", "!!!hash!!!")%>&retweet_id=<%=tweet_ID%>&referer=twitter-favorites.jsp<%}%>">
                                                <button type="button" class="btn btn-xs btn-default<%if(already_retweeted!=0||tweeter_ID.equals(login_ID)){%> disabled<%}%>" style="padding-left: 12px; padding-right: 12px;padding-bottom: 2px;padding-top: 2px;width: 55.81818175315857px;">
                                                    <span class="icon-retweet"></span>
                                                    <%if(!times_retweeted.equals("0")){%> <%=times_retweeted%><%}%>
                                                </button>
                                            </a>
                                            <a id="popover" data-trigger="hover"> Favorite Tweet
                                            <a href="twitter-favoritetweet.jsp?tweet_id=<%=tweet_ID%>&referer=twitter-favorites.jsp">
                                                <button type="button" class="btn btn-xs btn-default" style="padding-left: 12px; padding-right: 12px;padding-bottom: 2px;padding-top: 2px;width: 55.81818175315857px;">
                                                    <span class="<%if(already_favorited!=0){%>icon-star<%}else{%>icon-star-empty<%}%>"></span>
                                                    <%if(!times_favorited.equals("0")){%> <%=times_favorited%><%}%>
                                                </button>
                                            </a>
                                            </a>
                                            <a href="<%if(retweeter_ID.equals(login_ID)){%>twitter-deletetweet.jsp?tweet_id=<%=retweeter_tweet_ID%>&referer=twitter-favorites.jsp<%}else{%>twitter-togglefollower.jsp?followed_id=<%=retweeter_ID%>&referer=twitter-favorites.jsp<%}%>">
                                                <button type="button" class="btn btn-xs btn-default" style="padding-left: 12px; padding-right: 12px;padding-bottom: 2px;padding-top: 2px;width: 55.81818175315857px;">
                                                    <span class="<%if(retweeter_ID.equals(login_ID)){%>icon-trash<%}else if(timesFollowed.equals("0")){%>icon-eye-open<%}else{%>icon-eye-close<%}%>"></span>
                                                </button>
                                            </a>
                                        </div>
                                    </span>
                                </div><!-- end class content -->
                                <div class="expanded-content js-tweet-details-dropdown"></div>
                            </div><!-- end class original-tweet -->
                        </div><!-- end tweet -->
                        <!--**************************************************************************************************************Replies-->
                        <div id="<%=tweet_ID%>replies" class="modal hide fade">
                            <div class="modal-header twttr-dialog-header">
                                <div class="twttr-dialog-close" data-dismiss="modal" aria-hidden="true">&nbsp;</div>
                                <h3>Tweet Replies</h3>
                            </div>
                            <div class="modal-body">
                                <!-- direct messages start -->
                                <%
                                    String getRepliesQuery = "SELECT * FROM tweets_t WHERE tweet_ID IN(SELECT reply_ID AS tweet_ID FROM replies_t WHERE replied_ID=?);";
                                    java.sql.PreparedStatement getRepliesPS = conn.prepareStatement(getRepliesQuery); // create a statement
                                    getRepliesPS.setString(1, tweet_ID); // set input parameter
                                    java.sql.ResultSet getRepliesRS = getRepliesPS.executeQuery();
                                    while (getRepliesRS.next())    // extract data from the ResultSet
                                    {
                                        String reply_ID = getRepliesRS.getString("tweet_ID");
                                        String replier_ID = getRepliesRS.getString("tweeter_ID");

                                        String reply_publish_date_string=getRepliesRS.getString("publish_date");
                                        String reply_content=getRepliesRS.getString("tweet_content");
                                        
                                        String reply_time_to_display=null;
                                        String replier_username=null;
                                        String replier_name=null;
            
                                        String reply_content_raw=reply_content;
                                        String[] replyContentArray = reply_content.split(" ");
                                        
                                        reply_content="";
                                        for(String word : replyContentArray)//Check for hashtags
                                        {
                                            word=word.replaceAll("&", "&amp;");
                                            word=word.replaceAll("<", "&#60;");
                                            word=word.replaceAll(">", "&gt;");
                                            if(word.length()!=0 && word.charAt(0)=='#')
                                            {
                                                String hashtag_ID=null;
                                                
                                                String getHashtagIDQuery = "SELECT hashtag_ID FROM hashtags_list_t WHERE hashtag_content = ?;";
                                                java.sql.PreparedStatement getHashtagIDPS = conn.prepareStatement(getHashtagIDQuery); // create a statement
                                                getHashtagIDPS.setString(1, word.toLowerCase()); // set input parameter
                                                java.sql.ResultSet getHashtagIDRS = getHashtagIDPS.executeQuery();
                            
                                                while (getHashtagIDRS.next())    // extract data from the ResultSet
                                                {
                                                    hashtag_ID = getHashtagIDRS.getString("hashtag_ID");
                                                }
                                                
                                                word="<a href=\"twitter-hashtag.jsp?hashID="+hashtag_ID+"\">"+word+"</a>";
                                            }
                                            else if(word.length()!=0 && word.charAt(0)=='@')
                                            {
                                                String atReply_ID=null;
                                                
                                                String getAtReplyIDQuery = "SELECT login_ID FROM login_t WHERE username = ?;";
                                                java.sql.PreparedStatement getAtReplyIDPS = conn.prepareStatement(getAtReplyIDQuery); // create a statement
                                                getAtReplyIDPS.setString(1, word.replaceAll("@", "").toLowerCase()); // set input parameter
                                                java.sql.ResultSet getAtReplyIDRS = getAtReplyIDPS.executeQuery();
                            
                                                while (getAtReplyIDRS.next())    // extract data from the ResultSet
                                                {
                                                    atReply_ID = getAtReplyIDRS.getString("login_ID");
                                                }
                                                if(atReply_ID!=null)
                                                {
                                                    word="<a href=\"twitter-profile.jsp?profile="+atReply_ID+"\">"+word+"</a>";
                                                }
                                            }
                                            reply_content=reply_content+" "+word;
                                        }
                                        
                                        java.sql.Timestamp reply_publish_date = java.sql.Timestamp.valueOf(reply_publish_date_string);//Get date for tweet
                                        long replyTimeSincePublish=System.currentTimeMillis()-reply_publish_date.getTime();
                                        
                                        
                                        replyTimeSincePublish=((replyTimeSincePublish/1000)/60);
                                        String reply_units = "m";
                                        //Convert to Minutes
                                        if(replyTimeSincePublish>60)//More than 1 hour has passed
                                        {
                                            replyTimeSincePublish=replyTimeSincePublish/60;
                                            reply_units = "h";
                                            //Convert to Hours
                                        
                                            if(replyTimeSincePublish>24)
                                            {
                                                replyTimeSincePublish=replyTimeSincePublish/24;
                                                reply_units = "d";
                                                //Convert to Days
                                        
                                                if(replyTimeSincePublish>30)
                                                {
                                                    replyTimeSincePublish=replyTimeSincePublish/30;
                                                    reply_units = "months";
                                                    //Convert to Months
                                                    
                                                    if(replyTimeSincePublish>12)
                                                    {
                                                        replyTimeSincePublish=replyTimeSincePublish/12;
                                                        reply_units = "years";
                                                        //Convert to Years
                                                    }
                                                }
                                            }
                                        }
                                        reply_time_to_display = Long.toString(replyTimeSincePublish)+" "+reply_units;
                                        
                                                                    
                                        //Get Username from replier_ID
                                        String getReplierUsernameQuery = "SELECT username FROM login_t WHERE login_ID = ?";
                                        java.sql.PreparedStatement getReplierUsernamePS = conn.prepareStatement(getReplierUsernameQuery); // create a statement
                                        getReplierUsernamePS.setString(1, replier_ID); // set input parameter
                                        java.sql.ResultSet getReplierUsernameRS = getReplierUsernamePS.executeQuery();
                                        while (getReplierUsernameRS.next())    // extract data from the ResultSet
                                        {
                                            replier_username = getReplierUsernameRS.getString("username");
                                        }
                                        
                                        //Get Replier Full Name from replier_ID
                                        String getReplierNameQuery = "SELECT full_name FROM login_t WHERE login_ID = ?";
                                        java.sql.PreparedStatement getReplierNamePS = conn.prepareStatement(getReplierNameQuery); // create a statement
                                        getReplierNamePS.setString(1, replier_ID); // set input parameter
                                        java.sql.ResultSet getReplierNameRS = getReplierNamePS.executeQuery();
                                        while (getReplierNameRS.next())    // extract data from the ResultSet
                                        {
                                            replier_name = getReplierNameRS.getString("full_name");
                                        }   
                                    
                                %>
                                <!-- start tweet -->
                                <div class="js-stream-item stream-item expanding-string-item">
                                    <div class="tweet original-tweet">
                                        <div class="content">
                                            <div class="stream-item-header">
                                                <small class="time">
                                                    <a href="#" class="tweet-timestamp" title="Tweet_Title">
                                                        <span class="_timestamp"><%=reply_time_to_display%></span>
                                                    </a>
                                                </small>
                                                <a class="account-group">
                                                    <a href="twitter-profile.jsp?profile=<%=replier_ID%>">
                                                        <img class="avatar" src='<%="images/avatars/"+replier_ID+".jpg"%>' onerror="this.src='images/avatars/default.png'" alt='<%=replier_name%>'>
                                                    </a>
                                                    <a href="twitter-profile.jsp?profile=<%=replier_ID%>">
                                                        <strong class="fullname"><%=replier_name%></strong>
                                                        <span>&rlm;</span>
                                                        <span class="username">
                                                            <s><%="@"+replier_username%></s>
                                                        </span>
                                                    </a>
                                                </a>
                                            </div>
                                            <p class="js-tweet-text">
                                                <%=reply_content%>
                                            </p>
                                        </div>
                                    </a>
                                        <div class="expanded-content js-tweet-details-dropdown"></div>
                                    </div>
                                </div>
                                <!-- end tweet -->
                               <%
                               }//End Replies While
                               %>
                                <!-- direct messages end -->
                            </div>
                            <div class="twttr-dialog-footer">
                                <span>
                                    <form action="twitter-posttweet.jsp" class="posttweet" method="post" style="margin-bottom: 5px;">
                                        <textarea class="tweet-box" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile" name="tweet_contents" style="height: 20px; margin-bottom: 0px;"><%="@"+tweeter_username+" "%></textarea>
                                        <input type="hidden" name="referer" value="twitter-favorites.jsp#<%=tweet_ID%>replies"></input>
                                        <input type="hidden" name="reply_id" value="<%=tweet_ID%>"></input>
                                        <button type="submit" class="btn btn-default">Submit</button>
                                    </form>
                                </span>
                            </div>
                    </div>
					<%
					}//End Tweet While
					%>
                    </div>
                    <div class="stream-footer"></div>
                    <div class="hidden-replies-container"></div>
                    <div class="stream-autoplay-marker"></div>
                </div>
                </div>
               
            </div><!-- End Right Column-->
        </div><!-- End Row-->
    </div><!-- End Container Wrap-->
    <!-- Le javascript-->
    <!--================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>