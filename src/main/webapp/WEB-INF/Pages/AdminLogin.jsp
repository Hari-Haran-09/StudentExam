<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
		.div-img{
			    display: flex;
			    justify-content: flex-start;
			}
        .parent1 {
            font-family: Arial, sans-serif;
            /*background: #f4f6f9;*/
            display: flex;
            justify-content: center;
            align-items: center;
            height: 80vh;
			width: 99%;
        }
        .form-container {
            background: #fff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            width: 25%;
			border: 1.5px solid rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
            display: block;
            margin: 10px 0 5px;
			padding-top: 10px;
        }
        input {
            width: 95%;
            padding: 11px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
			width: 100%;
            background: #2178BD;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
			margin-top: 15px;
        }
        button:hover {
            background: #0056b3;
        }
		
		
		.password-wrapper {
				    position: relative;
				    display: flex;
				    align-items: center;
				}
			 
				.password-wrapper input {
				    width: 100%;
				    padding-right: 40px;
				}
			 
				.toggle-password {
				    position: absolute;
				    right: 10px;
				    width: 22px;
				    height: 22px;
				    cursor: pointer;
				    opacity: 0.7;
				    transition: opacity 0.2s ease;
					/*border: 2px solid red;*/
					margin-bottom: 13px;
				}
			 
				.toggle-password:hover {
				    opacity: 1;
				}
    </style>
</head>
<body>
	<c:if test="${not empty message}">
	    <script>
	        alert("${message}");
	    </script>
	</c:if>

	<div class="div-img">
		    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70" style="">
		    </div>
	<div class="parent1">
		<div class="form-container">
		        <h2>Login</h2>

		        <c:if test="${not empty error}">
		            <p style="color:red; text-align:center;">${error}</p>
		        </c:if>

		        <form id="loginform" action="Adminlogin" method="post">
		            <label for="email">Email</label>
		            <input type="email" id="email" name="email" placeholder="Enter Your Email" required>

		            <!--<label for="pwd">Password</label>
		            <input type="password" id="pwd" name="pwd" placeholder="Enter Your Password" required>-->
				
														    <label for="pwd">Password</label>
														    <div class="password-wrapper">
														        <input  id="pwd" name="pwd" name="password" placeholder="Enter Your Password" required >
														        <img src="${pageContext.request.contextPath}/images/hide.png"
														             alt="Toggle Password" class="toggle-password" onclick="togglePassword()">
														    </div>
					<a href="${pageContext.request.contextPath}/student/forgetPassword" style="display:block; padding-bottom: 25px; color: #2178BD; text-decoration: none">
							            Forgot Password?
							        </a>

		            <button type="submit">Login</button>
		        </form>

		        <p style="margin-top:17px">Don't have an account? <a href="${pageContext.request.contextPath}/student/register" style="text-decoration: none; color: #2178BD">
		            Sign up
		        </a></p>
		    </div>
	</div>
	<script>
		document.getElementById("loginform").addEventListener("submit", function (e) {
							    const confirmation = confirm("Do you want to login?");
							    if (!confirmation) {
							        e.preventDefault();
							    }
							});
							
							
							function togglePassword() {
							    const passwordInput = document.getElementById("pwd");
							    const icon = document.querySelector(".toggle-password");

							    if (passwordInput.type === "password") {
							        passwordInput.type = "text";
							        icon.src = "${pageContext.request.contextPath}/images/eye.png";
							    } else {
							        passwordInput.type = "password";
							        icon.src = "${pageContext.request.contextPath}/images/hide.png";
							    }
							}

	</script>
</body>
</html>

