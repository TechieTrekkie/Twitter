<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.security.*" %>

<%@ page import="org.apache.commons.codec.binary.DigestUtils.*" %>
<%@ page import="org.apache.commons.codec.binary.*" %>
<%@ page import="org.apache.commons.codec.digest.*" %>

<!DOCTYPE html>
<html lang="en">
<%
	session.invalidate(); 
	response.sendRedirect("twitter-signin.jsp");
%>
