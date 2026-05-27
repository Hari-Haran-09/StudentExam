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
.upload-section {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 25px;
    border: 2px dashed #007bff;
    width: 75%;
}
.upload-btn {
    padding: 10px 20px;
    background: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 14px;
    margin-left: 10px;
}
.upload-btn:hover {
    background: #0056b3;
}
.status-message {
    margin-top: 10px;
    padding: 10px;
    border-radius: 5px;
    display: none;
}
.success {
    background: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
    display: block;
}
.error {
    background: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
    display: block;
}
.loading {
    display: inline-block;
    width: 16px;
    height: 16px;
    border: 3px solid #f3f3f3;
    border-top: 3px solid #007bff;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-right: 8px;
    vertical-align: middle;
}
@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>
</head>
<body>
<div style="width: 90%; margin: 0 auto; padding: 20px;">
 
    <div class="add-header">
        <div class="h1" style="font-weight: 600; font-size: 27px;">Add Coding Questions</div>
    </div>

     Excel Upload Section 
    <div class="upload-section">
        <p style="font-weight: 600; font-size: 16px; margin-bottom: 10px;">Excel Upload</p>
        <p style="font-size: 14px; color: #666; margin-bottom: 15px;">
            Upload an Excel file to automatically fill questions and test cases
        </p>
        <div style="display: flex; align-items: center; gap: 10px;">
            <select id="excelLanguage" class="select">
                <option value="" disabled selected>Select Language</option>
            </select>
            <input type="file" id="excelFile" accept=".xlsx,.xls" style="padding: 8px;">
			<button type="button" id="uploadBtn" onclick="uploadExcel()">
			  📤 Upload & Auto Fill
			</button>

        </div>
        <div id="uploadStatus" class="status-message"></div>
    </div>
 
    <form id="questionForm" action="${pageContext.request.contextPath}/student/saveQuestions" method="post">
 
        <div class="dropdown">
            <select id="languageName" name="languageName" required class="select">
                <option value="" disabled selected>Select Coding Language</option>
            </select>
        </div>
 
        <div class="text">
            
             Easy Level Section 
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
                     Test cases will be added dynamically 
                </div>
            </div>
 
             Medium Level Section 
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
                     Test cases will be added dynamically 
                </div>
            </div>
 
             Hard Level Section 
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
                     Test cases will be added dynamically 
                </div>
            </div>
 
        </div>
 
        <div class="button1">
            <button type="submit" class="save-btn">Save Questions</button>
        </div>
 
    </form>
 
</div>
 
<script>
// Global variables
let currentUploading = false;
let excelFillDone = false;
let isFilling = false;


// Fetch Language Name
fetch("<%=request.getContextPath()%>/student/getLanguage")
    .then(res => res.json())
    .then(data => {
        const languageSelect = document.getElementById("languageName");
        const excelLanguageSelect = document.getElementById("excelLanguage");
 
        data.forEach(item => {
            // Main dropdown
            const opt = document.createElement("option");
            opt.value = item.languageName;
            opt.textContent = item.languageName;
            languageSelect.appendChild(opt);
            
            // Excel dropdown
            const opt2 = document.createElement("option");
            opt2.value = item.languageName;
            opt2.textContent = item.languageName;
            excelLanguageSelect.appendChild(opt2);
        });
    })
    .catch(err => console.error("Error fetching languages:", err));

// ==========================================
// EXCEL UPLOAD FUNCTION
// ==========================================
function uploadExcel() {
	if (event) event.preventDefault();
    if (currentUploading) return;
    
    const fileInput = document.getElementById("excelFile");
    const languageSelect = document.getElementById("excelLanguage");
    const file = fileInput.files[0];
    const language = languageSelect.value;
    const uploadBtn = document.getElementById("uploadBtn");
    
    console.log("=== UPLOAD STARTED ===");
    console.log("File:", file ? file.name : "No file");
    console.log("Language:", language);
    
    // Validation
    if (!language) {
        showStatus("Please select a language first.", "error");
        return;
    }
    
    if (!file) {
        showStatus("Please select an Excel file.", "error");
        return;
    }
    
    // Validate file size (max 10MB)
    if (file.size > 10 * 1024 * 1024) {
        showStatus("File size should be less than 10MB.", "error");
        return;
    }
    
    // Validate file extension
    const validExtensions = ['.xlsx', '.xls'];
    const fileExtension = file.name.substring(file.name.lastIndexOf('.')).toLowerCase();
    if (!validExtensions.includes(fileExtension)) {
        showStatus("Please select a valid Excel file (.xlsx or .xls).", "error");
        return;
    }
    
    const formData = new FormData();
    formData.append("file", file);
    formData.append("language", language);
    
    // Show loading
    currentUploading = true;
    uploadBtn.innerHTML = '<span class="loading"></span> Uploading...';
    uploadBtn.disabled = true;
    
    showStatus("Uploading Excel file...", "success");
    
    fetch("<%=request.getContextPath()%>/student/uploadExcel", {
        method: "POST",
        body: formData
    })
    .then(res => {
        console.log("Response status:", res.status);
        
        if (!res.ok) {
            return res.text().then(text => {
                console.error("Error response:", text);
                throw new Error(`Server error ${res.status}: ${text || res.statusText}`);
            });
        }
        
        return res.json();
    })
    .then(data => {
        console.log("=== RESPONSE DATA ===");
        console.log("Full response:", JSON.stringify(data, null, 2));
        
        if (data.success === true) {
            showStatus(data.message || "Excel uploaded successfully!", "success");
            
            // Fill the form
            if (data.data) {
                console.log("Calling fillFromExcel...");
                fillFromExcel(data.data);
            } else {
                console.error("No data.data in response!");
            }
            
            // Clear file input
            fileInput.value = '';
        } else {
            throw new Error(data.message || "Failed to process Excel file");
        }
    })
    .catch(err => {
        console.error('Upload error:', err);
        showStatus("Upload failed: " + err.message, "error");
    })
    .finally(() => {
        currentUploading = false;
        uploadBtn.innerHTML = '📤 Upload & Auto Fill';
        uploadBtn.disabled = false;
    });
}

// ==========================================
// FILL FROM EXCEL
// ==========================================
function fillFromExcel(data) {
	// Prevent multiple simultaneous calls
	  if (isFilling) {
	      console.warn("Already filling form, skipping duplicate call");
	      return;
	  }
	  
	  isFilling = true;
	  console.log("\n=== FILL FROM EXCEL STARTED ===");
	  console.log("Data structure:", Object.keys(data));
	  
 
	
    // Set language in both dropdowns
    if (data.language) {
        document.getElementById("languageName").value = data.language;
        document.getElementById("excelLanguage").value = data.language;
        console.log("✓ Set language to:", data.language);
    }
    
    // Clear existing test cases
    document.getElementById('easyTestCases').innerHTML = '';
    document.getElementById('mediumTestCases').innerHTML = '';
    document.getElementById('hardTestCases').innerHTML = '';
    console.log("✓ Cleared all test cases");
    
    // Process each level
    const levels = ['easy', 'medium', 'hard'];
    levels.forEach(level => {
        console.log(`\n--- Processing ${level.toUpperCase()} ---`);
        
        const levelData = data[level];
        if (!levelData) {
            console.warn(`No data for ${level}`);
            if (level === 'easy') addEasyTestCase();
            if (level === 'medium') addMediumTestCase();
            if (level === 'hard') addHardTestCase();
            return;
        }
        
        console.log(`${level} data:`, levelData);
        
		const questionFieldName = level + "Question";
		const questionField = document.querySelector('textarea[name="' + questionFieldName + '"]');
        console.log(`Looking for textarea[name="${level}Question"]`);
        console.log("Found question field:", !!questionField);
        console.log("Question text:", levelData.question);
        
        if (questionField) {
            if (levelData.question) {
                questionField.value = levelData.question;
                // Force textarea to resize
                setTimeout(() => {
                    questionField.style.height = 'auto';
                    questionField.style.height = (questionField.scrollHeight) + 'px';
                }, 10);
                console.log(`✓ Set ${level} question: "${levelData.question.substring(0, 50)}..."`);
            } else {
                console.warn(`⚠ Question is empty for ${level}`);
                questionField.value = "";
            }
        } else {
            console.error(`✗ Question field NOT FOUND for ${level}!`);
        }
        
        // Add test cases
        const testCases = levelData.testCases;
        if (testCases && Array.isArray(testCases) && testCases.length > 0) {
            console.log(`Found ${testCases.length} test cases for ${level}`);
            
            testCases.forEach((tc, index) => {
                const input = tc.input || "";
                const output = tc.output || "";
                
                console.log(`  Test case ${index + 1}: input="${input}", output="${output}"`);
                
                // Add test case with data
                if (level === 'easy') addEasyTestCase(input, output);
                if (level === 'medium') addMediumTestCase(input, output);
                if (level === 'hard') addHardTestCase(input, output);
            });
        } else {
            console.warn(`No test cases for ${level}, adding empty one`);
            if (level === 'easy') addEasyTestCase();
            if (level === 'medium') addMediumTestCase();
            if (level === 'hard') addHardTestCase();
        }
    });
    
    console.log("\n=== FILL COMPLETED ===");
    
    // Verify all questions were set
    console.log("\n=== VERIFICATION ===");
    const easyQ = document.querySelector('textarea[name="easyQuestion"]');
    const mediumQ = document.querySelector('textarea[name="mediumQuestion"]');
    const hardQ = document.querySelector('textarea[name="hardQuestion"]');
    
    console.log("Easy question length:", easyQ ? easyQ.value.length : "NOT FOUND");
    console.log("Medium question length:", mediumQ ? mediumQ.value.length : "NOT FOUND");
    console.log("Hard question length:", hardQ ? hardQ.value.length : "NOT FOUND");
    
    if (easyQ && easyQ.value) console.log("Easy Q preview:", easyQ.value.substring(0, 50));
    if (mediumQ && mediumQ.value) console.log("Medium Q preview:", mediumQ.value.substring(0, 50));
    if (hardQ && hardQ.value) console.log("Hard Q preview:", hardQ.value.substring(0, 50));
    
    showStatus("Form filled successfully from Excel!", "success");
    window.scrollTo({ top: 0, behavior: 'smooth' });
	
	isFilling = false;

}

// ==========================================
// TEST CASE MANAGEMENT (UPDATED)
// ==========================================
function addEasyTestCase(inputValue = "", outputValue = "") {
    const testCasesDiv = document.getElementById('easyTestCases');
    const testCaseNum = testCasesDiv.children.length + 1;
    const newTestCase = document.createElement('div');
    newTestCase.className = 'test-case-section';
    newTestCase.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <p class="sub-ques" style="margin: 0;">Test Case ${testCaseNum}</p>
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
    
    // Set values if provided
    const textareas = newTestCase.querySelectorAll('textarea');
    if (inputValue) {
        textareas[0].value = inputValue;
        textareas[0].style.height = 'auto';
        textareas[0].style.height = (textareas[0].scrollHeight) + 'px';
    }
    if (outputValue) {
        textareas[1].value = outputValue;
        textareas[1].style.height = 'auto';
        textareas[1].style.height = (textareas[1].scrollHeight) + 'px';
    }
}
 
function addMediumTestCase(inputValue = "", outputValue = "") {
    const testCasesDiv = document.getElementById('mediumTestCases');
    const testCaseNum = testCasesDiv.children.length + 1;
    const newTestCase = document.createElement('div');
    newTestCase.className = 'test-case-section';
    newTestCase.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <p class="sub-ques" style="margin: 0;">Test Case ${testCaseNum}</p>
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
    
    const textareas = newTestCase.querySelectorAll('textarea');
    if (inputValue) {
        textareas[0].value = inputValue;
        textareas[0].style.height = 'auto';
        textareas[0].style.height = (textareas[0].scrollHeight) + 'px';
    }
    if (outputValue) {
        textareas[1].value = outputValue;
        textareas[1].style.height = 'auto';
        textareas[1].style.height = (textareas[1].scrollHeight) + 'px';
    }
}
 
function addHardTestCase(inputValue = "", outputValue = "") {
    const testCasesDiv = document.getElementById('hardTestCases');
    const testCaseNum = testCasesDiv.children.length + 1;
    const newTestCase = document.createElement('div');
    newTestCase.className = 'test-case-section';
    newTestCase.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <p class="sub-ques" style="margin: 0;">Test Case ${testCaseNum}</p>
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
    
    const textareas = newTestCase.querySelectorAll('textarea');
    if (inputValue) {
        textareas[0].value = inputValue;
        textareas[0].style.height = 'auto';
        textareas[0].style.height = (textareas[0].scrollHeight) + 'px';
    }
    if (outputValue) {
        textareas[1].value = outputValue;
        textareas[1].style.height = 'auto';
        textareas[1].style.height = (textareas[1].scrollHeight) + 'px';
    }
}

function showStatus(message, type) {
    const statusDiv = document.getElementById("uploadStatus");
    if (statusDiv) {
        statusDiv.textContent = message;
        statusDiv.className = "status-message " + type;
        
        setTimeout(() => {
            statusDiv.style.display = 'none';
        }, 5000);
    }
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
document.addEventListener('input', function(e) {
    if (e.target.tagName === 'TEXTAREA') {
        e.target.style.height = 'auto';
        e.target.style.height = (e.target.scrollHeight) + 'px';
    }
});

// Diagnostic function - run this in console to check question values


console.log("Diagnostic function loaded. Run checkQuestions() in console to verify question values.");
</script>
</body>
</html>