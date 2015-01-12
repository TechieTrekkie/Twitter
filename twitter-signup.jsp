<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%@ page import="java.io.*" %>

<%
	String full_name = request.getParameter("full_name");
	if(full_name==null)
		full_name="";
		
	String email = request.getParameter("email");
	if(email==null)
		email="";
		
	String pass = request.getParameter("pass");
	if(pass==null)
		pass="";

	PrintWriter pw = new PrintWriter(new FileOutputStream("/home/dazzam/public_html/twitter_dir/usernameList.txt"));
    
	java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/dazzam_twitter";   //location and name of database
    String userid = "dazzam";
    
    Scanner in = new Scanner(new FileReader("/home/dazzam/public_html/twitter_dir/SQL_Login.txt"));
    String password=in.nextLine();
    
    conn = DriverManager.getConnection(url, userid, password);      //connect to database

    /**********************************************************************/

	//Get Profile Username from login_ID
    String getUsernamesQuery = "SELECT username FROM login_t";

    java.sql.PreparedStatement getUsernamesPS = conn.prepareStatement(getUsernamesQuery); // create a statement
    java.sql.ResultSet getUsernamesRS = getUsernamesPS.executeQuery();
    
    String usernames = "";
    while (getUsernamesRS.next())    // extract data from the ResultSet
    {
    	usernames+=getUsernamesRS.getString("username")+" ";
    }
    pw.close();
%>

<script>
	var runRepeat=setInterval(function () {validateForm()}, 100);
	function validateForm() {
		
			var full_name = document.forms["credentials-form"]["full-name"].value;
			var full_name_error = document.getElementById('full-name-error');
		
	    	var email = document.forms["credentials-form"]["email"].value;
			var email_error = document.getElementById('email-error');
    		
    		var password = document.forms["credentials-form"]["password"].value;
    		var password_error = document.getElementById('password-error');
    		
    		var username = document.forms["credentials-form"]["username"].value;
    		var username_error = document.getElementById('username-error');
    			
    		var usernames = document.getElementById('usernames').innerHTML.split(" ");
    		console.log(usernames);
    		
    		var allowProceed=1;
    		
    		if(full_name.length==0)
    		{
    			console.log('Name BAD');
    			full_name_error.style.display = 'block';
    			allowProceed=0;
    		}
    		else
    		{
    			console.log('Name GOOD');
    			full_name_error.style.display = 'none';
    		}
    		
    		if(validateEmail(email))
    		{
    			console.log('Email GOOD');
    			email_error.style.display = 'none';
    		}
    		else
    		{
    			console.log('Email BAD');
    			email_error.style.display = 'block';
    			allowProceed=0;
    		}
    		
    		if(password.length<6)
    		{
    			console.log('Password BAD');
    			password_error.style.display = 'block';
    			allowProceed=0;
    		}
    		else
   		 	{
   		 		console.log('Password GOOD');
		    	password_error.style.display = 'none';
	    	}
	    	
	    	username_error.style.display = 'none';
	    	
	    	for(var i=0; i<usernames.length; i++)
	    	{
	    		if(usernames[i].toLowerCase()===username.toLowerCase())
	  		  	{
	  		  		console.log('Username Bad');
	    			username_error.style.display = 'block';
	    			allowProceed=0;
	    		}
	    	}
	    	
	    	for(var c=0; c<username.length; c++)
	    	{
	    		if(username.charAt(c).toLowerCase() == username.charAt(c).toUpperCase())
	    		{
	    			console.log('Username Bad');
	    			username_error.style.display = 'block';
	    			allowProceed=0;
	    		}
	    	}

	    	console.log(allowProceed);
	    	
	    	
	    	if(allowProceed==0)
	    	{
	    		return false;
	    	}
	    	else
	    	{
	    		return true;
	    	}
	}
	
	function validateEmail(email) { 
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
	} 
</script>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Dwitter &middot Sign Up</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
     <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
     
    <style type="text/css">
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }

      .form-signin {
        max-width: 300px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }

    </style>

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="icon" type="image/png" href="images/brand.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">
  </head>

<body class="user-style-theme1" onload="validateForm()">
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
					</ul>
					<p class="navbar-text pull-right">Not Logged In</a>
					</p>
                </div>
			</div>
	</div>

    <div class="container wrap" style="padding-top: 40px;">
        <div class="row">

            <!-- middle column -->
            <div class="span8 offset2 content-main">
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title">Join Twitter Today.</h2>
                        </div>
                    </div>

                    <!-- all settings -->
                    <div class="stream home-stream">
                    	<form name=credentials-form action="twitter-addlogin.jsp" class="signin" method="POST" onsubmit="return validateForm();">
                        	<!-- Full Name -->
                        	<div class="js-stream-item stream-item expanding-string-item">
                            	<div class="tweet original-tweet">
                                	<div class="content"style="margin-left: 0px;">
                                    	<div class="stream-item-header">
                                        	<a class="account-group">                                       
                                            	<strong class="fullname">Full Name</strong>
                                            	<span>&rlm;</span>
                                        	</a>
                                    	</div>
                                    	<p class="js-tweet-text" style="margin-bottom: 0px;">
                                        	<input id="full-name" class="text-input email-input" placeholder="Full Name" value="<%=full_name%>" name="full-name" title="First Name" autocomplete="on" tabindex="1" type="text" style="height: 29.81818175315857px;" onchange="validateForm()" onkeypress="validateForm()">
                                    	</p>
                                    	<p style="margin-bottom: 0px;">
                                    		<small id="full-name-error" class="fullname"><font color="red">A name is required!</font></small>
                                    	</p>
                                	</div>
                            	</div>
                        	</div>
                        	<!-- End Full Name -->
                        	<!-- Email Address -->
                        	<div class="js-stream-item stream-item expanding-string-item">
                            	<div class="tweet original-tweet">
                                	<div class="content"style="margin-left: 0px;">
                                    	<div class="stream-item-header">
                                        	<a class="account-group">                                       
                                            	<strong class="fullname">Email Address</strong>
                                            	<span>&rlm;</span>
                                        	</a>
                                    	</div>
                                    	<p class="js-tweet-text" style="margin-bottom: 0px;">
                                        	<input id="email" class="text-input email-input" placeholder="Email Address" value="<%=email%>" name="email" title="Email" autocomplete="on" tabindex="1" type="text" style="height: 29.81818175315857px;" onchange="validateForm()" onkeypress="validateForm()">
                                    	</p>
                                    	<p style="margin-bottom: 0px;">
                                    		<small id="email-error" class="fullname"><font color="red">Doesn't look like a valid email.</font></small>
                                    	</p>
                                	</div>
                            	</div>
                        	</div>
                        	<!-- End Email Address -->
                        	<!-- Create Password -->
                        	<div class="js-stream-item stream-item expanding-string-item">
                            	<div class="tweet original-tweet">
                                	<div class="content"style="margin-left: 0px;">
                                    	<div class="stream-item-header">
                                        	<a class="account-group">                                       
                                            	<strong class="fullname">Create a Password</strong>
                                            	<span>&rlm;</span>
                                        	</a>
                                    	</div>
                                    	<p class="js-tweet-text" style="margin-bottom: 0px;">
                                        	<input id="password" class="text-input email-input" placeholder="Password" value="<%=pass%>" name="password" title="Create Password" autocomplete="on" tabindex="1" type="password" style="height: 29.81818175315857px;" onchange="validateForm()" onkeypress="validateForm()">
                                    	</p>
                                    	<p style="margin-bottom: 0px;">
                                    		<small id="password-error" class="fullname"><font color="red">Password must be at least 6 characters.</font></small>
                                    	</p>
                                	</div>
                            	</div>
                        	</div>
                        	<!-- End Create Password -->
                        	<!-- Choose Username -->
                        	<div class="js-stream-item stream-item expanding-string-item">
                            	<div class="tweet original-tweet">
                                	<div class="content"style="margin-left: 0px;">
                                    	<div class="stream-item-header">
                                        	<a class="account-group">                                       
                                            	<strong class="fullname">Choose a Username</strong>
                                            	<span>&rlm;</span>
                                        	</a>
                                    	</div>
                                    	<p class="js-tweet-text" style="margin-bottom: 0px;">
                                        	<input id="username" class="text-input email-input" placeholder="Username" name="username" title="Choose Username" autocomplete="on" tabindex="1" type="text" style="height: 29.81818175315857px;" onchange="validateForm()" onkeypress="validateForm()">
                                    	</p>
                                    	<p style="margin-bottom: 0px;">
                                       		<small id="username-error" class="fullname"><font color="red">This username is already taken or contains special characters!</font></small>
                                    	</p>
                                	</div>
                            	</div>
                        	</div>
                        	<!-- End Choose Username -->
                        	<!-- Sign Up Button -->
                        	<div class="js-stream-item stream-item expanding-string-item" style="height: 40px;">
                            	<div class="tweet original-tweet" style="height: 30px; padding-bottom: 0px;">
                                	<div class="content"style="margin-left: 0px;">
                                    	<p class="js-tweet-text" style="margin-bottom: 0px;">
                                    		<button type="submit" class="btn btn-signup" style="background-image: linear-gradient(to bottom, #fee94f, #fd9a0f); background-repeat: repeat-x; border-color: #FA2; background-color: #fec935;">Sign Up</button>
                                    	</p>
                                	</div>
                            	</div>
                        	</div>
                        	<!-- End Sign Up Button -->
                    	</form>
                    	<p id="usernames" hidden><%=usernames%></p>
                    </div>
                    <div class="stream-footer"></div>
                    <div class="stream-autoplay-marker"></div>
                </div>
                </div>
               
            </div>
        </div>
    </div>
     <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>
