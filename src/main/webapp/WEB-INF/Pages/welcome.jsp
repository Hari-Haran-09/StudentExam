<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Welcome</title>
<style>
    /* your existing CSS styles - keep as is */
    body {
        font-family: Arial, sans-serif;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }
    h2 {
        color: #333;
    }
    p {
        color: #555;
    }
    button {
        background: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        margin-top: 20px;
    }
    .b1:hover {
        background: #0056b3;
        color: white;
    }
    .letstart{
    background: #2178BD;
    color: white;
    }
    
    .div1{
    width: 70%;
    margin: auto;
    padding-top: 110px;
    }
    .div2{
    width: 70%;
    margin: auto;
    text-align: center;
    }
    h1{
    font-size: 33px;
    }
    .div-img{
    display: flex;
    justify-content: flex-start;
    }
    .header{
    width: 100%;
    display: flex;
    justify-content: space-between;
    margin-left: 10px;
    margin-right: 10px;
    }
</style>
</head>
<body>
    <div class="header">
        <div class="div-img">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70">
        </div>
        <form action="profile" method="get">
            <input type="hidden" name="email" value="<%= session.getAttribute("userEmail") %>">
            <button type="submit" class="b1" onclick="window.location.href='profile.jsp'">Profile</button>
        </form>
    </div>
    
    <div class="div1">
        <div class="div2">
            <h1>Dream big, work hard, and let</h1>
            <h1>this exam be your next</h1>
            <h1>milestone</h1>
        </div>
    </div>
    
    <!--<div>
        <button type="button" class="letstart" onclick="startExam()">
            Let's Start <img src="${pageContext.request.contextPath}/images/arrow.png" alt="Logo" width="10" height="10">
        </button>
        <button type="button" class="admin1">
            <a href="${pageContext.request.contextPath}/student/admin1">Admin</a>
        </button>
    </div>-->
	
	
	
	<div>
	        <%
	            String role = (String) session.getAttribute("role");
	            if ("Admin".equalsIgnoreCase(role)) {
	        %>
	            <button type="button" class="admin1" style="background: #2178BD; color: white;">
	                <a href="${pageContext.request.contextPath}/student/admin1" style="color:white; text-decoration: none">Admin</a>
	            </button>
	        <%
	            } else {
	        %>
	            <button type="button" class="letstart" onclick="startExam()">
	                Let's Start <img src="${pageContext.request.contextPath}/images/arrow.png" alt="Logo" width="10" height="10">
	            </button>
	        <%
	            }
	        %>
	    </div>

    <script>
    function startExam() {
        // Simply redirect to exam details
        // Fullscreen will be handled in examDetails.jsp with user interaction
        window.location.href = "${pageContext.request.contextPath}/student/examDetails";
    }
    </script>
</body>
</html>