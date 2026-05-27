<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Welcome</title>
<style>
    body {
        font-family: Arial, sans-serif;
        display: flex;
        flex-direction: column;
        align-items: start;
        justify-content: space-between;
        background: white;
        /* height: 100vh; */
        /* background: #f4f6f9; */
    }
    img {
        /* display: block; */
        /* margin: 20px auto; */
        /* border: 2px solid green; */
    }
    .div-img{
    /* border: 2px solid red; */
    display: flex;
    justify-content: flex-start;
    }
    .header{
    /* width: 100%; */
    display: flex;
    justify-content: space-between;
    /* margin-right: 10px; */
    /* padding-top: 10px; */
    /* border: 2px solid red; */
    }
</style>
</head>
<body>
    <!-- <h2>Login Successful!</h2>
    <p>Welcome to Exam App.</p> -->
    <div class="header">
    <div class="div-img">
    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="60">
    </div>
    </div>
    
</body>
</html>