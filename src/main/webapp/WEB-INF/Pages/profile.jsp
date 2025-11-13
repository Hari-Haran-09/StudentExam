<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Profile Details</title>
<style>
    body {
        /* border: 2px solid red; */
        font-family: Arial, sans-serif;
        /* width: 100%; */
        /* background: #f4f6f9; */
    }
    .div1 {
        width: 70%;
        margin: auto;
        padding: 20px;
        background: #fff;
        border-radius: 8px;
        /* box-shadow: 0 0 8px rgba(0,0,0,0.1); */
    }
    .h11 {
        font-family: Arial, sans-serif;
        font-weight: 900;
        padding-bottom: 10px;
        width: 80%;
        margin: auto;
        text-align: start;
        color: #333;
        /* border: 2px solid red; */
    }
    .div2 {
        width: 80%;
        margin: auto;
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
		margin-top: 20px;
    }
    .div4{
        width: 80%;
        margin: auto;
        display:flex;
        justify-content: space-between;
    }
    .update{
    margin-left: 10px;
    padding-top: 11px;
    padding-bottom: 11px;
    padding-left: 33px;
    padding-right: 33px;
    background: #2B2BDA;
    color: white;
	width: fit-content;
    border-radius: 8px;
    }
    .home{
    margin-left: 10px;
    padding-top: 11px;
    padding-bottom: 11px;
    padding-left:29px;
    padding-right: 29px;
    background: #0D9D53;
    color: white;
    border-radius: 8px;
    }
    .div3 {
        width: 45%;
        margin-bottom: 15px;
        padding: 7px;
        /* background: #f9f9f9; */
        border-radius: 5px;
		/*display: flex;*/
		gap: 3px;
    }
    .div3 p {
        margin: 5px 0;
        color: #555;
    }
    .div3 p:first-child {
        font-weight: bold;
        color: #333;
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
</style>
</head>
<body class="body">
    <div class="div-img">
    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70">
    </div>
    <div class="div1">
        <h3 class="h11">Profile Details</h3>
        <div class="div2">
            <div class="div3">
                <p>Full Name</p>
                <p>${student.name}</p>
            </div>
            <div class="div3">
                <p>Role</p>
                <p>${student.role}</p>
            </div>
            <div class="div3">
                <p>Mobile Number</p>
                <p>${student.phone}</p>
            </div>
            <div class="div3">
                <p>Email</p>
                <p>${student.email}</p>
            </div>
            <div class="div3">
                <p>Gender</p>
                <p>${student.gender}</p>
            </div>
            <div class="div3">
                <p>Course</p>
                <p>${student.course}</p>
            </div>
            <div class="div3">
                <p>Specialization</p>
                <p>${student.specialization}</p>
            </div>
            <div class="div3">
                <p>Passout Year</p>
                <p>${student.passedout}</p>
            </div>
            <div class="div3">
                <p>College Name</p>
                <p>${student.collegeName}</p>
            </div>
            <div class="div3">
                <p>Experience</p>
                <p>${student.experience}</p>
            </div>
            <div class="div3">
                <p>City</p>
                <p>${student.city}</p>
            </div>
            <div class="div3">
                <p>State</p>
                <p>${student.state}</p>
            </div>
        </div>
        <div class="div4">
    <button style="border: none" type="button" class="update" onclick="window.location.href='update'">
        Edit Profile
    </button>
    <!--<button type="button" class="back" onclick="window.location.href='welcome.jsp'">
        Back
    </button>-->
	<button type="button" style="border: none" class="home" onclick="window.location.href='home'">
	    Back
	</button>

</div>
        
    </div>
	
</body>
</html>