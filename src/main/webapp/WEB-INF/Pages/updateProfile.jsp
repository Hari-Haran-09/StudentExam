<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Profile</title>
<style>
	body{
		height: 97vh;
	}
	.div-img{
		    display: flex;
		    justify-content: flex-start;
		}
    .parent {
        font-family: Arial, sans-serif;
        /*background: #f4f6f9;*/
        display: flex;
        justify-content: center;
        align-items: center;
        /*height: 97vh;*/
        margin: 0;
    }
 
    .form-container {
        background: #ffffff;
        padding-left: 30px;
        padding-right: 30px;
        padding-bottom: 15px;
        border-radius: 12px;
        box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
        width: 55%;
		margin-bottom: 25px;
        text-align: center;
    }
 
    h2 {
        text-align: center;
        color: #333;
        margin-bottom: 5px;
    }
 
    .already-text {
        color: #555;
        font-size: 16px;
        margin-top: 15px;
    }
 
    .login-text {
        color: #007bff;
        font-weight: bold;
        background: none;
        border: none;
        cursor: pointer;
        font-size: 16px;
        padding: 0;
        margin-left: 5px;
    }
 
    .login-text:hover {
        text-decoration: underline;
    }
 
    #edit {
        display: flex;
        padding-top: 5px;
        flex-wrap: wrap;
        gap: 2px;
        justify-content: space-between;
    }
 
    .form-group {
        width: 45%;
        display: flex;
        flex-direction: column;
        margin-bottom: 15px;
    }
 
    .form-group label {
        font-weight: bold;
        color: #555;
        margin-bottom: 5px;
        text-align: left;
    }
 
    .form-group input[type="text"],
    .form-group input[type="tel"],
    .form-group input[type="email"],
    .form-group input[type="password"],
    .form-group select {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 14px;
        transition: border 0.3s;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		margin-top: 7px;
    }
 
    .form-group input:focus,
    .form-group select:focus {
        border: 1px solid #007bff;
        outline: none;
        box-shadow: 0 0 8px rgba(0,123,255,0.4);
    }
 
    .form-actions {
        width: 100%;
        display: flex;
        justify-content: center;
        margin-top: 15px;
    }
 
    .form-actions input[type="submit"] {
        background: #007bff;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        cursor: pointer;
        padding: 10px 25px;
        transition: background 0.3s;
    }
 
    .form-actions input[type="submit"]:hover {
        background: #0056b3;
    }
 
    
</style>
</head>
<body>
	<div class="div-img">
		    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70" style="">
		    </div>
	<div class="parent">
		<div class="form-container">
		        <h2 style="padding-bottom: 19px">Update User Details</h2>
		        <form id="updateform" action="editProfile" method="post" style=" display: flex; flex-wrap: wrap; justify-content: space-between; gap: 3px;">
		            <div class="form-group">
		                <label>Full Name:</label>
		                <input type="text" id="name" name="name" required placeholder="Enter Your Full Name" value="<%= session.getAttribute("userName") %>">
		            </div>
		 
		            <div class="form-group">
		                <label>Role:</label>
		                <select id="role" name="role" required>
		                    <option value="" disabled selected>Select Role</option>
		                </select>
		            </div>
		 
		            <div class="form-group">
		                <label>Mobile Number:</label>
		                <input type="tel" id="phone" name="phone" required maxlength="10" pattern="[0-9]{10}" oninput="this.value = this.value.replace(/[^0-9]/g, '')" placeholder="Enter Your Mobile Number" value="<%= session.getAttribute("phoneNo") %>">
		            </div>
		 
		         <div class="form-group">
		                <label>Email:</label>
		                <input type="email" id="email" name="email" placeholder="Enter Your Email"
		                       value="<%= session.getAttribute("userEmail") %>" readonly>
		            </div>
		 
		            <div class="form-group">
		                <label>Gender:</label>
		                <select id="gender" name="gender" required>
		                    <option value="" disabled selected>Select Gender</option>
		                    <option value="Male">Male</option>
		                    <option value="Female">Female</option>
		                </select>
		            </div>
		 
		            <div class="form-group">
		                <label>Course:</label>
		                <select id="course" name="course" required>
		                    <option value="" disabled selected>Select Course</option>
		                </select>
		            </div>
		 
		            <div class="form-group">
		                <label>Specialization:</label>
		                <select id="specialization" name="specialization" required>
		                    <option value="" disabled selected>Select Specialization</option>
		                </select>
		            </div>
		 
		            <div class="form-group">
		                <label>Passout Year:</label>
		                <select id="passedout" name="passedout" required>
		                    <option value="" disabled selected>Select Year</option>
		                </select>
		            </div>
		 
		            <div class="form-group">
		                <label>College Name:</label>
		                <input type="text" id="collegeName" name="collegeName" required placeholder="Enter Your College Name" value="<%= session.getAttribute("collegeName") %>">
		            </div>
		 
		            <div class="form-group">
		                <label>Experience:</label>
		                <select id="experience" name="experience" required>
		                    <option value="" disabled selected>Select Experience</option>
		                </select>
		            </div>
		 
		            <div class="form-group">
		                <label>City:</label>
		                <input type="text" id="city" name="city" required placeholder="Enter Your City" value="<%= session.getAttribute("city") %>">
		            </div>
		 
		            <div class="form-group">
		                <label>State:</label>
		                <input type="text" id="state" name="state" required placeholder="Enter Your State" value="<%= session.getAttribute("state") %>">
		            </div>
		 
		            <div class="form-actions">
		                <input type="submit" value="Update Profile">
		            </div>
		        </form>
		 
		        <p class="already-text" style="">
					If you don’t want to update, you can
		            <button type="button" class="login-text" onclick="window.location.href='login'">
		                Login
		            </button>
		        </p>
		    </div>
	</div>
 <script>
	const currentRole = "<%= session.getAttribute("role") %>";
	    const currentGender = "<%= session.getAttribute("gender") %>";
	    const currentCourse = "<%= session.getAttribute("course") %>";
	    const currentSpec = "<%= session.getAttribute("specialization") %>";
	    const currentYear = "<%= session.getAttribute("passedOut") %>";
	    const currentExp = "<%= session.getAttribute("experience") %>";
		window.addEventListener("DOMContentLoaded", () => {
		    const genderSelect = document.getElementById("gender");
		    if (currentGender) genderSelect.value = currentGender;
		});
 </script>
	<!-- Separate scripts for each dropdown -->
	<script>
	window.addEventListener("DOMContentLoaded", () => {
	    fetch("${pageContext.request.contextPath}/student/getRoles")
	        .then(res => res.json())
	        .then(data => {
	            const roleSelect = document.getElementById("role");
	            data.forEach(role => {
	                const opt = document.createElement("option");
	                opt.value = role.role;
	                opt.textContent = role.role;
	                roleSelect.appendChild(opt);
	            });
				if (currentRole) roleSelect.value = currentRole;
	        });
	});
	</script>

	<script>
	window.addEventListener("DOMContentLoaded", () => {
	    fetch("${pageContext.request.contextPath}/student/getCourses")
	        .then(res => res.json())
	        .then(data => {
	            const courseSelect = document.getElementById("course");
	            data.forEach(course => {
	                const opt = document.createElement("option");
	                opt.value = course.courseName;
	                opt.textContent = course.courseName;
	                courseSelect.appendChild(opt);
	            });
				if (currentCourse) courseSelect.value = currentCourse;
	        });
	});
	</script>
	

	<script>
	window.addEventListener("DOMContentLoaded", () => {
	    fetch("${pageContext.request.contextPath}/student/getSpecializations")
	        .then(res => res.json())
	        .then(data => {
	            const specSelect = document.getElementById("specialization");
	            data.forEach(spec => {
	                const opt = document.createElement("option");
	                opt.value = spec.departmentName;
	                opt.textContent = spec.departmentName;
	                specSelect.appendChild(opt);
	            });
				if (currentSpec) specSelect.value = currentSpec;
	        });
	});
	</script>

	<script>
	window.addEventListener("DOMContentLoaded", () => {
	    fetch("${pageContext.request.contextPath}/student/getPassedout")
	        .then(res => res.json())
	        .then(data => {
	            const yearSelect = document.getElementById("passedout");
	            data.forEach(y => {
	                const opt = document.createElement("option");
	                opt.value = y.year;
	                opt.textContent = y.year;
	                yearSelect.appendChild(opt);
	            });
				if (currentYear) yearSelect.value = currentYear;
	        });
	});
	</script>

	<script>
	window.addEventListener("DOMContentLoaded", () => {
	    fetch("${pageContext.request.contextPath}/student/getExperience")
	        .then(res => res.json())
	        .then(data => {
	            const expSelect = document.getElementById("experience");
	            data.forEach(e => {
	                const opt = document.createElement("option");
	                opt.value = e.experience;
	                opt.textContent = e.experience;
	                expSelect.appendChild(opt);
	            });
				if (currentExp) expSelect.value = currentExp;
	        });
	});
	
	document.getElementById("updateform").addEventListener("submit", function (e) {
						    const confirmation = confirm("Do you want to update the data?");
						    if (!confirmation) {
						        e.preventDefault();
						    }
						});
	</script></body>
</html>
 