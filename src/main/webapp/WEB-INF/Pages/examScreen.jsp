<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${languageName} Online Exam</title>
<style>
.coding { padding: 9px 30px; color: white; border: none; background-color: #90E9BB; border-radius: 5px; font-size: 15px; cursor: pointer; }
.div1 { border: none; border-radius: 5px; cursor: pointer; }
.question-id { margin: 5px; display:inline-block; width:30px; height:30px; border:1px solid black; text-align:center; line-height:30px; cursor:pointer; border-radius:100%; background-color:#D9D9D9; }
.question-id.answered { background-color: green; color:white; }
.question-id.viewed-not-answered { background-color: red; color:white; }
.question-id.not-viewed { background-color: gray; color:white; }
.mcq-question { margin-bottom:15px; padding-bottom:10px; display:none; padding:10px; }
ul { list-style:none; padding-left:0; }
.select { padding-top: 5px; padding-bottom: 5px; outline: none; }
.timer-display { display: flex; justify-content: end; padding-left: 10px; padding-right: 10px; width: 73%; margin: auto; align-items: center; }
.code-container { display: none; width: 55%; background-color: black; color: white; }
.question-content { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 10px; border-left: 4px solid #007bff; }
.sample-io { background: #e9ecef; padding: 10px; border-radius: 5px; margin: 5px 0; font-family: monospace; }
.io-label { font-weight: bold; color: #495057; margin-bottom: 5px; }
pre { white-space: pre-wrap; word-wrap: break-word; margin: 0; }
.test-passed { background-color: #1a472a !important; border-left: 4px solid #00ff00; }
.test-failed { background-color: #5c1e1e !important; border-left: 4px solid #ff0000; }
.test-warning { background-color: #5d5c1e !important; border-left: 4px solid #ffff00; }
.exam-section { display: none; }
.exam-section.active { display: block; }
.loading-indicator {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: rgba(0,0,0,0.8);
    color: white;
    padding: 20px;
    border-radius: 10px;
    z-index: 10002;
}
</style>
</head>
<body>

<!-- Loading Indicator -->
<div id="loadingIndicator" class="loading-indicator">
    <div style="text-align: center;">
        <div style="font-size: 20px; margin-bottom: 10px;">⏳</div>
        <div>Loading...</div>
    </div>
</div>

<!-- Header -->
<div style="">
  <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="65">
</div>
<h2 style="text-align: center; margin: 0px">${languageName} Online Exam</h2>

<!-- Shared Timer Display (Always Visible) -->
<div class="timer-display">
  <div style="display: flex; gap: 5px; width: fit-content;">
    <h3>Time : </h3>
    <p id="meetingTime" style="font-size:19px; color:blue;">Loading...</p>
  </div>
  <div style="margin-left: 30px;">
        <button type="button" onclick="submitAllExam()" style="padding:10px 20px; background:#FF6B35; color:white; border: none; border-radius: 10px">Submit Complete Exam</button>
  </div>
</div>

<!-- Hidden Inputs for Timer and User Data -->
<input type="hidden" id="languageName" value="${languageName}">
<input type="hidden" id="email" value="${sessionScope.userEmail}">

<!-- MCQ & Coding Buttons -->
<div style="width: 95%; display: flex; justify-content: space-between; margin: auto">
  <div style="display:flex; width:30%; justify-content:space-around; margin-left: 1%">
    <button type="button" onclick="loadMCQSection()" style="padding:10px 20px; background:#2FADE4; color:white; border-radius:5px; border: none; cursor: pointer">MCQ</button>
    <button type="button" onclick="loadCodingSection()" style="padding:10px 20px; background:#2FADE4; color:white; border-radius:5px; border: none; cursor: pointer">Coding</button>
  </div>
</div>

<!-- MCQ Section Container -->
<div id="mcq-section" class="exam-section active">
    <c:if test="${not empty mcq}">
    <div style="display:flex; width:90%; margin:auto; justify-content:space-between;">
        <div style="width:65%;">
            <h3>MCQ Questions</h3>
            <c:forEach var="q" items="${mcq}">
                <div class="mcq-question" id="question-${q.id}">
                    <p style="white-space: pre-wrap;"><strong>Q ${q.id}:</strong> ${q.question}</p>
                    <ul>
                        <c:forEach var="opt" items="${fn:split(q.optionText, ',')}">
                            <li>
                                <input type="radio" name="answer-${q.id}" value="${fn:substring(opt.trim(), 0, 1)}" onclick="markAnswered(${q.id})">
                                <!--<label>${opt.trim()}</label>-->
								<label><c:out value="${opt.trim()}" /></label>
                            </li>
                        </c:forEach>
                    </ul>
                    <div style="display:flex; justify-content:space-between; width:60%; margin-top:10px;">
                        <button class="div1" onclick="showPrevious(${q.id}); return false;" style="background:#1E6C8D; color:white; padding: 9px 23px"><img src="${pageContext.request.contextPath}/images/leftArrow.png" alt="Logo" width="10" height="10"> Previous</button>
                        <button class="div1" onclick="saveAndNext(${q.id}); return false;" style="background:#00BB19; color:white; padding: 9px 17px">Save & Next <img src="${pageContext.request.contextPath}/images/arrow.png" alt="Logo" width="10" height="10"></button>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div style="width:30%; text-align:center">
            <div style="width: 80%; margin: auto;">
                <div style="width: 80%; display: flex; flex-wrap: wrap; justify-content: space-between; margin: auto">
                    <div style="display: flex; gap: 4px; justify-content: center; align-items: center; width: 40%">
                        <p>Answered</p>
                        <div style="width: 9.5%; height: 15px; background-color: green"></div>
                    </div>
                    <div style="display: flex; gap: 4px; justify-content: center; align-items: center; width: 40%">
                        <p>Viewed</p>
                        <div style="width: 9.5%; height: 15px; background-color: red"></div>
                    </div>
                    <div style="display: flex; gap: 4px; justify-content: center; align-items: center; width: 40%">
                        <p>Not Viewed</p>
                        <div style="width: 9.5%; height: 15px; background-color: gray"></div>
                    </div>
                </div>
            </div>
            <c:forEach var="q" items="${mcq}">
                <div class="question-id not-viewed" id="qid-${q.id}" onclick="showMCQ(${q.id})">${q.id}</div>
            </c:forEach>
        </div>
    </div>
    </c:if>
</div>

<!-- Coding Section Container -->
<div id="coding-section" class="exam-section">
    <c:if test="${not empty questions}">
    <div style="width:40%; margin:auto; display:flex; justify-content:space-evenly">
        <button class="coding" onclick="showCoding('easy')">Easy</button>
        <button class="coding" onclick="showCoding('medium')">Medium</button>
        <button class="coding" onclick="showCoding('hard')">Hard</button>
    </div>
    <div style="width:98%; margin:auto; display: flex; justify-content: space-between">
        <ul style="width: 97%; display: flex; justify-content: space-between">
            <div style="width: 40%;" id="questionsList">
                <c:forEach var="q" items="${questions}" varStatus="loop">
                    <li class="easy-question" style="display:none; padding-top: 10px; padding-left: 10px"
                        data-requires-input="${not empty q.easyInput}" 
                        data-question-id="easy-${loop.index}"
                        data-expected-output="${q.easyExpectedOutput}">
                        <div class="question-content">
                            ${q.easyQuestion}
                            <c:if test="${not empty q.easyInputArray}">
                                <c:forEach var="inputItem" items="${q.easyInputArray}" varStatus="inputStatus">
                                    <div class="sample-io">
                                        <div class="io-label">Example ${inputStatus.index + 1}:</div>
                                        <div style="margin-bottom: 8px;">
                                            <strong>Input:</strong><br>
                                            <pre style="background: #343a40; color: white; padding: 8px; border-radius: 4px; margin: 5px 0;">${inputItem}</pre>
                                        </div>
                                        <c:if test="${not empty q.easyExpectedOutputArray[inputStatus.index]}">
                                            <div>
                                                <strong>Expected Output:</strong><br>
                                                <pre style="background: #343a40; color: white; padding: 8px; border-radius: 4px; margin: 5px 0;">${q.easyExpectedOutputArray[inputStatus.index]}</pre>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </li>
                    <li class="medium-question" style="display:none; padding-top: 10px; padding-left: 10px"
                        data-requires-input="${not empty q.mediumInput}" 
                        data-question-id="medium-${loop.index}"
                        data-expected-output="${q.mediumExpectedOutput}">
                        <div class="question-content">
                            ${q.mediumQuestion}
                            <c:if test="${not empty q.mediumInputArray}">
                                <c:forEach var="inputItem" items="${q.mediumInputArray}" varStatus="inputStatus">
                                    <div class="sample-io">
                                        <div class="io-label">Example ${inputStatus.index + 1}:</div>
                                        <div style="margin-bottom: 8px;">
                                            <strong>Input:</strong><br>
                                            <pre style="background: #343a40; color: white; padding: 8px; border-radius: 4px; margin: 5px 0;">${inputItem}</pre>
                                        </div>
                                        <c:if test="${not empty q.mediumExpectedOutputArray[inputStatus.index]}">
                                            <div>
                                                <strong>Expected Output:</strong><br>
                                                <pre style="background: #343a40; color: white; padding: 8px; border-radius: 4px; margin: 5px 0;">${q.mediumExpectedOutputArray[inputStatus.index]}</pre>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </li>
                    <li class="hard-question" style="display:none; padding-top: 10px; padding-left: 10px"
                        data-requires-input="${not empty q.hardInput}" 
                        data-question-id="hard-${loop.index}"
                        data-expected-output="${q.hardExpectedOutput}">
                        <div class="question-content">
                            ${q.hardQuestion}
                            <c:if test="${not empty q.hardInputArray}">
                                <c:forEach var="inputItem" items="${q.hardInputArray}" varStatus="inputStatus">
                                    <div class="sample-io">
                                        <div class="io-label">Example ${inputStatus.index + 1}:</div>
                                        <div style="margin-bottom: 8px;">
                                            <strong>Input:</strong><br>
                                            <pre style="background: #343a40; color: white; padding: 8px; border-radius: 4px; margin: 5px 0;">${inputItem}</pre>
                                        </div>
                                        <c:if test="${not empty q.hardExpectedOutputArray[inputStatus.index]}">
                                            <div>
                                                <strong>Expected Output:</strong><br>
                                                <pre style="background: #343a40; color: white; padding: 8px; border-radius: 4px; margin: 5px 0;">${q.hardExpectedOutputArray[inputStatus.index]}</pre>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </li>
                </c:forEach>
            </div>
            <div style="width: 55%;">
                <c:forEach var="q" items="${questions}" varStatus="loop">
                    <div id="codeContainer-easy-${loop.index}" class="code-container" style="width: 100%"
                         data-question-id="easy-${loop.index}">
                        <div style="display: flex; justify-content: flex-end; padding-right: 3%; padding-top: 5px">
                            <select id="languageNameSelect-easy-${loop.index}" name="languageName" required class="select" style="margin-bottom: 10px;">
                                <option value="" disabled selected>Select Coding Language</option>
								<option value="Java">Java</option>
								<option value="Python">Python</option>
                            </select>
                        </div>
                        <div style="width: 97%; display: flex; justify-content: space-evenly; margin: auto">
                            <textarea id="codeArea-easy-${loop.index}" rows="15" cols="80"
                                      placeholder="Write your code here..."
                                      style="width: 99%; font-family: monospace; font-size: 14px; color: white; background-color: black; outline: none; padding: 10px"></textarea>
                        </div>
                        <div id="inputContainer-easy-${loop.index}" style="width:97%; margin:auto; margin-bottom:10px; background-color: black; display: ${not empty q.easyInput ? 'block' : 'none'};">
                            <label style="color:white;">Custom Input (Optional):</label>
                            <textarea id="inputArea-easy-${loop.index}" rows="2" cols="80" style="width:99%; font-family:monospace; color: white; background-color: black;" placeholder="Enter custom input here if you want to test with different inputs"></textarea>
                        </div>
                        <div style="margin-top:10px; width: 97%; display: flex; justify-content: flex-end">
                            <button onclick="runCode('easy-${loop.index}')" style="padding: 10px 20px; background-color: #4CAF50; color: white; margin-right:10px;">Run Code</button>
                            <button onclick="submitCoding()" style="padding: 10px 20px; background:#FC0A0A; color: white;">Submit Coding</button>
                        </div>
                        <h4 style="padding-left: 5px">Output:</h4>
                        <pre id="outputBox-easy-${loop.index}" style="background-color: black; color: white; padding:10px; height:90px; overflow:auto"></pre>
                        <div id="testResult-easy-${loop.index}" style="display:none; margin-top:10px; padding:15px; border-radius:5px; background-color: #2d3748;">
                            <h4 style="padding-left: 5px; color: white; margin-bottom: 10px;">Test Result:</h4>
                            <pre id="testOutput-easy-${loop.index}" style="background-color: rgba(0,0,0,0.3); color: white; padding:10px; border-radius: 3px; height:60px; overflow:auto; white-space: pre-wrap;"></pre>
                        </div>
                    </div>
                    <div id="codeContainer-medium-${loop.index}" class="code-container" style="width: 100%"
                         data-question-id="medium-${loop.index}">
                        <div style="display: flex; justify-content: flex-end; padding-right: 3%; padding-top: 5px">
                            <select id="languageNameSelect-medium-${loop.index}" name="languageName" required class="select" style="margin-bottom: 10px;">
                                <option value="" disabled selected>Select Coding Language</option>
								<option value="Java">Java</option>
								<option value="Python">Python</option>
                            </select>
                        </div>
                        <div style="width: 97%; display: flex; justify-content: space-evenly; margin: auto">
                            <textarea id="codeArea-medium-${loop.index}" rows="15" cols="80"
                                      placeholder="Write your code here..."
                                      style="width: 99%; font-family: monospace; font-size: 14px; color: white; background-color: black; outline: none; padding: 10px"></textarea>
                        </div>
                        <div id="inputContainer-medium-${loop.index}" style="width:97%; margin:auto; margin-bottom:10px; background-color: black; display: ${not empty q.mediumInput ? 'block' : 'none'};">
                            <label style="color:white;">Custom Input (Optional):</label>
                            <textarea id="inputArea-medium-${loop.index}" rows="2" cols="80" style="width:99%; font-family:monospace; color: white; background-color: black;" placeholder="Enter custom input here if you want to test with different inputs"></textarea>
                        </div>
                        <div style="margin-top:10px; width: 97%; display: flex; justify-content: flex-end">
                            <button onclick="runCode('medium-${loop.index}')" style="padding: 10px 20px; background-color: #4CAF50; color: white; margin-right:10px;">Run Code</button>
                            <button onclick="submitCoding()" style="padding: 10px 20px; background:#FC0A0A; color: white;">Submit Coding</button>
                        </div>
                        <h4 style="padding-left: 5px">Output:</h4>
                        <pre id="outputBox-medium-${loop.index}" style="background-color: black; color: white; padding:10px; height:90px; overflow:auto"></pre>
                        <div id="testResult-medium-${loop.index}" style="display:none; margin-top:10px; padding:15px; border-radius:5px; background-color: #2d3748;">
                            <h4 style="padding-left: 5px; color: white; margin-bottom: 10px;">Test Result:</h4>
                            <pre id="testOutput-medium-${loop.index}" style="background-color: rgba(0,0,0,0.3); color: white; padding:10px; border-radius: 3px; height:60px; overflow:auto; white-space: pre-wrap;"></pre>
                        </div>
                    </div>
                    <div id="codeContainer-hard-${loop.index}" class="code-container" style="width: 100%"
                         data-question-id="hard-${loop.index}">
                        <div style="display: flex; justify-content: flex-end; padding-right: 3%; padding-top: 5px">
                            <select id="languageNameSelect-hard-${loop.index}" name="languageName" required class="select" style="margin-bottom: 10px;">
                                <option value="" disabled selected>Select Coding Language</option>
								<option value="Java">Java</option>
								<option value="Python">Python</option>
                            </select>
                        </div>
                        <div style="width: 97%; display: flex; justify-content: space-evenly; margin: auto">
                            <textarea id="codeArea-hard-${loop.index}" rows="15" cols="80"
                                      placeholder="Write your code here..."
                                      style="width: 99%; font-family: monospace; font-size: 14px; color: white; background-color: black; outline: none; padding: 10px"></textarea>
                        </div>
                        <div id="inputContainer-hard-${loop.index}" style="width:97%; margin:auto; margin-bottom:10px; background-color: black; display: ${not empty q.hardInput ? 'block' : 'none'};">
                            <label style="color:white;">Custom Input (Optional):</label>
                            <textarea id="inputArea-hard-${loop.index}" rows="2" cols="80" style="width:99%; font-family:monospace; color: white; background-color: black;" placeholder="Enter custom input here if you want to test with different inputs"></textarea>
                        </div>
                        <div style="margin-top:10px; width: 97%; display: flex; justify-content: flex-end">
                            <button onclick="runCode('hard-${loop.index}')" style="padding: 10px 20px; background-color: #4CAF50; color: white; margin-right:10px;">Run Code</button>
                            <button onclick="submitCoding()" style="padding: 10px 20px; background:#FC0A0A; color: white;">Submit Coding</button>
                        </div>
                        <h4 style="padding-left: 5px">Output:</h4>
                        <pre id="outputBox-hard-${loop.index}" style="background-color: black; color: white; padding:10px; height:90px; overflow:auto"></pre>
                        <div id="testResult-hard-${loop.index}" style="display:none; margin-top:10px; padding:15px; border-radius:5px; background-color: #2d3748;">
                            <h4 style="padding-left: 5px; color: white; margin-bottom: 10px;">Test Result:</h4>
                            <pre id="testOutput-hard-${loop.index}" style="background-color: rgba(0,0,0,0.3); color: white; padding:10px; border-radius: 3px; height:60px; overflow:auto; white-space: pre-wrap;"></pre>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </ul>
    </div>
    </c:if>
</div>

<!-- Time Up Modal -->
<div id="timeUpModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background-color: rgba(0,0,0,0.5); justify-content:center; align-items:center; z-index:1000;">
    <div style="background:white; padding:30px; border-radius:10px; text-align:center; width:300px;">
        <h3>⏰ Exam Time Completed!</h3>
        <p>Your exam time has finished. Please submit your answers.</p>
        <br>
        <button onclick="submitAllExam()" style="padding:10px 20px; background:#FC0A0A; color:white; border:none; border-radius:5px; cursor:pointer; margin-right:10px;">
            Submit Exam
        </button>
    </div>
</div>

<script>
let isFullscreen = false;
let fullscreenAttempted = false;
let fullscreenInitialized = false;
let currentSection = 'mcq';

document.addEventListener('DOMContentLoaded', function() {
    if (!fullscreenInitialized) {
        initializeFullscreen();
        setupSecurityMeasures();
        fullscreenInitialized = true;
    }
    initializeSharedTimer();
    initializeMCQSection();
    initializeCodingSection();
});

// ===== SECTION LOADING FUNCTIONS =====
function showLoading() {
    document.getElementById('loadingIndicator').style.display = 'block';
}

function hideLoading() {
    document.getElementById('loadingIndicator').style.display = 'none';
}

function loadMCQSection() {
    console.log("Loading MCQ section...");
    //const newUrl = `http://localhost:4049/student/examScreen/mcq?languageName=${languageName}`;
	const newUrl = `<%=request.getContextPath()%>/student/examScreen/mcq?languageName=${languageName}`;
    window.history.pushState({}, '', newUrl);
    
    showLoading();
    currentSection = 'mcq';
    
    fetch(newUrl, {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
		console.log("final response is........", response);
        return response.text();
    })
    .then(html => {
		console.log("📄 Response HTML content:\n", html);
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = html;
        
        const mcqContent = tempDiv.querySelector('#mcq-section');
        
        if (mcqContent) {
            document.getElementById('mcq-section').innerHTML = mcqContent.innerHTML;
        } else {
            const questionsContent = extractMCQContent(html);
            if (questionsContent) {
                document.getElementById('mcq-section').innerHTML = questionsContent;
            } else {
                const cleanedHtml = removeDuplicateHeaders(html);
                document.getElementById('mcq-section').innerHTML = cleanedHtml;
            }
        }
        
        showSection('mcq');
        initializeMCQSection();
        hideLoading();
    })
    .catch(error => {
        console.error('Error loading MCQ section:', error);
        hideLoading();
        alert('Error loading MCQ section. Please try again.');
    });
}

function loadCodingSection() {
    if (currentSection === 'coding') return;
    
    if (!areAllMCQsAnswered()) {
        alert("Please select options for all MCQ questions before accessing the coding section.");
        return;
    }
    
    showLoading();
    currentSection = 'coding';
    
    //fetch('http://localhost:4049/student/examScreen/coding?languageName=${languageName}', {
		fetch('<%=request.getContextPath()%>/student/examScreen/coding?languageName=${languageName}', {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.text();
    })
    .then(html => {
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = html;
        const codingContent = tempDiv.querySelector('#coding-section');
        
        if (codingContent) {
            document.getElementById('coding-section').innerHTML = codingContent.innerHTML;
        } else {
            const questionsContent = extractCodingContent(html);
            if (questionsContent) {
                document.getElementById('coding-section').innerHTML = questionsContent;
            } else {
                const cleanedHtml = removeDuplicateHeaders(html);
                document.getElementById('coding-section').innerHTML = cleanedHtml;
            }
        }
        
        showSection('coding');
        initializeCodingSection();
        hideLoading();
    })
    .catch(error => {
        console.error('Error loading Coding section:', error);
        hideLoading();
        alert('Error loading Coding section. Please try again.');
    });
}

function extractMCQContent(html) {
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = html;
    
    const mcqContainer = tempDiv.querySelector('.mcq-question');
    if (mcqContainer) {
        return tempDiv.querySelector('#mcq-section').innerHTML;
    }
    
    return null;
}

function extractCodingContent(html) {
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = html;
    
    const codingContainer = tempDiv.querySelector('.code-container');
    if (codingContainer) {
        return tempDiv.querySelector('#coding-section').innerHTML;
    }
    
    return null;
}

function removeDuplicateHeaders(html) {
    return html.replace(/<div style="">\s*<img[^>]*>\s*<\/div>\s*<h2[^>]*>.*?<\/h2>/gi, '')
               .replace(/<div class="timer-display"[^>]*>.*?<\/div>/gi, '')
               .replace(/<input type="hidden" id="languageName"[^>]*>/gi, '')
               .replace(/<input type="hidden" id="email"[^>]*>/gi, '')
               .replace(/<div[^>]*id="mcq-section"[^>]*>/gi, '<div id="mcq-section">')
               .replace(/<div[^>]*id="coding-section"[^>]*>/gi, '<div id="coding-section">');
}

function showSection(section) {
    document.querySelectorAll('.exam-section').forEach(sec => {
        sec.classList.remove('active');
        sec.style.display = 'none';
    });
    
    const targetSection = document.getElementById(section + '-section');
    if (targetSection) {
        targetSection.classList.add('active');
        targetSection.style.display = 'block';
    }
}

// ===== FULLSCREEN FUNCTIONS =====
function initializeFullscreen() {
    checkFullscreenStatus();
    
    const forceFullscreen = sessionStorage.getItem('forceFullscreen') === 'true';
    
    if (forceFullscreen && !isFullscreen && !fullscreenAttempted) {
        createFullscreenTrigger();
    } else if (isFullscreen) {
        const triggerDiv = document.getElementById('fullscreenTrigger');
        if (triggerDiv) {
            triggerDiv.remove();
        }
    }
}

function createFullscreenTrigger() {
    const triggerDiv = document.createElement('div');
    triggerDiv.id = 'fullscreenTrigger';
    triggerDiv.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.01);
        z-index: 9998;
        cursor: pointer;
    `;
    triggerDiv.innerHTML = `
        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); 
                    background: white; padding: 20px; border-radius: 10px; text-align: center;
                    box-shadow: 0 4px 20px rgba(0,0,0,0.3); max-width: 400px; width: 90%;">
            <h3 style="color: #2178BD; margin-bottom: 15px;">🎯 Starting Exam</h3>
            <p style="margin-bottom: 20px; line-height: 1.5;">
                Your exam is ready. Click anywhere to enter fullscreen mode and begin your exam.
            </p>
            <button onclick="triggerFullscreen()" style="padding: 12px 30px; background: #2178BD; 
                    color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px;
                    font-weight: bold;">
                Start Exam in Fullscreen
            </button>
        </div>
    `;
    document.body.appendChild(triggerDiv);
}

function triggerFullscreen() {
    const triggerDiv = document.getElementById('fullscreenTrigger');
    if (triggerDiv) {
        triggerDiv.remove();
    }
    enterFullscreen();
}

function enterFullscreen() {
    if (fullscreenAttempted && isFullscreen) {
        return;
    }
    
    fullscreenAttempted = true;
    const elem = document.documentElement;
    
    hideFullscreenWarning();
    
    const fullscreenPromise = elem.requestFullscreen ? elem.requestFullscreen() :
                             elem.webkitRequestFullscreen ? elem.webkitRequestFullscreen() :
                             elem.mozRequestFullScreen ? elem.mozRequestFullScreen() :
                             elem.msRequestFullscreen ? elem.msRequestFullscreen() : 
                             Promise.reject(new Error('Fullscreen not supported'));

    fullscreenPromise.then(() => {
        isFullscreen = true;
        hideFullscreenWarning();
        sessionStorage.setItem('forceFullscreen', 'true');
        
        const triggerDiv = document.getElementById('fullscreenTrigger');
        if (triggerDiv) {
            triggerDiv.remove();
        }
        
        const modal = document.getElementById('fullscreenWarningModal');
        if (modal) {
            modal.style.display = 'none';
        }
    }).catch(err => {
        console.error('Fullscreen error:', err);
        fullscreenAttempted = false;
        
        if (err.name === 'NotAllowedError') {
            showFullscreenWarning('Fullscreen request was denied. Please allow fullscreen permission for this site and click the button below.');
        } else {
            showFullscreenWarning('Failed to enter fullscreen mode. Please use the button below to enable fullscreen.');
        }
    });
}

function checkFullscreenStatus() {
    const fullscreenElement = document.fullscreenElement || 
                             document.webkitFullscreenElement || 
                             document.mozFullScreenElement ||
                             document.msFullscreenElement;
    
    isFullscreen = !!fullscreenElement;
    
    if (isFullscreen) {
        hideFullscreenWarning();
        sessionStorage.setItem('forceFullscreen', 'true');
        
        const triggerDiv = document.getElementById('fullscreenTrigger');
        if (triggerDiv) {
            triggerDiv.remove();
        }
    } else {
        const forceFullscreen = sessionStorage.getItem('forceFullscreen') === 'true';
        if (forceFullscreen && !fullscreenAttempted) {
            showFullscreenWarning();
        }
    }
}

function setupFullscreenListeners() {
    document.removeEventListener('fullscreenchange', handleFullscreenChange);
    document.removeEventListener('webkitfullscreenchange', handleFullscreenChange);
    document.removeEventListener('mozfullscreenchange', handleFullscreenChange);
    document.removeEventListener('MSFullscreenChange', handleFullscreenChange);
    
    document.addEventListener('fullscreenchange', handleFullscreenChange);
    document.addEventListener('webkitfullscreenchange', handleFullscreenChange);
    document.addEventListener('mozfullscreenchange', handleFullscreenChange);
    document.addEventListener('MSFullscreenChange', handleFullscreenChange);
}

function handleFullscreenChange() {
    const wasFullscreen = isFullscreen;
    checkFullscreenStatus();
    
    if (wasFullscreen && !isFullscreen) {
        if (!document.getElementById('fullscreenWarningModal')) {
            createFullscreenWarningModal();
        }
        document.getElementById('fullscreenWarningModal').style.display = 'flex';
        
        setTimeout(() => {
            if (!isFullscreen && sessionStorage.getItem('forceFullscreen') === 'true') {
                enterFullscreen();
            }
        }, 3000);
    } else if (!wasFullscreen && isFullscreen) {
        hideFullscreenWarning();
        sessionStorage.setItem('forceFullscreen', 'true');
    }
}

function showFullscreenWarning(message = 'Please enter fullscreen mode for your exam.') {
    if (!document.getElementById('fullscreenWarning')) {
        createFullscreenWarning();
    }
    
    const warning = document.getElementById('fullscreenWarning');
    if (message) {
        warning.querySelector('span').textContent = message;
    }
    warning.style.display = 'block';
}

function hideFullscreenWarning() {
    const warning = document.getElementById('fullscreenWarning');
    if (warning) {
        warning.style.display = 'none';
    }
    const modal = document.getElementById('fullscreenWarningModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

function createFullscreenWarning() {
    const warningDiv = document.createElement('div');
    warningDiv.id = 'fullscreenWarning';
    warningDiv.style.cssText = `
        position: fixed;
        top: 10px;
        left: 50%;
        transform: translateX(-50%);
        background: #fff3cd;
        border: 1px solid #ffeaa7;
        border-radius: 5px;
        padding: 10px 20px;
        color: #856404;
        z-index: 10000;
        display: none;
    `;
    warningDiv.innerHTML = `
        <strong>⚠ Fullscreen Required</strong>
        <span style="margin-left: 10px;">Please enter fullscreen mode for your exam.</span>
        <button onclick="enterFullscreen()" style="margin-left: 10px; padding: 5px 10px; background: #2178BD; color: white; border: none; border-radius: 3px; cursor: pointer;">
            Enter Fullscreen
        </button>
    `;
    document.body.appendChild(warningDiv);
}

function createFullscreenWarningModal() {
    const modalDiv = document.createElement('div');
    modalDiv.id = 'fullscreenWarningModal';
    modalDiv.style.cssText = `
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.7);
        justify-content: center;
        align-items: center;
        z-index: 10001;
    `;
    modalDiv.innerHTML = `
        <div style="background: white; padding: 30px; border-radius: 10px; text-align: center; width: 400px; max-width: 90%;">
            <h3 style="color: #dc3545; margin-bottom: 15px;">⚠ Fullscreen Required</h3>
            <p style="margin-bottom: 20px; line-height: 1.5;">
                You have exited fullscreen mode. This is a violation of exam rules.<br>
                Please return to fullscreen mode immediately to continue your exam.
            </p>
            <button onclick="enterFullscreen()" style="padding: 10px 20px; background: #2178BD; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px;">
                Return to Fullscreen
            </button>
        </div>
    `;
    document.body.appendChild(modalDiv);
}

// ===== SECURITY MEASURES =====
function setupSecurityMeasures() {
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        return false;
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'F12' || 
            (e.ctrlKey && e.shiftKey && e.key === 'I') ||
			//(e.ctrlKey && e.shiftKey && e.key === 'J') ||
            (e.key === 'Escape') ||
            (e.key === 'Esc') ||
			(e.key === 'ESC') ||
            (e.ctrlKey && e.key === 'u')) {
            e.preventDefault();
            alert('Developer tools are disabled during the exam.');
            return false;
        }
        
        if (e.key === 'F11') {
            e.preventDefault();
            alert('Please use the provided fullscreen button.');
            return false;
        }
    });

    document.addEventListener('visibilitychange', function() {
        if (document.hidden && isFullscreen) {
            logViolation('TAB_SWITCH');
        }
    });
    
    window.addEventListener('blur', function() {
        if (isFullscreen) {
            logViolation('WINDOW_BLUR');
        }
    });
    
    setupFullscreenListeners();
}

function logViolation(type) {
    console.warn('Exam violation detected:', type);
    
    fetch('http://localhost:4049/student/logViolation', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            type: type,
            email: email,
            languageName: lang,
            timestamp: new Date().toISOString()
        })
    }).catch(err => console.error('Error logging violation:', err));
}

createFullscreenWarningModal();
createFullscreenWarning();

// ===== SHARED TIMER FOR MCQ + CODING =====
let totalSeconds = 0;
let timerInterval = null;
const meetingTimeElem = document.getElementById("meetingTime");
const lang = document.getElementById("languageName").value;
const email = document.getElementById("email").value;

function initializeSharedTimer() {
    const savedTimer = sessionStorage.getItem('examTimer_' + lang + '_' + email);
    if (savedTimer && parseInt(savedTimer) > 0) {
        totalSeconds = parseInt(savedTimer);
        startSharedTimer();
        meetingTimeElem.textContent = formatTime(totalSeconds);
    } else {
        const url = 'http://localhost:4049/student/manageExams/byLanguage/' + lang;
        fetch(url)
        .then(res => {
            if (!res.ok) throw new Error("HTTP error! Status: " + res.status);
            return res.json();
        })
        .then(data => {
            if (data && data.length > 0) {
                let meetingTime = data[0].meetingTime;
                let parts = meetingTime.split(":");
                totalSeconds = parseInt(parts[0]) * 3600 + parseInt(parts[1]) * 60;
                startSharedTimer();
            } else {
                meetingTimeElem.textContent = "Not Available";
            }
        })
        .catch(err => {
            console.error("Error fetching meeting time:", err);
            meetingTimeElem.textContent = "Error fetching time";
        });
    }
}

function startSharedTimer() {
    if (timerInterval) clearInterval(timerInterval);

    timerInterval = setInterval(() => {
        if (totalSeconds <= 0) {
            clearInterval(timerInterval);
            showTimeUpModal();
            sessionStorage.removeItem('examTimer_' + lang + '_' + email);
            return;
        }

        totalSeconds--;
        sessionStorage.setItem('examTimer_' + lang + '_' + email, totalSeconds);
        meetingTimeElem.textContent = formatTime(totalSeconds);

        if (totalSeconds === 300) {
            alert("⚠️ Only 5 minutes remaining! Please finish your exam soon.");
        }
    }, 1000);
}

function formatTime(seconds) {
    let hours = Math.floor(seconds / 3600);
    let minutes = Math.floor((seconds % 3600) / 60);
    let secs = seconds % 60;
    return hours.toString().padStart(2,'0') + ":" +
           minutes.toString().padStart(2,'0') + ":" +
           secs.toString().padStart(2,'0');
}

function showTimeUpModal() {
    document.getElementById("timeUpModal").style.display = "flex";
    meetingTimeElem.textContent = "00:00:00";
}

// ===== MCQ FUNCTIONS =====
let mcqQuestions = [];
let currentIndex = 0;

function initializeMCQSection() {
    mcqQuestions = Array.from(document.querySelectorAll('.mcq-question'));
    if(mcqQuestions.length > 0) {
        showMCQ(mcqQuestions[0].id.split('-')[1]);
    }

    mcqQuestions.forEach(q => {
        let qid = q.id.split('-')[1];
        let savedAnswer = sessionStorage.getItem('mcq-' + qid + '_' + lang + '_' + email);
        let viewed = sessionStorage.getItem('viewed-' + qid + '_' + lang + '_' + email);
        let qidElement = document.getElementById('qid-' + qid);

        if (savedAnswer) {
            let radios = document.querySelectorAll('#question-' + qid + ' input[type=radio]');
            radios.forEach(r => { if(r.value === savedAnswer) r.checked = true; });
            qidElement.classList.remove('not-viewed', 'viewed-not-answered');
            qidElement.classList.add('answered');
        } else if (viewed) {
            qidElement.classList.remove('not-viewed', 'answered');
            qidElement.classList.add('viewed-not-answered');
        } else {
            qidElement.classList.remove('viewed-not-answered', 'answered');
            qidElement.classList.add('not-viewed');
        }
    });
}

function showMCQ(id) {
    mcqQuestions.forEach(q => q.style.display='none');
    document.getElementById('question-'+id).style.display='block';
    currentIndex = mcqQuestions.findIndex(q => q.id === 'question-'+id);
    sessionStorage.setItem('viewed-' + id + '_' + lang + '_' + email, 'true');
    updateQuestionStatus(id);
}

function saveAndNext(id){
    markAnswered(id);
    if(currentIndex < mcqQuestions.length-1){
        mcqQuestions[currentIndex].style.display='none';
        currentIndex++;
        showMCQ(mcqQuestions[currentIndex].id.split('-')[1]);
    }
}

function showPrevious(id){
    if(currentIndex > 0){
        mcqQuestions[currentIndex].style.display='none';
        currentIndex--;
        showMCQ(mcqQuestions[currentIndex].id.split('-')[1]);
    }
}

function markAnswered(id){
    let radios = document.querySelectorAll('#question-'+id+' input[type=radio]');
    let answered = Array.from(radios).some(r => r.checked);
    radios.forEach(r => {
        if(r.checked) sessionStorage.setItem('mcq-'+id + '_' + lang + '_' + email, r.value);
    });
    updateQuestionStatus(id);
}

function updateQuestionStatus(id) {
    let qidElement = document.getElementById('qid-' + id);
    let radios = document.querySelectorAll('#question-' + id + ' input[type=radio]');
    let answered = Array.from(radios).some(r => r.checked);
    let viewed = sessionStorage.getItem('viewed-' + id + '_' + lang + '_' + email);

    qidElement.classList.remove('not-viewed', 'viewed-not-answered', 'answered');
    if (answered) {
        qidElement.classList.add('answered');
    } else if (viewed) {
        qidElement.classList.add('viewed-not-answered');
    } else {
        qidElement.classList.add('not-viewed');
    }
}

function areAllMCQsAnswered() {
    const allMCQsAnswered = mcqQuestions.every(q => {
        let qid = q.id.split('-')[1];
        let radios = document.querySelectorAll('#question-' + qid + ' input[type=radio]');
        return Array.from(radios).some(r => r.checked);
    });

    return allMCQsAnswered;
}

// ===== ENHANCED CODING MARKS CALCULATION =====
function calculateCodingMarks() {
    const codingAnswers = sessionStorage.getItem('codingAnswers_' + lang + '_' + email);
    let codingMarks = 0;

    if (codingAnswers) {
        const answers = JSON.parse(codingAnswers);
        console.log("=== CALCULATING CODING MARKS ===");
        console.log("Total coding answers:", answers.length);
        
        answers.forEach(answer => {
            console.log("Checking answer for:", answer.questionId);
            console.log("Output:", answer.output);
            console.log("Level:", answer.level);
            
            if (answer.output && answer.output.includes('ALL TESTS PASSED')) {
                if (answer.level === 'easy') {
                    codingMarks += 5;
                    console.log("✅ Easy question passed: +5 marks");
                } else if (answer.level === 'medium') {
                    codingMarks += 10;
                    console.log("✅ Medium question passed: +10 marks");
                } else if (answer.level === 'hard') {
                    codingMarks += 15;
                    console.log("✅ Hard question passed: +15 marks");
                }
            } else {
                console.log("❌ Question not passed or no output");
            }
        });
        
        console.log("Total Coding Marks:", codingMarks);
        console.log("=== END CODING MARKS CALCULATION ===");
    } else {
        console.log("No coding answers found for marks calculation");
    }
    
    return codingMarks;
}

// ===== SUBMIT COMPLETE EXAM (MCQ + CODING) =====
function submitAllExam() {
    if (!confirm("Are you sure you want to submit the complete exam? This will end your exam session.")) return;

    let allAnswers = [];
    mcqQuestions.forEach(q => {
        let qid = q.id.split('-')[1];
        let radios = document.querySelectorAll('#question-' + qid + ' input[type=radio]');
        let selected = Array.from(radios).find(r => r.checked);
        allAnswers.push({ questionId: qid, answer: selected ? selected.value : " " });
    });

    // Calculate coding marks before submission
    const codingMarks = calculateCodingMarks();
    const codingAnswers = sessionStorage.getItem('codingAnswers_' + lang + '_' + email);

    console.log("=== FINAL SUBMISSION SUMMARY ===");
    console.log("MCQ Answers:", allAnswers.length);
    console.log("Coding Answers:", codingAnswers ? JSON.parse(codingAnswers).length : 0);
    console.log("Final Coding Marks:", codingMarks);
    console.log("=== END FINAL SUBMISSION SUMMARY ===");

    // First save MCQ answers
    //fetch('http://localhost:4049/student/saveAll?email=' + email +
	fetch('<%=request.getContextPath()%>/student/saveAll?email=' + email +
          '&languageName=' + lang, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(allAnswers)
    })
    .then(res => res.text())
    .then(data => {
        console.log("MCQ answers saved successfully");
        
        // Then save coding answers with marks if they exist
        if (codingAnswers) {
            //return fetch('http://localhost:4049/student/saveCoding?email=' + email +
			return fetch('<%=request.getContextPath()%>/student/saveCoding?email=' + email +
                  '&languageName=' + lang + '&codingMarks=' + codingMarks, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: codingAnswers
            })
            .then(res => res.text())
            .then(data => {
                console.log("Coding answers saved with marks:", codingMarks);
                completeExam(codingMarks);
            })
            .catch(err => {
                console.error("Error submitting coding:", err);
                completeExam(codingMarks);
            });
        } else {
            console.log("No coding answers to save");
            completeExam(codingMarks);
            return Promise.resolve();
        }
    })
    .catch(err => {
        console.error("Error submitting MCQ:", err);
        // Even if MCQ fails, try to save coding
        if (codingAnswers) {
            //fetch('http://localhost:4049/student/saveCoding?email=' + email +
			fetch('<%=request.getContextPath()%>/student/saveCoding?email=' + email +
                  '&languageName=' + lang + '&codingMarks=' + codingMarks, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: codingAnswers
            })
            .then(res => res.text())
            .then(data => {
                console.log("Coding answers saved after MCQ error");
                completeExam(codingMarks);
            })
            .catch(err => {
                console.error("Error submitting coding after MCQ error:", err);
                completeExam(codingMarks);
            });
        } else {
            completeExam(codingMarks);
        }
    });
}

// ===== CODING FUNCTIONS =====
let currentCodingQuestionId = null;

function initializeCodingSection() {
    // Setup language select change listeners for static dropdown
    document.querySelectorAll('.code-container select').forEach(select => {
        select.addEventListener("change", function () {
            const selectedLang = this.value;
            const containerId = this.id.split("languageNameSelect-")[1];
            const codeArea = document.getElementById("codeArea-" + containerId);

            // Auto-populate Java template if Java is selected
            if (selectedLang === "Java" && (!codeArea.value || codeArea.value.trim() === "")) {
                codeArea.value =
`public class Main {

    public static void main(String[] args) {
        // write your code here
    }

}`;
            }
            // Auto-populate Python template if Python is selected
            else if (selectedLang === "Python" && (!codeArea.value || codeArea.value.trim() === "")) {
                codeArea.value = `# write your code here`;
            }
            
            saveCodingAnswer(containerId);
        });
    });

    // Auto-save coding when user stops typing or changes language
    document.querySelectorAll('.code-container textarea, .code-container select').forEach(elem => {
        elem.addEventListener('input', () => {
            const questionId = elem.id.split('-').slice(1).join('-');
            if (questionId) {
                saveCodingAnswer(questionId);
            }
        });
    });

    // Show easy questions by default
    showCoding('easy');
}

function showCoding(level) {
    const allQuestions = document.querySelectorAll('.easy-question,.medium-question,.hard-question');
    allQuestions.forEach(q => q.style.display='none');

    const allCodeContainers = document.querySelectorAll('.code-container');
    allCodeContainers.forEach(c => c.style.display='none');

    const selectedQuestions = document.querySelectorAll('.' + level + '-question');
    selectedQuestions.forEach(q => q.style.display='list-item');

    if (selectedQuestions.length > 0) {
        const firstQuestion = selectedQuestions[0];
        currentCodingQuestionId = firstQuestion.getAttribute('data-question-id');
        const codeContainer = document.getElementById('codeContainer-' + currentCodingQuestionId);
        if (codeContainer) {
            codeContainer.style.display = 'block';
            restoreCodingAnswer(currentCodingQuestionId);
        }
    }
}

function restoreCodingAnswer(questionId) {
    const existingAnswers = sessionStorage.getItem('codingAnswers_' + lang + '_' + email);
    
    if (existingAnswers) {
        const answers = JSON.parse(existingAnswers);
        const savedAnswer = answers.find(a => a.questionId === questionId);
        
        if (savedAnswer) {
            const codeArea = document.getElementById('codeArea-' + questionId);
            const languageSelect = document.getElementById('languageNameSelect-' + questionId);
            const inputArea = document.getElementById('inputArea-' + questionId);
            const outputBox = document.getElementById('outputBox-' + questionId);

            if (codeArea) codeArea.value = savedAnswer.code || '';
            if (languageSelect) languageSelect.value = savedAnswer.language || '';
            if (inputArea) inputArea.value = savedAnswer.input || '';
            if (outputBox) outputBox.textContent = savedAnswer.output || '';
        }
    }
}

function saveCodingAnswer(questionId) {
    const questionElement = document.querySelector(`[data-question-id="${questionId}"]`);
    const level = questionId.split('-')[0];
    const questionText = questionElement?.querySelector('.question-content')?.textContent.trim() || '';
    const code = document.getElementById('codeArea-' + questionId)?.value || '';
    const language = document.getElementById('languageNameSelect-' + questionId)?.value || '';
    const input = document.getElementById('inputArea-' + questionId)?.value || '';
    const output = document.getElementById('outputBox-' + questionId)?.textContent || '';

    console.log("=== SAVING CODING ANSWER ===");
    console.log("Question ID:", questionId);
    console.log("Level:", level);
    console.log("Code length:", code.length);
    console.log("Output:", output);
    console.log("=== END SAVING CODING ANSWER ===");

    if (level && questionId) {
        const codingAnswer = {
            questionId: questionId,
            level: level,
            question: questionText,
            code: code,
            language: language,
            input: input,
            output: output,
            timestamp: new Date().toISOString()
        };

        let existingAnswers = sessionStorage.getItem('codingAnswers_' + lang + '_' + email);
        let answers = existingAnswers ? JSON.parse(existingAnswers) : [];
        
        // Remove existing answer for this question
        answers = answers.filter(a => a.questionId !== questionId);
        // Add new answer
        answers.push(codingAnswer);
        
        sessionStorage.setItem('codingAnswers_' + lang + '_' + email, JSON.stringify(answers));
        console.log("Coding answer saved for:", questionId);
    }
}

// ===== ENHANCED CODING SUBMISSION =====
function submitCoding() {
    if (!confirm("Are you sure you want to submit the coding answers? You can continue with MCQ questions.")) return;

    // Force save current coding answer before submission
    if (currentCodingQuestionId) {
        saveCodingAnswer(currentCodingQuestionId);
    }

    const codingAnswers = sessionStorage.getItem('codingAnswers_' + lang + '_' + email);
    
    if (codingAnswers && codingAnswers !== "[]") {
        // Calculate coding marks based on passed test cases
        const codingMarks = calculateCodingMarks();

        console.log("=== CODING SUBMISSION ===");
        console.log("Email:", email);
        console.log("Language:", lang);
        console.log("Coding Answers:", JSON.parse(codingAnswers));
        console.log("Calculated Coding Marks:", codingMarks);
        console.log("=== END CODING SUBMISSION ===");
        
        //fetch('http://localhost:4049/student/saveCoding?email=' + email +
		fetch('<%=request.getContextPath()%>/student/saveCoding?email=' + email +
              '&languageName=' + lang + '&codingMarks=' + codingMarks, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: codingAnswers
        })
        .then(res => res.text())
        .then(data => {
            alert("Coding answers submitted successfully! Marks: " + codingMarks);
            sessionStorage.setItem('codingSubmitted_' + lang + '_' + email, 'true');
            sessionStorage.setItem('codingMarks_' + lang + '_' + email, codingMarks.toString());
        })
        .catch(err => {
            console.error("Error submitting coding:", err);
            alert("Error submitting coding answers");
        });
    } else {
        console.log("No coding answers found in sessionStorage");
        alert("No coding answers to submit. Please write and run some code first.");
    }
}

// ===== FIXED COMPILER FUNCTION WITH ENHANCED OUTPUT EXTRACTION =====
async function runCode(questionId) {
    saveCodingAnswer(questionId);

    const codeArea = document.getElementById('codeArea-' + questionId);
    let code = codeArea?.value.trim();
    const langSelect = document.getElementById('languageNameSelect-' + questionId)?.value;
    const output = document.getElementById('outputBox-' + questionId);
    const inputContainer = document.getElementById('inputContainer-' + questionId);
    const stdin = document.getElementById('inputArea-' + questionId)?.value.trim();
    const testResult = document.getElementById('testResult-' + questionId);
    const testOutput = document.getElementById('testOutput-' + questionId);

    if (!output) {
        console.error("Output box not found for question:", questionId);
        return;
    }

    output.textContent = "⏳ Running code...";
    testResult.style.display = 'none';
    
    if (!langSelect || !code) {
        output.textContent = "⚠️ Select language and enter code";
        return;
    }

    // Get the question element and extract expected outputs
    const questionElement = findQuestionElement(questionId);
    if (!questionElement) {
        output.textContent = "⚠️ Question not found for ID: " + questionId;
        console.error("Question element not found for:", questionId);
        return;
    }

    // Extract expected output from data attribute
    const expectedOutput = questionElement.getAttribute('data-expected-output');
    
    console.log("=== DEBUG: EXTRACTING EXPECTED OUTPUT ===");
    console.log("Question ID:", questionId);
    console.log("Question Element:", questionElement);
    console.log("Expected Output from data attribute:", expectedOutput);
    console.log("=== END DEBUG ===");

    // If no expected output found, show warning
    if (!expectedOutput) {
        console.warn("No expected output found for question:", questionId);
        output.textContent = "⚠️ No expected output found for this question";
        return;
    }

    // Clean the expected output (remove brackets if present)
    const cleanExpectedOutput = expectedOutput.replace(/[\[\]]/g, '').trim();
    console.log("Cleaned Expected Output:", cleanExpectedOutput);

    // Auto-add Scanner import for Java if needed
    if (langSelect === "Java" && stdin) {
        if (!code.includes("Scanner") && !code.includes("java.util.Scanner")) {
            code = code.replace(
                /public static void main\s*\(.*?\)\s*\{/,
                `public static void main(String[] args) {
        java.util.Scanner sc = new java.util.Scanner(System.in);`
            );
        }
    }

    const languageMap = {
        "C": 50, 
        "C++": 54, 
        "Java": 62, 
        "Python": 71, 
        "JavaScript": 63
    };
    
    const langId = languageMap[langSelect.trim()];
    if (!langId) {
        output.textContent = "⚠️ Language not supported";
        return;
    }

    console.log("=== DEBUG: CODE EXECUTION ===");
    console.log("Language:", langSelect, "Language ID:", langId);
    console.log("Custom input provided:", stdin);
    console.log("Code length:", code.length);
    console.log("=== END DEBUG ===");

    try {
        output.textContent = "⏳ Executing code via Judge0 API...";
        
        const res = await fetch("https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=false&wait=true", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "x-rapidapi-key": "fa9b51c4c7mshb146cfecdaae923p1ea58djsn1d308e6087c3",
                "x-rapidapi-host": "judge0-ce.p.rapidapi.com"
            },
            body: JSON.stringify({
                source_code: code, 
                language_id: langId, 
                stdin: stdin || ""
            })
        });

        if (!res.ok) {
            throw new Error(`HTTP error! status: ${res.status}`);
        }

        const result = await res.json();
        let actualOutput = "";
        
        console.log("=== DEBUG: JUDGE0 RESPONSE ===");
        console.log("Full Judge0 response:", result);
        console.log("stdout:", result.stdout);
        console.log("stderr:", result.stderr);
        console.log("compile_output:", result.compile_output);
        console.log("=== END DEBUG ===");
        
        if (result.stdout) {
            actualOutput = result.stdout.trim();
            
            // Enhanced output extraction - extract only the result
            const extractedOutput = extractResultFromOutput(actualOutput, cleanExpectedOutput);
            
            output.textContent = "🧩 Code executed successfully.\n\nOutput:\n" + actualOutput;

            // Test against expected output
            testResult.style.display = 'block';
            
            console.log("=== DEBUG: TEST COMPARISON ===");
            console.log("Actual Output:", actualOutput);
            console.log("Extracted Output:", extractedOutput);
            console.log("Expected Output:", cleanExpectedOutput);
            console.log("=== END DEBUG ===");

            const normalizedExpected = normalizeOutput(cleanExpectedOutput);
            const normalizedActual = normalizeOutput(extractedOutput);

            console.log(`=== DEBUG: TEST CASE ===`);
            console.log("Normalized Expected:", normalizedExpected);
            console.log("Normalized Actual:", normalizedActual);
            console.log("Match:", normalizedExpected === normalizedActual);
            console.log("=== END TEST CASE DEBUG ===");

            let testResults = [];
            
            if (normalizedExpected === normalizedActual) {
                testResults.push(`✅ Test Case: PASSED`);
                testResults.push(`   Expected: ${cleanExpectedOutput}`);
                testResults.push(`   Got: ${extractedOutput}`);
                
                testOutput.style.color = "#90EE90";
                testResult.style.backgroundColor = "#1a472a";
                testResult.style.borderLeft = "4px solid #00ff00";
                output.textContent = "🧩 Code executed successfully.\n\nOutput:\n" + actualOutput + "\n\n✅ ALL TESTS PASSED";
                
                console.log("🎯 TEST PASSED - Question:", questionId, "Level:", questionId.split('-')[0]);
                
                // Store PASSED status for marks calculation
                saveCodingAnswer(questionId);
            } else {
                testResults.push(`❌ Test Case: FAILED`);
                testResults.push(`   Expected: ${cleanExpectedOutput}`);
                testResults.push(`   Got: ${extractedOutput}`);
                testResults.push(`   Full Output: ${actualOutput}`);
                
                testOutput.style.color = "#FF6B6B";
                testResult.style.backgroundColor = "#5c1e1e";
                testResult.style.borderLeft = "4px solid #ff0000";
                output.textContent = "🧩 Code executed successfully.\n\nOutput:\n" + actualOutput + "\n\n❌ TEST FAILED";
            }

            testOutput.textContent = testResults.join('\n');
        } else if (result.compile_output) {
            output.textContent = "❌ Compilation Error:\n" + result.compile_output;
        } else if (result.stderr) {
            output.textContent = "❌ Runtime Error:\n" + result.stderr;
        } else {
            output.textContent = "⚠️ No output received. Check your code or input.";
        }

        saveCodingAnswer(questionId);
    } catch (e) {
        console.error("Error executing code:", e);
        output.textContent = "🚫 Error:\n" + e.message;
    }
}

// Enhanced function to extract only the result from output
function extractResultFromOutput(fullOutput, expectedOutput) {
    console.log("=== DEBUG: EXTRACTING RESULT ===");
    console.log("Full Output:", fullOutput);
    console.log("Expected Output:", expectedOutput);
    
    // Split into lines and trim each line
    const lines = fullOutput.split('\n').map(line => line.trim()).filter(line => line !== '');
    
    // Strategy 1: Look for lines that contain the expected output
    for (let line of lines) {
        if (line.includes(expectedOutput)) {
            console.log("Found matching line:", line);
            return expectedOutput;
        }
    }
    
    // Strategy 2: Look for common patterns in output
    for (let line of lines) {
        // Remove common prefixes like "reversed string:", "result:", etc.
        const cleanLine = line.replace(/(reversed string|result|output|answer)[:\s]*/gi, '').trim();
        if (cleanLine && cleanLine.length > 0) {
            console.log("Cleaned line:", cleanLine);
            return cleanLine;
        }
    }
    
    // Strategy 3: Return the last non-empty line (common pattern in coding challenges)
    if (lines.length > 0) {
        const lastLine = lines[lines.length - 1];
        console.log("Using last line:", lastLine);
        return lastLine;
    }
    
    // Strategy 4: Return the full output as fallback
    console.log("Using full output as fallback");
    return fullOutput;
}

// Enhanced helper function to find the question element
function findQuestionElement(questionId) {
    const [level, index] = questionId.split('-');
    
    // Method 1: Find by class
    const questionElements = document.querySelectorAll(`.${level}-question`);
    if (questionElements.length > parseInt(index)) {
        return questionElements[parseInt(index)];
    }
    
    // Method 2: Find by data attribute
    const allQuestions = document.querySelectorAll('[data-question-id]');
    for (let question of allQuestions) {
        if (question.getAttribute('data-question-id') === questionId) {
            return question;
        }
    }
    
    // Method 3: Find in the questions list container
    const questionsContainer = document.getElementById('questionsList');
    if (questionsContainer) {
        const questions = questionsContainer.querySelectorAll('li');
        for (let question of questions) {
            if (question.getAttribute('data-question-id') === questionId) {
                return question;
            }
        }
    }
    
    console.error("Could not find question element for:", questionId);
    return null;
}

// Enhanced output normalization function
function normalizeOutput(text) {
    if (!text) return "";
    return text
        .replace(/\r\n/g, "\n")
        .replace(/\r/g, "\n")
        .split('\n')
        .map(line => line.trim())
        .filter(line => line !== '')
        .join('\n')
        .replace(/\s+/g, ' ')
        .trim()
        .toLowerCase();
}

function completeExam(codingMarks = 0) {
    sessionStorage.removeItem('examTimer_' + lang + '_' + email);
    sessionStorage.removeItem('codingSubmitted_' + lang + '_' + email);
    mcqQuestions.forEach(q => {
        let qid = q.id.split('-')[1];
        sessionStorage.removeItem('mcq-' + qid + '_' + lang + '_' + email);
        sessionStorage.removeItem('viewed-' + qid + '_' + lang + '_' + email);
    });
    sessionStorage.removeItem('codingAnswers_' + lang + '_' + email);

    const totalQuestions = mcqQuestions.length || 0;
    
    console.log("=== EXAM COMPLETION ===");
    console.log("Redirecting to result page...");
    console.log("Coding Marks:", codingMarks);
    console.log("Total MCQ Questions:", totalQuestions);
    console.log("=== END EXAM COMPLETION ===");
    
    // Make sure codingMarks is passed as a parameter
    //window.location.href = 'http://localhost:4049/student/result?email=' + email +
	window.location.href = '<%=request.getContextPath()%>/student/result?email=' + email +
                           '&languageName=' + lang +
                           '&totalMarks=' + totalQuestions +
                           '&codingMarks=' + codingMarks;
}

// Debug function to check coding answers
function debugCodingAnswers() {
    const codingAnswers = sessionStorage.getItem('codingAnswers_' + lang + '_' + email);
    console.log("=== DEBUG CODING ANSWERS ===");
    console.log("Session Storage Key:", 'codingAnswers_' + lang + '_' + email);
    console.log("Coding Answers:", codingAnswers);
    if (codingAnswers) {
        console.log("Parsed Coding Answers:", JSON.parse(codingAnswers));
    }
    console.log("Current Coding Question ID:", currentCodingQuestionId);
    console.log("=== END DEBUG ===");
}

// Clear timer when page unloads
window.addEventListener('beforeunload', function() {
    if (timerInterval) {
        clearInterval(timerInterval);
    }
});
</script>

</body>
</html>