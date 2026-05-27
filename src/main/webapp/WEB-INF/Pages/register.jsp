<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Registration</title>
<style>
	body{
		height: 97vh;
	}
    .parent {
        font-family: Arial, sans-serif;
        /*background: #f4f6f9;*/
        display: flex;
        justify-content: center;
        align-items: center;
        /*height: 100vh;*/
        margin: 0;
    }
 
    .form-container {
		margin-top: 10px;
        background: #ffffff;
		padding-left: 30px;
		padding-right: 30px;
		padding-bottom: 5px;
		padding-top: 5px;
        border-radius: 12px;
        box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
        width: 50%;
        text-align: center;
		/*height: 81vh;*/
		margin-bottom: 25px;
    }
 
    h2 {
        text-align: center;
        color: #333;
        margin-bottom: 19px;
    }
 
    .regForm {
        display: flex;
        flex-wrap: wrap;
        gap: 3px;
        justify-content: space-between;
    }
 
    .form-group {
        width: 45%;
        display: flex;
        flex-direction: column;
        margin-bottom: 11px;
    }
 
    .form-group label {
        font-weight: bold;
        color: #555;
        margin-bottom: 10px;
        text-align: left;
    }
 
    .form-group input,
    .form-group select {
        padding: 7px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 14px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
 
    .form-actions {
        width: 100%;
        display: flex;
        justify-content: center;
        margin-top: 11px;
		margin-bottom: 5px;
    }
 
    .form-actions input[type="submit"] {
        background: #2178BD;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        cursor: pointer;
        /*padding: 10px 25px;*/
		padding-left: 25px;
		padding-right: 25px;
		padding-top: 8px;
		padding-bottom: 8px;
    }
 
    .form-actions input[type="submit"]:hover {
        background: #0056b3;
    }
 
    @media (max-width: 600px) {
        .form-group { width: 100%; }
    }
	.div-img{
	    display: flex;
	    justify-content: flex-start;
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
	
	/* Style for optional fields */
	.optional-field {
	    opacity: 0.7;
	}
	
	.optional-field label::after {
	    content: " (Optional)";
	    font-weight: normal;
	    color: #666;
	    font-size: 0.9em;
	}

	.loader {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.85);
    z-index: 9999;

    flex-direction: column;
    justify-content: center;
    align-items: center;

    backdrop-filter: blur(3px);
}

.spinner {
    width: 55px;
    height: 55px;
    border: 5px solid #dcdcdc;
    border-top: 5px solid #2178BD;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 18px;
}

#loadingText {
    font-size: 20px;
    font-weight: bold;
    color: #2178BD;
    letter-spacing: 0.5px;
}

@keyframes spin {
    100% {
        transform: rotate(360deg);
    }
}
</style>
</head>
<body>
	
	<c:if test="${not empty error}">
	    <script>
	        alert("${error}");
	    </script>
	</c:if>
 
	<c:if test="${not empty message}">
	    <script>
	        alert("${message}");
	    </script>
	</c:if>
	
	<div class="div-img">
	    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70" style="">
	</div>
	
	<div class="parent">
		<div class="form-container">
		    <h2>Sign Up</h2>
 
		    <form class="regForm" id="registerform" action="${pageContext.request.contextPath}/student/register" method="post" enctype="multipart/form-data">
		        <div class="form-group">
		            <label>Full Name:</label>
		            <input type="text" name="name" required placeholder="Enter Your Full Name" id="name">
		        </div>
 
		        <div class="form-group">
		            <label>Role:</label>
		            <select id="role" name="role" required onchange="toggleFields()">
		                <option value="" disabled selected>Select Role</option>
		            </select>
		        </div>
 
		        <div class="form-group">
		            <label>Mobile Number:</label>
		            <input type="tel" name="phone" required maxlength="10" pattern="[0-9]{10}" oninput="this.value = this.value.replace(/[^0-9]/g, '')" placeholder="Enter Your Mobile Number" id="phone">
		        </div>
 
		        <div class="form-group">
		            <label>Email:</label>
		            <input type="email" name="email" required placeholder="Enter Your Email" id="email">
		        </div>
 
		        <div class="form-group">
		            <label>Gender:</label>
		            <select name="gender" required id="gender">
		                <option value="" disabled selected>Select Gender</option>
		                <option value="Male">Male</option>
		                <option value="Female">Female</option>
		            </select>
		        </div>
 
		        <div class="form-group" id="courseGroup">
		            <label>Course:</label>
		            <select id="course" name="course" required>
		                <option value="" disabled selected>Select Course</option>
		            </select>
		        </div>
 
		        <div class="form-group" id="specializationGroup">
		            <label>Specialization:</label>
		            <select id="specialization" name="specialization" required>
		                <option value="" disabled selected>Select Specialization</option>
		            </select>
		        </div>
 
		        <div class="form-group" id="passedoutGroup">
		            <label>Passout Year:</label>
		            <select id="passedout" name="passedout" required>
		                <option value="" disabled selected>Select Year</option>
		            </select>
		        </div>
 
		        <div class="form-group" id="collegeNameGroup">
		            <label>College Name:</label>
		            <input type="text" name="collegeName" required placeholder="Enter Your College Name" id="collegeName">
		        </div>
 
		        <div class="form-group" id="experienceGroup">
		            <label>Experience:</label>
		            <select id="experience" name="experience" required>
		                <option value="" disabled selected>Select Experience</option>
		            </select>
		        </div>
 
		        <div class="form-group" id="cityGroup">
		            <label>City:</label>
		            <input type="text" name="city" required placeholder="Enter Your City" id="city">
		        </div>
 
		        <div class="form-group" id="stateGroup">
		            <label>State:</label>
		            <input type="text" name="state" required placeholder="Enter Your State" id="state">
		        </div>
 
		        <div class="form-group password-field" id="passwordGroup">
				    <label>Password:</label>
				    <div class="password-wrapper">
				        <input type="password" id="password" name="password" placeholder="Enter Your Password" required
				            pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$"
				            title="Password must be at least 8 characters long, include uppercase and lowercase letters, a number, and a special character.">
				        <img src="${pageContext.request.contextPath}/images/hide.png"
				             alt="Toggle Password" class="toggle-password" onclick="togglePassword()">
				    </div>
				</div>
				
				<div style="display:flex; align-items:flex-end; gap:40px; flex-wrap:wrap; width:100%;">

    <div class="form-group" id="aadharNumberGroup">
        <label>Aadhaar Number:</label>

        <input
            type="text"
            id="aadharNumber"
            name="aadharNumber"
            required
            maxlength="12"
            placeholder="Enter Your Aadhaar Number"
            style="width:100%;"
        >
    </div>

    <div class="form-group" id="aadharFileGroup">
        <label>Aadhaar File (.jpg, .png):</label>

        <input
            type="file"
            id="aadharFile"
            name="aadharFile"
            required
            accept="image/*"
            style="max-width:300px;"
        >

        <input
            type="hidden"
            id="aadhaarVerified"
            name="aadhaarVerified"
            value="false"
        >
    </div>

</div>
							<div class="form-actions">
								            <input type="submit" value="REGISTER">
								        </div>
							
		    </form>
 
		    <p style="margin-top:10px;">Already have an account?  <a href="${pageContext.request.contextPath}/student/login" style="text-decoration: none; color: #2178BD; padding-top: 10px">Sign in By User</a><a href="${pageContext.request.contextPath}/student/Adminlogin" style="text-decoration: none; color: #2178BD; padding-top: 10px; margin-left:15px">Sign in By Admin</a></p>
		</div>
	</div>
	
	<div style="padding-bottom: 21px; text-center; margin: auto; width: fit-content">
		<p>By logging in, you agree to our Privacy Policy & Terms of Use</p>
	</div>
	<script>
	document.getElementById("verifyBtn").addEventListener("click", async (event) => {
	  event.preventDefault();
	
	  const aadharNumber = document.getElementById("aadharNumber").value.trim();
	  const aadharFile = document.getElementById("aadharFile").files[0];
	
	  // Validate Aadhar number
	  if (!aadharNumber) {
	    alert("Please enter Aadhar number");
	    return;
	  }
	
	  // Validate Aadhar number format (12 digits)
	  if (!aadharNumber.match(/^\d{12}$/)) {
	    alert("Please enter a valid 12-digit Aadhar number");
	    return;
	  }
	
	  // Validate Aadhar file
	  if (!aadharFile) {
	    alert("Please select an Aadhar file");
	    return;
	  }
	
	  // Validate file type
	  const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];
	  if (!allowedTypes.includes(aadharFile.type)) {
	    alert("Please upload only JPEG or PNG images");
	    return;
	  }
	
	
	  const maxSize = 10 * 1024 * 1024;
	  if (aadharFile.size > maxSize) {
	    alert("File size should be less than 10MB");
	    return;
	  }
	
	  // Show loading state
	  const verifyBtn = document.getElementById("verifyBtn");
	  const originalText = verifyBtn.textContent;
	  verifyBtn.textContent = "Verifying...";
	  verifyBtn.disabled = true;
	
	  try {
	    const url = "<%=request.getContextPath()%>/student/verifyAadhar";
	
	    // ✅ FIXED: Use correct parameter name
	    const formData = new FormData();
	    formData.append("aadharFile", aadharFile);  // This matches your backend parameter name
	    formData.append("aadharNumber", aadharNumber);
	
	    const response = await fetch(url, {
	      method: "POST",
	      body: formData
	    });
	
	    const result = await response.json();
	
	    if (result.success) {
	      alert("✅ Aadhar verified successfully");
	      verifyBtn.style.backgroundColor = "#28a745";
	      verifyBtn.textContent = "Verified ✓";
		  
		  document.getElementById("aadhaarVerified").value = "true";
	      
	      // Optional: Enable main form submission or proceed to next step
	      console.log("Aadhar verification successful");
	    } else {
	      alert("❌ Aadhar verification failed: " + result.message);
	      verifyBtn.textContent = originalText;
	      verifyBtn.disabled = false;
		
		  
	    }
	
	  } catch (error) {
	    console.error("Error verifying Aadhar:", error);
	    alert("Something went wrong. Please try again.");
	    verifyBtn.textContent = originalText;
	    verifyBtn.disabled = false;
		
	  }
	});
	</script>
<script>
// Function to toggle field requirements based on role
function toggleFields() {
    const roleSelect = document.getElementById('role');
    const selectedRole = roleSelect.value;
    
    // Get all field groups (except basic fields)
    const courseGroup = document.getElementById('courseGroup');
    const specializationGroup = document.getElementById('specializationGroup');
    const passedoutGroup = document.getElementById('passedoutGroup');
    const collegeNameGroup = document.getElementById('collegeNameGroup');
    const experienceGroup = document.getElementById('experienceGroup');
    const cityGroup = document.getElementById('cityGroup');
    const stateGroup = document.getElementById('stateGroup');
    const passwordGroup = document.getElementById('passwordGroup');
    const aadharNumberGroup = document.getElementById('aadharNumberGroup');
    const aadharFileGroup = document.getElementById('aadharFileGroup');
    
    // Get the input elements
    const course = document.getElementById('course');
    const specialization = document.getElementById('specialization');
    const passedout = document.getElementById('passedout');
    const collegeName = document.getElementById('collegeName');
    const experience = document.getElementById('experience');
    const city = document.getElementById('city');
    const state = document.getElementById('state');
    const password = document.getElementById('password');
    const aadharNumber = document.getElementById('aadharNumber');
    const aadharFile = document.getElementById('aadharFile');
    
    if (selectedRole === 'Admin') {
        // For Admin: Only basic fields are required, others are optional
        makeOptional(courseGroup, course);
        makeOptional(specializationGroup, specialization);
        makeOptional(passedoutGroup, passedout);
        makeOptional(collegeNameGroup, collegeName);
        makeOptional(experienceGroup, experience);
        makeOptional(cityGroup, city);
        makeOptional(stateGroup, state);
        makeOptional(passwordGroup, password);
        makeOptional(aadharNumberGroup, aadharNumber);
        makeOptional(aadharFileGroup, aadharFile);
    } else {
        // For other roles: All fields are required
        makeRequired(courseGroup, course);
        makeRequired(specializationGroup, specialization);
        makeRequired(passedoutGroup, passedout);
        makeRequired(collegeNameGroup, collegeName);
        makeRequired(experienceGroup, experience);
        makeRequired(cityGroup, city);
        makeRequired(stateGroup, state);
        makeRequired(passwordGroup, password);
        makeRequired(aadharNumberGroup, aadharNumber);
        makeRequired(aadharFileGroup, aadharFile);
    }
}
 
function makeOptional(fieldGroup, fieldElement) {
    fieldGroup.classList.add('optional-field');
    fieldElement.removeAttribute('required');
    // Clear any existing validation messages
    fieldElement.setCustomValidity('');
}
 
function makeRequired(fieldGroup, fieldElement) {
    fieldGroup.classList.remove('optional-field');
    fieldElement.setAttribute('required', 'required');
    // Clear any existing validation messages
    fieldElement.setCustomValidity('');
}
 
// Initialize fields on page load
window.addEventListener("DOMContentLoaded", () => {
    // Load dropdown data
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
        });
 
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
        });
 
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
        });
 
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
        });
 
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
        });
        
    // Initialize field states
    toggleFields();
});
 
// Enhanced form submission handler
document.getElementById("registerform").addEventListener("submit", async function (e) {
    const roleSelect = document.getElementById('role');
    const selectedRole = roleSelect.value;
    
	document.getElementById("loadingBox").style.display = "flex";

    // Basic validation for all roles
    const name = document.getElementById('name').value;
    const phone = document.getElementById('phone').value;
    const email = document.getElementById('email').value;
    const gender = document.getElementById('gender').value;
	const password = document.getElementById('password').value;
    
    if (!name || !phone || !email || !gender || !password) {
        alert("Please fill all basic required fields: Full Name, Mobile, Email,Password and Gender");
        e.preventDefault();
        return;
    }
    
    // Phone number validation
    if (!/^\d{10}$/.test(phone)) {
        alert("Please enter a valid 10-digit mobile number");
        e.preventDefault();
        return;
    }
    
    // Email validation
    if (!/^\S+@\S+\.\S+$/.test(email)) {
        alert("Please enter a valid email address");
        e.preventDefault();
        return;
    }
    
    // For non-Admin roles, validate all fields
    if (selectedRole !== 'Admin') {
        const course = document.getElementById('course').value;
        const specialization = document.getElementById('specialization').value;
        const passedout = document.getElementById('passedout').value;
        const collegeName = document.getElementById('collegeName').value;
        const experience = document.getElementById('experience').value;
        const city = document.getElementById('city').value;
        const state = document.getElementById('state').value;
        const password = document.getElementById('password').value;
        
        if (!name || !phone || !email || !gender || !course || !specialization || !passedout || !collegeName || !experience || !city || !state || !password) {
            alert("Please fill all required fields");
            e.preventDefault();
            return;
        }
        
        // Password pattern validation for non-Admin roles
        const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/;
        if (!passwordPattern.test(password)) {
            alert("Password must be at least 8 characters long and include uppercase and lowercase letters, a number, and a special character");
            e.preventDefault();
            return;
        }
    }e.preventDefault();

const aadharNumber = document.getElementById("aadharNumber").value.trim();
const aadharFile = document.getElementById("aadharFile").files[0];

if (!aadharNumber.match(/^\d{12}$/)) {
    alert("Please enter a valid 12-digit Aadhaar number");
    return;
}

if (!aadharFile) {
    alert("Please upload Aadhaar file");
    return;
}

const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];

if (!allowedTypes.includes(aadharFile.type)) {
    alert("Please upload only JPG or PNG image");
    return;
}

const maxSize = 10 * 1024 * 1024;

if (aadharFile.size > maxSize) {
    alert("File size should be less than 10MB");
    return;
}

try {
	// Show loading animation
document.getElementById("loadingBox").style.display = "flex";
document.getElementById("loadingText").innerText = "Verifying Aadhaar...";

    const formData = new FormData();

    formData.append("aadharFile", aadharFile);
    formData.append("aadharNumber", aadharNumber);

    const response = await fetch(
        "<%=request.getContextPath()%>/student/verifyAadhar",
        {
            method: "POST",
            body: formData
        }
    );

    const result = await response.json();

    if (!result.success) {
		document.getElementById("loadingBox").style.display = "none";
        alert("❌ Aadhaar verification failed");
        return;
    }

    document.getElementById("aadhaarVerified").value = "true";

} catch(error) {
    document.getElementById("loadingBox").style.display = "none";
    alert("Verification failed. Please try again.");
    return;
}
    const confirmation = confirm(`Do you want to register`);
    if (confirmation) {
	document.getElementById("loadingText").innerText = "Registering..."; 
    this.submit();
    }else {

    document.getElementById("loadingBox").style.display = "none";
}
});
 
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
 
<script src="internet-check.js">
	window.addEventListener('load', () => {
	  function showPopup(message, color) {
	    let popup = document.getElementById('internet-popup');
	    if (!popup) {
	      popup = document.createElement('div');
	      popup.id = 'internet-popup';
	      popup.style.position = 'fixed';
	      popup.style.top = '20px';
	      popup.style.right = '20px';
	      popup.style.padding = '15px 20px';
	      popup.style.backgroundColor = color;
	      popup.style.color = 'white';
	      popup.style.borderRadius = '10px';
	      popup.style.boxShadow = '0 0 10px rgba(0,0,0,0.3)';
	      popup.style.fontWeight = 'bold';
	      popup.style.zIndex = '9999';
	      document.body.appendChild(popup);
	    }
	    popup.textContent = message;
	    popup.style.display = 'block';
	  }
 
	  function hidePopup() {
	    const popup = document.getElementById('internet-popup');
	    if (popup) popup.style.display = 'none';
	  }
 
	  window.addEventListener('offline', () => {
	    showPopup('⚠️ No Internet Connection! Please check your network.', '#ff4444');
	  });
 
	  window.addEventListener('online', () => {
	    showPopup('✅ Internet reconnected!', '#4CAF50');
	    setTimeout(hidePopup, 3000);
	  });
	});
	
</script>
        <div id="loadingBox" class="loader">
    <div class="spinner"></div>
    <div id="loadingText">Verifying Aadhaar...</div>
</div>
</body>
</html>