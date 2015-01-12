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
    
    String login_ID = (String)session.getAttribute("id");
    
    String username = null;
    String full_name = null;
    String email=null;
    String phone=null;
    String birth_date=null;
    String profile_text=null;

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

    /**********************************************************************/

    //Get Various Information from login_ID
    String getLoginInfoQuery = "SELECT username, full_name, email, phone, birth_date, profile_text FROM login_t WHERE login_ID = ?";

    java.sql.PreparedStatement getLoginInfoPS = conn.prepareStatement(getLoginInfoQuery); // create a statement
    getLoginInfoPS.setString(1, login_ID); // set input parameter
    java.sql.ResultSet getLoginInfoRS = getLoginInfoPS.executeQuery();
    
    while (getLoginInfoRS.next())    // extract data from the ResultSet
    {
        username = getLoginInfoRS.getString("username");
        full_name = getLoginInfoRS.getString("full_name");
        email = getLoginInfoRS.getString("email");
        phone = getLoginInfoRS.getString("phone");
        birth_date = getLoginInfoRS.getString("birth_date");
        profile_text=getLoginInfoRS.getString("profile_text");
    }
    /**********************************************************************/

    //Get List of all used usernames

    String getUsernamesQuery = "SELECT username FROM login_t";

    java.sql.PreparedStatement getUsernamesPS = conn.prepareStatement(getUsernamesQuery); // create a statement
    java.sql.ResultSet getUsernamesRS = getUsernamesPS.executeQuery();
    
    String usernames = "";
    String tempUsername=null;
    while (getUsernamesRS.next())    // extract data from the ResultSet
    {
        tempUsername=getUsernamesRS.getString("username");
        if(!tempUsername.equals(username))
        {
            usernames+=tempUsername+" ";
        }
    }

%>
<script>
    var runRepeat=setInterval(function () {validateForm()}, 100);
    function validateForm() {
        
            var full_name = document.forms["credentials-form"]["full-name"].value;
            var full_name_error = document.getElementById('full-name-error');
        
            var email = document.forms["credentials-form"]["email"].value;
            var email_error = document.getElementById('email-error');
            
            var username = document.forms["credentials-form"]["username"].value;
            var username_error = document.getElementById('username-error');

            var phone = document.forms["credentials-form"]["phone"].value;
            var phone_error = document.getElementById('phone-error');
            
            var profile_text = document.forms["credentials-form"]["profile_text"].value;

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

            var phoneNumRaw=phone.replace("-", "");
            phoneNumRaw=phoneNumRaw.replace("(", "");
            phoneNumRaw=phoneNumRaw.replace(")", "");

            console.log(phoneNumRaw);

            phone_error.style.display = 'none';
            for(var c=0; c<phoneNumRaw.length; c++)
            {
                if(!(phoneNumRaw.charAt(c)<10))
                {
                    console.log('Phone Bad');
                    phone_error.style.display = 'block';
                    allowProceed=0;
                }
            }

            if(phoneNumRaw.length!=10||phone.charAt(0)!='('||phone.charAt(4)!=')'||phone.charAt(8)!='-')
            {
                console.log('Phone Bad');
                phone_error.style.display = 'block';
                allowProceed=0;
            }

            console.log(profile_text);
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
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dwitter &middot Hashtag View</title>
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
                            <a href="#">
                                <img class="avatar size64" src='<%="images/avatars/"+login_ID+".jpg"%>' onerror="this.src='images/avatars/default.png'" alt='<%=full_name%>' height="54" width="54">
                                <b class="fullname"><%=full_name%></b>
                                <small class="metadata">@<%=username%></small>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title">Account Settings</strong></h2>
                        </div>
                    </div>

                    <!-- all settings -->
                    <div class="stream home-stream">
                        <form name=credentials-form action="twitter-updatelogin.jsp" enctype="multipart/form-data" class="signin" method="GET" onsubmit="return validateForm();">
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
                                            <input id="full-name" class="text-input email-input" placeholder="Full Name" defaultValue="<%=full_name%>" value="<%=full_name%>" name="full-name" title="First Name" autocomplete="on" tabindex="1" type="text" style="height: 29.81818175315857px;" onchange="validateForm()" onkeypress="validateForm()">
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
                                            <input id="email" class="text-input email-input" placeholder="Email Address" defaultValue="<%=email%>" value="<%=email%>" name="email" title="Email" autocomplete="on" tabindex="1" type="text" style="height: 29.81818175315857px;" onchange="validateForm()" onkeypress="validateForm()">
                                        </p>
                                        <p style="margin-bottom: 0px;">
                                            <small id="email-error" class="fullname"><font color="red">Doesn't look like a valid email.</font></small>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <!-- End Email Address -->
                            <!-- Choose Username -->
                            <div class="js-stream-item stream-item expanding-string-item">
                                <div class="tweet original-tweet">
                                    <div class="content"style="margin-left: 0px;">
                                        <div class="stream-item-header">
                                            <a class="account-group">                                       
                                                <strong class="fullname">Username</strong>
                                                <span>&rlm;</span>
                                            </a>
                                        </div>
                                        <p class="js-tweet-text" style="margin-bottom: 0px;">
                                            <input id="username" class="text-input email-input" placeholder="Username" defaultValue="<%=username%>" value="<%=username%>" name="username" title="Choose Username" autocomplete="on" tabindex="1" type="text" style="height: 29.81818175315857px;" onchange="validateForm()" onkeypress="validateForm()">
                                        </p>
                                        <p style="margin-bottom: 0px;">
                                            <small id="username-error" class="fullname"><font color="red">This username is already taken or contains special characters!</font></small>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <!-- End Choose Username -->
                            <!-- Choose Phone Number -->
                            <div class="js-stream-item stream-item expanding-string-item">
                                <div class="tweet original-tweet">
                                    <div class="content"style="margin-left: 0px;">
                                        <div class="stream-item-header">
                                            <a class="account-group">                                       
                                                <strong class="fullname">Cellphone Number</strong>
                                                <span>&rlm;</span>
                                            </a>
                                        </div>
                                        <p class="js-tweet-text" style="margin-bottom: 0px;">
                                            <input id="phone" class="text-input email-input" placeholder="(###)###-####" defaultValue="<%=phone%>" value="<%=phone%>" name="phone" title="Choose Phone Number" autocomplete="on" tabindex="1" type="text" style="height: 29.81818175315857px;" onchange="validateForm()" onkeypress="validateForm()">
                                        </p>
                                        <p style="margin-bottom: 0px;">
                                            <small id="phone-error" class="fullname"><font color="red">Phone Format Invalid.  Required: "(###)###-####".</font></small>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <!-- End Choose Phone Number -->
                            <!-- Choose Profile Text -->
                            <div class="js-stream-item stream-item expanding-string-item">
                                <div class="tweet original-tweet">
                                    <div class="content"style="margin-left: 0px;">
                                        <div class="stream-item-header">
                                            <a class="account-group">                                       
                                                <strong class="fullname">Profile Text</strong>
                                                <span>&rlm;</span>
                                            </a>
                                        </div>
                                        <p class="js-tweet-text" style="margin-bottom: 0px;">
                                            <textarea id="profile_text" class="text-input email-input" placeholder="Profile Text" defaultValue="<%=profile_text%>" value="<%=profile_text%>" name="profile_text" title="Profile Text" autocomplete="on" tabindex="1" type="text" style="height: 80.81818175315857px; width: 260px;" onchange="validateForm()" onkeypress="validateForm()"><%=profile_text%></textarea>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <!-- End Choose Profile Text -->
                            <!-- Choose Birthday -->
                            <div class="js-stream-item stream-item expanding-string-item">
                                <div class="tweet original-tweet">
                                    <div class="content"style="margin-left: 0px;">
                                        <div class="stream-item-header">
                                            <a class="account-group">                                       
                                                <strong class="fullname">Birthday</strong>
                                                <span>&rlm;</span>
                                            </a>
                                        </div>
                                        <p class="js-tweet-text" style="margin-bottom: 0px;">
                                            <input type="date" name="birth_date" title="Birth Date" defaultValue="<%=birth_date%>" value="<%=birth_date%>" autocomplete="on" max="2050-01-01" min="1960-01-01" tabindex="1" type="text" style="width: 260px;" onchange="validateForm()" onkeypress="validateForm()">
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <!-- End Choose Birthday -->
                            <!-- Upload Avatar -->
                            <div class="js-stream-item stream-item expanding-string-item">
                                <div class="tweet original-tweet">
                                    <div class="content"style="margin-left: 0px;">
                                        <div class="stream-item-header">
                                            <a class="account-group">                                       
                                                <strong class="fullname">Upload an Avatar</strong>
                                                <span>&rlm;</span>
                                            </a>
                                        </div>
                                        <p class="js-tweet-text" style="margin-bottom: 0px;">
                                            <input type="file" name="avatar" accept="image/*" title="Avatar" autocomplete="on" tabindex="1" style="width: 260px;" onchange="validateForm()" onkeypress="validateForm()">
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <!-- End Upload Avatar -->
                            <!-- Sign Up Button -->
                            <div class="js-stream-item stream-item expanding-string-item" style="height: 40px;">
                                <div class="tweet original-tweet" style="height: 30px; padding-bottom: 0px;">
                                    <div class="content"style="margin-left: 0px;">
                                        <p class="js-tweet-text" style="margin-bottom: 0px;">
                                            <button type="submit" class="btn btn-signup" value="upload" style="background-image: linear-gradient(to bottom, #fee94f, #fd9a0f); background-repeat: repeat-x; border-color: #FA2; background-color: #fec935;">Save Changes</button>
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