<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Coding Questions</title>
<style>
body {
    width: 100%;
    font-family: Arial, sans-serif;
}
.add-header {
    width: fit-content;
    margin-bottom: 20px;
}
.text {
    width: 98.7%;
}
.question-box {
    width: 75.3%;
    height: 87px;
    margin-bottom: 10px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    resize: vertical;
}
.input-output-box {
    width: 75.3%;
    height: 60px;
    margin-bottom: 10px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    resize: vertical;
}
.button1 {
    width: 75%;
    margin-top: 20px;
    display: flex;
    justify-content: end;
}
.save-btn {
    padding: 10px 20px;
    background: #058C17;
    color: white;
    border-radius: 5px;
    border: none;
    cursor: pointer;
    font-size: 16px;
}
.save-btn:hover {
    background: #046a12;
}
.ques {
    font-weight: 600;
    font-size: 18px;
    margin-bottom: 5px;
}
.sub-ques {
    font-weight: 500;
    font-size: 14px;
    color: #555;
    margin-bottom: 3px;
}
.select{
    padding: 8px 12px;
    outline: none;
    border: 1px solid #ccc;
    border-radius: 5px;
    width: 200px;
}
.dropdown{
    width: 75%;
    display: flex;
    justify-content: end;
    margin-bottom: 20px;
}
.question-section {
    margin-bottom: 25px;
    padding: 15px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    background-color: #f9f9f9;
}
.level-title {
    color: #333;
    border-bottom: 2px solid #058C17;
    padding-bottom: 5px;
    margin-bottom: 15px;
}
.test-case-section {
    margin: 15px 0;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #fff;
}
.add-test-case-btn {
    padding: 8px 15px;
    background: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin: 10px 0;
}
.add-test-case-btn:hover {
    background: #0056b3;
}
.remove-test-case-btn {
    padding: 5px 10px;
    background: #dc3545;
    color: white;
    border: none;
    border-radius: 3px;
    cursor: pointer;
    margin-left: 10px;
}
.remove-test-case-btn:hover {
    background: #c82333;
}
.test-case-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}
</style>
</head>
<body>
<div style="width: 90%; margin: 0 auto; padding: 20px;">

    <div class="add-header">
        <div class="h1" style="font-weight: 600; font-size: 27px;">Add Coding Questions</div>
    </div>

    <form id="questionForm" action="${pageContext.request.contextPath}/student/saveQuestions" method="post">

        <div class="dropdown">
            <select id="languageName" name="languageName" required class="select">
                <option value="" disabled selected>Select Coding Language</option>
            </select>
        </div>

        <div class="text">
            
            <!-- Easy Level Section -->
            <div class="question-section">
                <div class="test-case-header">
                    <h3 class="level-title">Easy Level</h3>
                    <button type="button" class="add-test-case-btn" onclick="addEasyTestCase()">+ Add Test Case</button>
                </div>
                
                <div class="text1">
                    <p class="ques">Question</p>
                    <textarea class="question-box" name="easyQuestion" placeholder="Enter easy level question" required></textarea>
                </div>
                
                <div id="easyTestCases">
                    <!-- Test cases will be added dynamically -->
                </div>
            </div>

            <!-- Medium Level Section -->
            <div class="question-section">
                <div class="test-case-header">
                    <h3 class="level-title">Medium Level</h3>
                    <button type="button" class="add-test-case-btn" onclick="addMediumTestCase()">+ Add Test Case</button>
                </div>
                
                <div class="text1">
                    <p class="ques">Question</p>
                    <textarea class="question-box" name="mediumQuestion" placeholder="Enter medium level question" required></textarea>
                </div>
                
                <div id="mediumTestCases">
                    <!-- Test cases will be added dynamically -->
                </div>
            </div>

            <!-- Hard Level Section -->
            <div class="question-section">
                <div class="test-case-header">
                    <h3 class="level-title">Hard Level</h3>
                    <button type="button" class="add-test-case-btn" onclick="addHardTestCase()">+ Add Test Case</button>
                </div>
                
                <div class="text1">
                    <p class="ques">Question</p>
                    <textarea class="question-box" name="hardQuestion" placeholder="Enter hard level question" required></textarea>
                </div>
                
                <div id="hardTestCases">
                    <!-- Test cases will be added dynamically -->
                </div>
            </div>

        </div>

        <div class="button1">
            <button type="submit" class="save-btn">Save Questions</button>
        </div>

    </form>

</div>

<script>
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
    .catch(err => console.error("Error fetching languages:", err));

// Test Case Management
function addEasyTestCase() {
    const testCasesDiv = document.getElementById('easyTestCases');
    const newTestCase = document.createElement('div');
    newTestCase.className = 'test-case-section';
    newTestCase.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <p class="sub-ques" style="margin: 0;">Test Case ${testCasesDiv.children.length + 1}</p>
            <button type="button" class="remove-test-case-btn" onclick="this.parentElement.parentElement.remove(); renumberTestCases('easyTestCases')">Remove</button>
        </div>
        <div class="text1">
            <p class="sub-ques">Sample Input</p>
            <textarea class="input-output-box" name="easyInput" placeholder="Enter sample input for easy question"></textarea>
        </div>
        <div class="text1">
            <p class="sub-ques">Expected Output</p>
            <textarea class="input-output-box" name="easyExpectedOutput" placeholder="Enter expected output for easy question"></textarea>
        </div>
    `;
    testCasesDiv.appendChild(newTestCase);
}

function addMediumTestCase() {
    const testCasesDiv = document.getElementById('mediumTestCases');
    const newTestCase = document.createElement('div');
    newTestCase.className = 'test-case-section';
    newTestCase.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <p class="sub-ques" style="margin: 0;">Test Case ${testCasesDiv.children.length + 1}</p>
            <button type="button" class="remove-test-case-btn" onclick="this.parentElement.parentElement.remove(); renumberTestCases('mediumTestCases')">Remove</button>
        </div>
        <div class="text1">
            <p class="sub-ques">Sample Input</p>
            <textarea class="input-output-box" name="mediumInput" placeholder="Enter sample input for medium question"></textarea>
        </div>
        <div class="text1">
            <p class="sub-ques">Expected Output</p>
            <textarea class="input-output-box" name="mediumExpectedOutput" placeholder="Enter expected output for medium question"></textarea>
        </div>
    `;
    testCasesDiv.appendChild(newTestCase);
}

function addHardTestCase() {
    const testCasesDiv = document.getElementById('hardTestCases');
    const newTestCase = document.createElement('div');
    newTestCase.className = 'test-case-section';
    newTestCase.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <p class="sub-ques" style="margin: 0;">Test Case ${testCasesDiv.children.length + 1}</p>
            <button type="button" class="remove-test-case-btn" onclick="this.parentElement.parentElement.remove(); renumberTestCases('hardTestCases')">Remove</button>
        </div>
        <div class="text1">
            <p class="sub-ques">Sample Input</p>
            <textarea class="input-output-box" name="hardInput" placeholder="Enter sample input for hard question"></textarea>
        </div>
        <div class="text1">
            <p class="sub-ques">Expected Output</p>
            <textarea class="input-output-box" name="hardExpectedOutput" placeholder="Enter expected output for hard question"></textarea>
        </div>
    `;
    testCasesDiv.appendChild(newTestCase);
}

function renumberTestCases(containerId) {
    const container = document.getElementById(containerId);
    const testCases = container.getElementsByClassName('test-case-section');
    Array.from(testCases).forEach((testCase, index) => {
        const title = testCase.querySelector('.sub-ques');
        if (title) {
            title.textContent = `Test Case ${index + 1}`;
        }
    });
}

// Initialize with one test case for each level
document.addEventListener('DOMContentLoaded', function() {
    addEasyTestCase();
    addMediumTestCase();
    addHardTestCase();
});

// Form submission
document.getElementById("questionForm").addEventListener("submit", function (e) {
    const language = document.getElementById("languageName").value;
    const easyQuestion = document.querySelector('[name="easyQuestion"]').value;
    const mediumQuestion = document.querySelector('[name="mediumQuestion"]').value;
    const hardQuestion = document.querySelector('[name="hardQuestion"]').value;
    
    if (!language || !easyQuestion || !mediumQuestion || !hardQuestion) {
        alert("Please fill in all required fields (Language and all three questions).");
        e.preventDefault();
        return;
    }
    
    // Collect all test cases from dynamic fields
    const easyInputs = document.querySelectorAll('#easyTestCases textarea[name="easyInput"]');
    const easyOutputs = document.querySelectorAll('#easyTestCases textarea[name="easyExpectedOutput"]');
    const mediumInputs = document.querySelectorAll('#mediumTestCases textarea[name="mediumInput"]');
    const mediumOutputs = document.querySelectorAll('#mediumTestCases textarea[name="mediumExpectedOutput"]');
    const hardInputs = document.querySelectorAll('#hardTestCases textarea[name="hardInput"]');
    const hardOutputs = document.querySelectorAll('#hardTestCases textarea[name="hardExpectedOutput"]');
    
    // Create hidden fields for arrays
    easyInputs.forEach((textarea, index) => {
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'easyInputArray';
        hiddenInput.value = textarea.value;
        this.appendChild(hiddenInput);
    });
    
    easyOutputs.forEach((textarea, index) => {
        const hiddenOutput = document.createElement('input');
        hiddenOutput.type = 'hidden';
        hiddenOutput.name = 'easyExpectedOutputArray';
        hiddenOutput.value = textarea.value;
        this.appendChild(hiddenOutput);
    });
    
    mediumInputs.forEach((textarea, index) => {
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'mediumInputArray';
        hiddenInput.value = textarea.value;
        this.appendChild(hiddenInput);
    });
    
    mediumOutputs.forEach((textarea, index) => {
        const hiddenOutput = document.createElement('input');
        hiddenOutput.type = 'hidden';
        hiddenOutput.name = 'mediumExpectedOutputArray';
        hiddenOutput.value = textarea.value;
        this.appendChild(hiddenOutput);
    });
    
    hardInputs.forEach((textarea, index) => {
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'hardInputArray';
        hiddenInput.value = textarea.value;
        this.appendChild(hiddenInput);
    });
    
    hardOutputs.forEach((textarea, index) => {
        const hiddenOutput = document.createElement('input');
        hiddenOutput.type = 'hidden';
        hiddenOutput.name = 'hardExpectedOutputArray';
        hiddenOutput.value = textarea.value;
        this.appendChild(hiddenOutput);
    });
    
    const confirmation = confirm(`Do you want to save coding questions for ${language}?`);
    if (!confirmation) {
        e.preventDefault();
    }
});

// Auto-resize textareas
document.querySelectorAll('textarea').forEach(textarea => {
    textarea.addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
    });
});
</script>
</body>
</html>