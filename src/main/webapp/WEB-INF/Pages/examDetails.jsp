<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Exam Details</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f5f5f5;
}
.div-img{
    display: flex;
    justify-content: flex-start;
    padding: 10px 20px;
}
.div1{
    width: 70%;
    margin: auto;
    background: white;
    padding-left: 30px;
	padding-right: 30px;
	padding-top: 10px;
	padding-bottom: 15px;
	margin-bottom: 15px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
.div2{
    width: 80%;
    display: flex;
    justify-content: space-between;
    padding-left: 5px;
    padding-right: 5px;
    margin-bottom: 30px;
}
.div2_1 {
    text-align: left;
}
.div2_1 h3 {
    margin: 0 0 10px 0;
    color: #333;
    font-size: 16px;
}
.div2_1 p {
    margin: 0;
    color: #666;
}
.div3{
    width: 97%;
    margin-bottom: 30px;
}
.div3 h4 {
    color: #333;
    margin-bottom: 15px;
    font-size: 18px;
}
.div3_1{
    width: 99%;
}
.div3_11 {
    padding-left: 20px;
    color: #555;
    line-height: 1.6;
}
.div3_11 li {
  line-height: 1.5;
}
.div4{
    width: 97%;
    margin-bottom: 10px;
}
.div4_1{
    display: flex;
    gap: 2px;
    align-items: center;
}
.div4_11{
    color: #2178BD;
}
.div5{
    width: fit;
    padding-left: 19px;
    padding-right: 19px;
    padding-top: 7px;
    color: white;
    background: green;
    border: none;
    border-radius: 5px;
    padding-bottom: 7px;
    font-size: 16px;
    cursor: pointer;
    margin-right: 10px;
}
button{
    cursor: pointer;
}
.select{
    padding-top: 5px;
    padding-bottom: 5px;
    outline: none;
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 8px 12px;
    min-width: 180px;
}
h2 {
    color: #333;
    margin-bottom: 30px;
    font-size: 24px;
}
</style>
</head>
<body class="body">

<div class="div-img">
  <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70">
</div>

<div class="div1">
<h2>Exam Details</h2>

<form action="${pageContext.request.contextPath}/student/examScreen" method="get" id="examForm">

<div class="div2">
  <div class="div2_1">
    <h3>Exam Title</h3>
    <select id="languageName" name="languageName" required class="select">
      <option value="" disabled selected>Select Coding Language</option>
    </select>
  </div>
  <div class="div2_1">
    <h3>Exam Duration</h3>
    <p>30 Mins</p>
  </div>
  <div class="div2_1">
    <h3>MCQ's</h3>
    <p>20</p>
  </div>
  <div class="div2_1">
    <h3>Coding Questions</h3>
    <p>3</p>
  </div>
</div>

<div class="div3">
  <h4>Exam Instructions</h4>
  <div class="div3_1">
    <ol class="div3_11">
      <li>Language: The exam must be completed in English.</li>
      <li>Device Usage: Mobile phones, tablets, or any other electronic devices are strictly prohibited during the exam.</li>
      <li>Tab Switching: Do not switch between tabs or open any other applications. Switching tabs will be monitored and may result in disqualification.</li>
      <li>Timer: The timer will run continuously from the start of the exam. Ensure you manage your time accordingly.</li>
      <li>Coding Questions: For coding questions, write your code in the provided editor. Any unauthorized code-sharing or copying is not permitted.</li>
      <li>Multiple-Choice Questions (MCQs): Answer the MCQs based on your knowledge. Once you submit, you cannot go back to change your answers.</li>
      <li>Submission: Ensure that you click "Submit" once you have completed the exam. No changes will be allowed after submission.</li>
      <li>Technical Issues: In case of technical issues, contact support immediately through the designated channels.</li>
    </ol>
  </div>
</div>

<div class="div4">
  <div class="div4_1">
    <input type="checkbox" id="terms" required>
    <p>I accept and agree to the <span class="div4_11">Terms of Use</span></p>
  </div>
</div>

<div>
  <button type="submit" class="div5" id="startExamBtn">Start Exam</button>
</div>

</form>

</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    setupSecurityMeasures();
});

function setupSecurityMeasures() {
    // Prevent context menu
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        return false;
    });

    // Prevent dev tools
    document.addEventListener('keydown', function(e) {
        if (e.key === 'F12' || 
            (e.ctrlKey && e.shiftKey && e.key === 'I') ||
            (e.ctrlKey && e.shiftKey && e.key === 'J') ||
            (e.ctrlKey && e.key === 'u')) {
            e.preventDefault();
            return false;
        }
    });

    // Detect tab switching
    document.addEventListener('visibilitychange', function() {
        if (document.hidden) {
            console.log('Tab switching detected - violation logged');
            // You can add your violation handling here
        }
    });
}

// Form submission
document.getElementById('examForm').addEventListener('submit', function(e) {
    const termsChecked = document.getElementById('terms').checked;
    const languageSelected = document.getElementById('languageName').value;
    
    if (!termsChecked) {
        e.preventDefault();
        alert('Please accept the Terms of Use to continue.');
        return;
    }
    
    if (!languageSelected) {
        e.preventDefault();
        alert('Please select a coding language.');
        return;
    }
});

// Fetch Language Name
fetch("<%=request.getContextPath()%>/student/getLanguage")
    .then(res => res.json())
    .then(data => {
        const languageSelect = document.getElementById("languageName");
        data.forEach(item => {
            const opt = document.createElement("option");
            opt.value = item.languageName;
            opt.textContent = item.languageName;
            languageSelect.appendChild(opt);
        });
    })
    .catch(err => {
        console.error("Error fetching languages:", err);
        const fallbackLanguages = ['Java', 'Python', 'JavaScript', 'C++', 'C#'];
        const languageSelect = document.getElementById("languageName");
        fallbackLanguages.forEach(lang => {
            const opt = document.createElement("option");
            opt.value = lang;
            opt.textContent = lang;
            languageSelect.appendChild(opt);
        });
    });
</script>
</body>
</html>