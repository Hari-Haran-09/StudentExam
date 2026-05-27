<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forget Password</title>
    <style>
		.div-img{
					    display: flex;
					    justify-content: flex-start;
					}
        .parent2 {
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
			margin-bottom: 21px;
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
		}

		.toggle-password:hover {
		    opacity: 1;
		}
    </style>
</head>
<body>


	<div class="div-img">
			    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70" style="">
			    </div>
    <div class="parent2">
		<div class="form-container">
		        <h2>Forget Password</h2>
		        <form id="forgetform" action="forget" method="post">
		            <label for="email">Email</label>
		            <input type="email" id="email" name="email" placeholder="Enter Your Email" required>
					<label>Password:</label>
								    <div class="password-wrapper">
								        <input type="password" id="password" name="password" placeholder="Enter Your Password" required
								            pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$"
								            title="Password must be at least 8 characters long, include uppercase and lowercase letters, a number, and a special character.">
								        <img src="${pageContext.request.contextPath}/images/hide.png"
								             alt="Toggle Password" class="toggle-password" onclick="togglePassword()">
								    </div>
		            <button type="submit">Forget</button>
		        </form>
		    </div>
	</div>
	<script>
		document.getElementById("forgetform").addEventListener("submit", function (e) {
					    const confirmation = confirm("Do you want to update the password?");
					    if (!confirmation) {
					        e.preventDefault();
					    }
					});
	</script>
	<script>
	function togglePassword() {
	    const passwordInput = document.getElementById("password");
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
 