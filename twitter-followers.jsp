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
    String profile_ID = request.getParameter("profile");
    
    if(login_ID==null)
    {
        response.sendRedirect("twitter-signin.jsp"); 
    }
    
    String username = null;
    String full_name = null;
    String numTweets=null;
    String numFollowers=null;
    String numFollowing=null;
    
    String profile_username = null;
    String profile_full_name = null;
    String profile_text = "";
    String numProfileFollowers = null;
    String numProfileFollowing = null;
    String numProfileTweets = null;
    String timesProfileFollowed=null;

    java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/dazzam_twitter";   //location and name of database
    String userid = "dazzam";
    
    Scanner in = new Scanner(new FileReader("/home/dazzam/public_html/twitter_dir/SQL_Login.txt"));
    String password=in.nextLine();
    
    conn = DriverManager.getConnection(url, userid, password);      //connect to database

    /**********************************************************************/
    //Get Various Information from profile_ID
    String getProfileInfoQuery = "SELECT username, full_name FROM login_t WHERE login_ID = ?";

    java.sql.PreparedStatement getProfileInfoPS = conn.prepareStatement(getProfileInfoQuery); // create a statement
    getProfileInfoPS.setString(1, profile_ID); // set input parameter
    java.sql.ResultSet getProfileInfoRS = getProfileInfoPS.executeQuery();
    
    while (getProfileInfoRS.next())    // extract data from the ResultSet
    {
        profile_username = getProfileInfoRS.getString("username");
        profile_full_name = getProfileInfoRS.getString("full_name");
    }

    /**********************************************************************/
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

    //Get number of tweets tweeted by login_ID
    String getLoginNumTweetsQuery = "SELECT count(tweeter_ID) FROM tweets_t WHERE tweeter_ID=?";

    java.sql.PreparedStatement getLoginNumTweetsPS = conn.prepareStatement(getLoginNumTweetsQuery); // create a statement
    getLoginNumTweetsPS.setString(1, login_ID); // set input parameter
    java.sql.ResultSet getLoginNumTweetsRS = getLoginNumTweetsPS.executeQuery();
    
    while (getLoginNumTweetsRS.next())    // extract data from the ResultSet
    {
        numTweets = getLoginNumTweetsRS.getString("count(tweeter_ID)");
    }
       
    /**********************************************************************/

    //Get number of followers of login_ID
    String getLoginNumFollowersQuery = "SELECT count(follower_ID) FROM following_t WHERE followed_ID=?";

    java.sql.PreparedStatement getLoginNumFollowersPS = conn.prepareStatement(getLoginNumFollowersQuery); // create a statement
    getLoginNumFollowersPS.setString(1, login_ID); // set input parameter
    java.sql.ResultSet getLoginNumFollowersRS = getLoginNumFollowersPS.executeQuery();
    
    while (getLoginNumFollowersRS.next())    // extract data from the ResultSet
    {
        numFollowers = getLoginNumFollowersRS.getString("count(follower_ID)");
    }
    
    /**********************************************************************/
    
    //Get number of people login_ID is following
    String getLoginNumFollowingQuery = "SELECT count(followed_ID) FROM following_t WHERE follower_ID=?";

    java.sql.PreparedStatement getLoginNumFollowingPS = conn.prepareStatement(getLoginNumFollowingQuery); // create a statement
    getLoginNumFollowingPS.setString(1, login_ID); // set input parameter
    java.sql.ResultSet getLoginNumFollowingRS = getLoginNumFollowingPS.executeQuery();
    
    while (getLoginNumFollowingRS.next())    // extract data from the ResultSet
    {
        numFollowing = getLoginNumFollowingRS.getString("count(followed_ID)");
    }
    /**********************************************************************/
%>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dwitter &middot Home</title>
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
                        <li class="active"><a href="twitter-users.jsp">Find People</a></li>
                        <li><a href="twitter-favorites.jsp">Favorites</a></li>
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
                        <input type="hidden" name="referer" value="twitter-users.jsp"></input>
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
                            <h2 class="js-timeline-title">People Following <%=profile_full_name%></h2>
                        </div>
                    </div>
                </div>
                <div class="row">

                    <%

                    String profile_box_ID=null;
                    String profile_box_username=null;
                    String profile_box_full_name=null;
                    String profile_box_profile_text=null;
                    String timesProfileBoxFollowed=null;

                    //Get Dwitter profiles to show
                    String getAllProfilesQuery = "SELECT login_ID, username, full_name, profile_text FROM login_t WHERE login_ID IN (SELECT follower_ID AS login_ID FROM following_t WHERE followed_ID = ?);";
                    java.sql.PreparedStatement getAllProfilesPS = conn.prepareStatement(getAllProfilesQuery); // create a statement
                    getAllProfilesPS.setString(1, profile_ID); // set input parameter
                    java.sql.ResultSet getAllProfilesRS = getAllProfilesPS.executeQuery();
                    while (getAllProfilesRS.next())    // extract data from the ResultSet
                    {
                        profile_box_ID = getAllProfilesRS.getString("login_ID");
                        profile_box_username = getAllProfilesRS.getString("username");
                        profile_box_full_name = getAllProfilesRS.getString("full_name");
                        profile_box_profile_text = getAllProfilesRS.getString("profile_text");

                        String[] profileTextArray = profile_box_profile_text.split(" ");
                        profile_box_profile_text = "";
                        for(String word : profileTextArray)//Check for hashtags
                        {
                            word=word.replaceAll("&", "&amp;");
                            word=word.replaceAll("<", "&#60;");
                            word=word.replaceAll(">", "&gt;");
                            profile_box_profile_text=profile_box_profile_text+" "+word;
                        }
                                    

                            //Check if already following person tweeting
                            String checkIfFollowedQuery = "SELECT count(*) FROM following_t WHERE followed_ID = ? AND follower_ID = ?;";
                            java.sql.PreparedStatement checkIfFollowedPS = conn.prepareStatement(checkIfFollowedQuery); // create a statement
                            checkIfFollowedPS.setString(1, profile_box_ID); // set input parameter
                            checkIfFollowedPS.setString(2, login_ID); // set input parameter
                            java.sql.ResultSet checkIfFollowedRS = checkIfFollowedPS.executeQuery();
                            while (checkIfFollowedRS.next())    // extract data from the ResultSet
                            {
                                timesProfileBoxFollowed = checkIfFollowedRS.getString("count(*)");
                            }
    
                    %>
                    <div class="span4">
                        <div class="module mini-profile">
                            <div class="content">
                                <div class="account-group" style="height: 65px;">
                                    <a href="twitter-profile.jsp?profile=<%=profile_box_ID%>">
                                        <img class="avatar size64" src='<%="images/avatars/"+profile_box_ID+".jpg"%>' onerror="this.src='images/avatars/default.png'" alt='<%=profile_box_full_name%>' height="54" width="54">
                                        <b class="fullname"><%=profile_box_full_name%></b>
                                        <small class="metadata">@<%=profile_box_username%></small>

                                    </a>
                                    <br>
                                    <%if(!profile_box_ID.equals(login_ID)){%>
                                        <a href="twitter-togglefollower.jsp?followed_id=<%=profile_box_ID%>&referer=twitter-users.jsp">
                                            <button type="button" class="btn btn-default pull-right">
                                                <span style="margin-top: 2px;" class="<%if(timesProfileBoxFollowed.equals("0")){%>icon-eye-open<%}else{%>icon-eye-close<%}%>"></span>
                                                <%if(timesProfileBoxFollowed.equals("0")){%>Follow<%}else{%>Unfollow<%}%>
                                            </button>
                                        </a>
                                    <%}%>
                                </div>
                            </div>
                            
                            <div class="js-mini-profile-stats-container">
                                <ul class="stats">
                                    <div class="account-group" style="height: 95px;padding-top: 8px;padding-right: 8px;padding-bottom: 8px;padding-left: 8px; font-size: 14px;">
                                        <%=profile_box_profile_text%>
                                    </div>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <%}%>

                </div>
            </div><!-- End Right column-->
        </div><!-- End Row-->
    </div><!-- End Container Wrap-->
    <!-- Le javascript-->
    <!--================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>