<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update ExamScreen</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap');

  .main-box {
      display: flex;
      flex-direction: row;
      gap: 17%;
      width: 50%;
      padding: 1%;
      margin-right: 18%;
      align-items: center;
  }

  .h1 {
      font-weight: bold;
      font-family: "Roboto", sans-serif;
      font-size: 115%;
      margin: 0;
  }

  .xx {
      display: flex;
      flex-direction: row;
      gap: 20px;
      margin-left: 20px;
  }

  button {
      padding: 10px 12px;
      font-size: 80%;
  }

  .main-container{
      position: relative;
  }

  .ques{
      font-family: "Roboto", sans-serif;
      font-weight: bold;
	  white-space: pre-wrap; /* recently added */
  }

  .questions {
      display: flex;
      flex-direction: row;
      gap: 5%;
  }

  .mda{
      padding:1%;
  }

  .pagination-controls {
      display: flex;
      justify-content: center;
      padding: 20px 0;
      gap: 10px;
      width: 73%;
  }

  .pagination-button {
      padding: 8px 12px;
      border: 1px solid #ccc;
      background-color: #fff;
      cursor: pointer;
      border-radius: 4px;
  }

  .pagination-button.active {
      background-color: #007bff;
      color: white;
      border-color: #007bff;
      font-weight: bold;
  }

  .coding-question{
      display: flex;
      flex-direction: column;
      border: 1px solid #ddd;
      padding: 20px;
      margin-bottom: 20px;
      border-radius: 8px;
      background-color: #f9f9f9;
  }

  .all-coding-questions-wrapper{
      display: none;
  }

  .btn-1-1{
      margin-top:1%;
  }
  .btn-1{
      margin-top:1%;
  }
  .easy, .medium, .hard{
      font-family: "Roboto", sans-serif;
      font-size: 140%;
      color: #333;
      border-bottom: 2px solid gray;
      padding-bottom: 5px;
  }
  .random{
      display: flex;
      flex-direction: row;
      gap : 5%;
      margin-right: 50%;
  }
  .mcq, .coding{
      background-color: rgba(47, 173, 228, 1);
      color:rgba(255, 255, 255, 1);
      border-width: 0;
      font-weight: bold;
  }
  
  /* New styles for test case display */
  .question-section {
      margin: 15px 0;
      padding: 15px;
      background: white;
      border-radius: 5px;
  }
  
  .test-case {
      background: #f8f9fa;
      border: 1px solid #dee2e6;
      border-radius: 5px;
      padding: 15px;
      margin: 10px 0;
      font-family: monospace;
  }
  
  .test-case-header {
      font-weight: bold;
      color: #495057;
      margin-bottom: 8px;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 8px;
  }
  
  .test-case-number {
      background: #007bff;
      color: white;
      padding: 2px 8px;
      border-radius: 12px;
      font-size: 12px;
  }
  
  .test-case-content {
      margin-left: 10px;
  }
  
  .input-line, .output-line {
      margin: 5px 0;
      padding: 3px 0;
  }
  
  .input-label, .output-label {
      font-weight: bold;
      color: #28a745;
  }
  
  .output-label {
      color: #dc3545;
  }
  
  pre {
      white-space: pre-wrap;
      word-wrap: break-word;
      margin: 0;
      font-size: 13px;
      display: inline;
  }
  
  .question-content {
      margin-bottom: 15px;
      line-height: 1.5;
  }
  
  .edit-btn-container {
      display: flex;
      justify-content: center;
      margin-top: 20px;
  }
  
  .no-test-cases {
      color: #6c757d;
      font-style: italic;
      text-align: center;
      padding: 10px;
  }
</style>
</head>
<body>
<div class="main-container">
    <div class="main-box">
        <h1 class="h1">Exam Details Overview</h1>
        <div class="xx">
            <button class="mcq" id="mcqs-button">MCQ'S</button>
            <button class="coding" id="coding-button">Coding</button>
        </div>
    </div>

    <!-- Language Selection -->
    <form action="mcq" method="get">
        <div style="width: 80%; display: flex; justify-content: end; margin-bottom: 10px">
            <select id="languageName" name="languageName" required class="select" style="padding-top: 7px; padding-bottom: 7px; outline: none;">
                <option value="" disabled selected>Select Coding Language</option>
            </select>
        </div>

        <div id="all-questions-wrapper" style="width: 73%;">
            <!-- MCQs populated dynamically -->
        </div>
    </form>

    <!-- Coding Questions -->
    <form action="coding" method="get">
        <div id="all-coding-questions-wrapper" class="all-coding-questions-wrapper">
            <!-- Coding questions populated dynamically -->
        </div>
    </form>

    <p id="empty-message" style="width: 80%; display: none; padding: 20px; text-align: center; font-style: italic;">No coding questions found. Click "Add Coding Questions" to create one.</p>

</div>

<div id="pagination-controls" class="pagination-controls"></div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const mcqsWrapper = document.getElementById('all-questions-wrapper');
    const codingWrapper = document.getElementById('all-coding-questions-wrapper');
    const paginationContainer = document.getElementById('pagination-controls');
    const mcqsButton = document.getElementById('mcqs-button');
    const codingButton = document.getElementById('coding-button');
    const emptyMessage = document.getElementById('empty-message');
    const languageSelect = document.getElementById("languageName");

    const itemsPerPage = 2;
    let mcqData = [];
    let questionItems = [];

    function loadMCQs(language = 'Java') {
        if (!language) return;
        console.log("language is...........", language);
        
        const url = "<%=request.getContextPath()%>/student/getMcqsByLanguage?languageName=" + language;
        console.log("Fetching MCQs from URL:", url);

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error(`Failed to fetch MCQs: ${response.status}`);
                return response.json();
            })
            .then(data => {
                mcqData = data;
                populateMCQs(data);
                updatePagination();
                displayPage(0);
            })
            .catch(error => {
                console.error('Error fetching MCQs:', error);
                mcqsWrapper.innerHTML = '<p style="text-align: center; color: red;">Error loading MCQs. Please try again.</p>';
            });
    }

    function populateMCQs(data) {
        mcqsWrapper.innerHTML = '';
		
		// Function to safely escape HTML characters
		function escapeHTML(str) {
		    if (!str) return '';
		    return str
		        .replace(/&/g, "&amp;")
		        .replace(/</g, "&lt;")
		        .replace(/>/g, "&gt;")
		        .replace(/"/g, "&quot;")
		        .replace(/'/g, "&#039;");
		}

        data.forEach(item => {
            const questionDiv = document.createElement('div');
            questionDiv.className = 'questions question-item mcq-type';

            let optionsHtml = '';
            const options = item.optionText.split(', ');
            options.forEach(opt => {
                const trimmedOpt = opt.trim();
                const isCorrect = trimmedOpt.startsWith(item.correctOption + '.');
                const checkedAttr = isCorrect ? 'checked' : '';

                optionsHtml += '<label class="mda">' +
                    '<input type="radio" name="q' + item.id + '" ' + checkedAttr + '> ' + escapeHTML(trimmedOpt) +
                '</label><br><div style="height: 15px;"></div>';
            });

            questionDiv.innerHTML = 
                '<div class="question" style="width: 85%; margin-bottom: 10px">' +
                    '<p class="ques">' + escapeHTML(item.id + '. ' + item.question) + '</p>' +
                    optionsHtml +
                '</div>' +
                '<div class="btn-1">' +
                    '<button type="button" class="edit-btn" ' +
                        'data-id="' + item.id + '" ' +
                        'data-question="' + escapeHTML(item.question) + '" ' +
                        'data-optiontext="' + escapeHTML(item.optionText) + '" ' +
                        'data-correctoption="' + item.correctOption + '" ' +
                        'data-language="' + item.languageName + '" ' +
                        'style="background-color:rgba(0, 187, 25, 1); color: white;border-width: 0;font-weight: bold;">' +
                        'Edit' +
                    '</button>' +
                '</div>';

            mcqsWrapper.appendChild(questionDiv);

            // Attach event listener to Edit button with FIXED encoding
            const editButton = questionDiv.querySelector(".edit-btn");
            editButton.addEventListener("click", function () {
                // Enhanced encoding function to handle quotes and special characters
                const encodeMCQData = (mcq) => {
                    // Use base64 encoding to avoid any JSON issues
                    const encodeText = (text) => {
                        return btoa(unescape(encodeURIComponent(text)));
                    };
                    
                    return {
                        id: mcq.id,
                        question: encodeText(mcq.question),
                        optionText: encodeText(mcq.optionText),
                        correctOption: mcq.correctOption,
                        languageName: mcq.languageName,
                        encoded: true // Flag to indicate it's encoded
                    };
                };
                
                const mcqData = encodeMCQData({
                    id: this.dataset.id,
                    question: this.dataset.question,
                    optionText: this.dataset.optiontext,
                    correctOption: this.dataset.correctoption,
                    languageName: this.dataset.language
                });
                
                console.log("Storing MCQ data - full question length:", mcqData.question.length);
                console.log("Encoded question preview:", mcqData.question.substring(0, 100) + "...");
                
                try {
                    sessionStorage.setItem("mcqToEdit", JSON.stringify(mcqData));
                    window.location.href = "updateMcq";
                } catch (error) {
                    console.error("Error storing in sessionStorage:", error);
                    // Fallback: Simple quote replacement
                    const fallbackData = {
                        id: this.dataset.id,
                        question: this.dataset.question.replace(/"/g, '&quot;'),
                        optionText: this.dataset.optiontext,
                        correctOption: this.dataset.correctoption,
                        languageName: this.dataset.language
                    };
                    sessionStorage.setItem("mcqToEdit", JSON.stringify(fallbackData));
                    window.location.href = "updateMcq";
                }
            });
        });

        questionItems = mcqsWrapper.querySelectorAll('.question-item');
    }

    function updatePagination() {
        const totalItems = mcqData.length;
        const totalPages = Math.ceil(totalItems / itemsPerPage);
        window.totalPages = totalPages;

        paginationContainer.innerHTML = '';
        if (totalPages <= 1) return;

        for (let i = 0; i < totalPages; i++) {
            const button = document.createElement('button');
            button.textContent = i + 1;
            button.classList.add('pagination-button');
            button.id = 'page-btn-' + i;
            button.addEventListener('click', () => displayPage(i));
            paginationContainer.appendChild(button);
        }
    }

    function displayPage(page) {
        const totalItems = mcqData.length;
        const startIndex = page * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;

        mcqsWrapper.style.display = 'block';
        codingWrapper.style.display = 'none';
        emptyMessage.style.display = 'none';
        paginationContainer.style.display = mcqData.length > itemsPerPage ? 'flex' : 'none';

        questionItems.forEach(item => item.style.display = 'none');

        for (let i = startIndex; i < endIndex && i < totalItems; i++) {
            questionItems[i].style.display = 'flex';
        }

        document.querySelectorAll('.pagination-button').forEach(btn => btn.classList.remove('active'));
        const activeButton = document.getElementById('page-btn-' + page);
        if (activeButton) activeButton.classList.add('active');
    }

    function showCodingQuestions() {
        mcqsWrapper.style.display = 'none';
        paginationContainer.style.display = 'none';

        const hasCodingQuestions = codingWrapper.children.length > 0;

        if (hasCodingQuestions) {
            codingWrapper.style.display = 'block';
            emptyMessage.style.display = 'none';
        } else {
            codingWrapper.style.display = 'none';
            emptyMessage.style.display = 'block';
        }
    }

    // Function to create test case HTML - using string concatenation
    function createTestCaseHTML(testCaseNumber, input, output) {
        return '<div class="test-case">' +
               '<div class="test-case-header">' +
               '<span class="test-case-number">Example ' + testCaseNumber + '</span>' +
               '</div>' +
               '<div class="test-case-content">' +
               '<div class="input-line">' +
               '<span class="input-label">Input:</span> ' +
               '<pre>' + input + '</pre>' +
               '</div>' +
               '<div class="output-line">' +
               '<span class="output-label">Output:</span> ' +
               '<pre>' + output + '</pre>' +
               '</div>' +
               '</div>' +
               '</div>';
    }

    // Helper function to parse stored array format [value1;value2;value3]
    function parseStoredArray(storedValue) {
        if (!storedValue || storedValue === '' || 
            !storedValue.startsWith('[') || !storedValue.endsWith(']')) {
            return [];
        }
        
        const content = storedValue.substring(1, storedValue.length - 1);
        if (content === '') {
            return [];
        }
        
        return content.split(';');
    }

    // --- EVENT LISTENERS ---
    mcqsButton.addEventListener('click', () => {
        displayPage(0);
        mcqsButton.classList.add('active');
        codingButton.classList.remove('active');
    });

    codingButton.addEventListener('click', () => {
        const selectedLanguage = languageSelect.value || 'Java';
        //console.log("Loading coding questions for:", selectedLanguage);
        
        loadCodingQuestions(selectedLanguage);
        showCodingQuestions();
        codingButton.classList.add('active');
        mcqsButton.classList.remove('active');
    });
    
    function loadCodingQuestions(language = 'Java') {
        if (!language) return;
        //console.log("Fetching coding questions for:", language);

        const url = "<%=request.getContextPath()%>/student/getQuestions?languageName=" + language;

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error(`Failed to fetch coding questions: ${response.status}`);
                return response.json();
            })
            .then(data => {
                //console.log("Fetched coding questions:", data);
                codingWrapper.innerHTML = '';

                if (!data || data.length === 0) {
                    codingWrapper.style.display = 'none';
                    emptyMessage.style.display = 'block';
                    emptyMessage.textContent = 'No coding questions found for this Language';
                    return;
                }

                emptyMessage.style.display = 'none';
                codingWrapper.style.display = 'block';

                data.forEach(item => {
                    const codingDiv = document.createElement('div');
                    codingDiv.className = 'coding-question';
                    
                    // Parse the stored string format [value1;value2;value3] into arrays
                    const easyInputs = parseStoredArray(item.easyInput);
                    const easyOutputs = parseStoredArray(item.easyExpectedOutput);
                    const mediumInputs = parseStoredArray(item.mediumInput);
                    const mediumOutputs = parseStoredArray(item.mediumExpectedOutput);
                    const hardInputs = parseStoredArray(item.hardInput);
                    const hardOutputs = parseStoredArray(item.hardExpectedOutput);
                    
                    //console.log("Parsed easy inputs:", easyInputs);
                    //console.log("Parsed easy outputs:", easyOutputs);
                    //console.log("Parsed medium inputs:", mediumInputs);
                    //console.log("Parsed medium outputs:", mediumOutputs);
                    //console.log("Parsed hard inputs:", hardInputs);
                    //console.log("Parsed hard outputs:", hardOutputs);
                    
                    // Build HTML for each difficulty level
                    let easySection = '';
                    let mediumSection = '';
                    let hardSection = '';
                    
                    // Easy Question Section
                    easySection = 
                        '<div class="question-section">' +
                        '<h1 class="easy">Easy Level</h1>' +
                        '<div class="question-content">' +
                        '<strong>Question:</strong><br>' +
                        '<p class="ques">' + (item.easyQuestion || 'No Easy Question Available') + '</p>' +
                        '</div>';
                    
                    // Add Easy test cases
                    if (easyInputs.length > 0 && easyOutputs.length > 0) {
                        //console.log("Creating easy test cases...");
                        for (let i = 0; i < easyInputs.length; i++) {
                            if (easyInputs[i] && easyOutputs[i]) {
                                const testCaseHTML = createTestCaseHTML(
                                    i + 1, 
                                    easyInputs[i], 
                                    easyOutputs[i]
                                );
                                //console.log("Easy test case " + (i+1) + " HTML:", testCaseHTML);
                                easySection += testCaseHTML;
                            }
                        }
                    } else {
                        easySection += '<div class="no-test-cases">No test cases available</div>';
                    }
                    easySection += '</div>';
                    
                    // Medium Question Section
                    mediumSection = 
                        '<div class="question-section">' +
                        '<h1 class="medium">Medium Level</h1>' +
                        '<div class="question-content">' +
                        '<strong>Question:</strong><br>' +
                        '<p class="ques">' + (item.mediumQuestion || 'No Medium Question Available') + '</p>' +
                        '</div>';
                    
                    // Add Medium test cases
                    if (mediumInputs.length > 0 && mediumOutputs.length > 0) {
                        //console.log("Creating medium test cases...");
                        for (let i = 0; i < mediumInputs.length; i++) {
                            if (mediumInputs[i] && mediumOutputs[i]) {
                                const testCaseHTML = createTestCaseHTML(
                                    i + 1, 
                                    mediumInputs[i], 
                                    mediumOutputs[i]
                                );
                                //console.log("Medium test case " + (i+1) + " HTML:", testCaseHTML);
                                mediumSection += testCaseHTML;
                            }
                        }
                    } else {
                        mediumSection += '<div class="no-test-cases">No test cases available</div>';
                    }
                    mediumSection += '</div>';
                    
                    // Hard Question Section
                    hardSection = 
                        '<div class="question-section">' +
                        '<h1 class="hard">Hard Level</h1>' +
                        '<div class="question-content">' +
                        '<strong>Question:</strong><br>' +
                        '<p class="ques">' + (item.hardQuestion || 'No Hard Question Available') + '</p>' +
                        '</div>';
                    
                    // Add Hard test cases
                    if (hardInputs.length > 0 && hardOutputs.length > 0) {
                        //console.log("Creating hard test cases...");
                        for (let i = 0; i < hardInputs.length; i++) {
                            if (hardInputs[i] && hardOutputs[i]) {
                                const testCaseHTML = createTestCaseHTML(
                                    i + 1, 
                                    hardInputs[i], 
                                    hardOutputs[i]
                                );
                                //console.log("Hard test case " + (i+1) + " HTML:", testCaseHTML);
                                hardSection += testCaseHTML;
                            }
                        }
                    } else {
                        hardSection += '<div class="no-test-cases">No test cases available</div>';
                    }
                    hardSection += '</div>';
                    
                    const finalHTML = easySection + mediumSection + hardSection +
                        '<div class="edit-btn-container">' +
                        '<button ' +
                        'type="button"' +
                        'class="edit-coding-btn"' +
                        'data-id="' + item.id + '"' +
                        'data-language="' + item.languageName + '"' +
                        'data-easy="' + (item.easyQuestion || '') + '"' +
                        'data-medium="' + (item.mediumQuestion || '') + '"' +
                        'data-hard="' + (item.hardQuestion || '') + '"' +
                        'data-easy-input="' + (item.easyInput || '') + '"' +
                        'data-easy-output="' + (item.easyExpectedOutput || '') + '"' +
                        'data-medium-input="' + (item.mediumInput || '') + '"' +
                        'data-medium-output="' + (item.mediumExpectedOutput || '') + '"' +
                        'data-hard-input="' + (item.hardInput || '') + '"' +
                        'data-hard-output="' + (item.hardExpectedOutput || '') + '"' +
                        'style="background-color:rgba(0, 187, 25, 1); color: white; border: none; font-weight: bold; padding: 10px 20px; border-radius: 5px; cursor: pointer;">' +
                        'Edit All Questions' +
                        '</button>' +
                        '</div>';
                    
                    //console.log("Final HTML for coding question:", finalHTML);
                    codingDiv.innerHTML = finalHTML;
                    codingWrapper.appendChild(codingDiv);
                });

                // Attach edit button click handlers
                const editButtons = codingWrapper.querySelectorAll('.edit-coding-btn');
                editButtons.forEach(btn => {
                    btn.addEventListener('click', function() {
                        const codingData = {
                            id: this.dataset.id,
                            languageName: this.dataset.language,
                            easyQuestion: this.dataset.easy,
                            mediumQuestion: this.dataset.medium,
                            hardQuestion: this.dataset.hard,
                            easyInput: this.dataset.easyInput,
                            easyExpectedOutput: this.dataset.easyOutput,
                            mediumInput: this.dataset.mediumInput,
                            mediumExpectedOutput: this.dataset.mediumOutput,
                            hardInput: this.dataset.hardInput,
                            hardExpectedOutput: this.dataset.hardOutput
                        };
                        //console.log("Editing coding question with all data:", codingData);
                        sessionStorage.setItem("codingToEdit", JSON.stringify(codingData));
                        window.location.href = "updateCoding";
                    });
                });
            })
            .catch(error => {
                console.error('Error fetching coding questions:', error);
                codingWrapper.innerHTML = '<p style="color:red;text-align:center;">Error loading coding questions.</p>';
            });
    }

    languageSelect.addEventListener("change", function() {
        const selectedLanguage = languageSelect.value;
        //console.log("Selected language:", selectedLanguage);
        loadMCQs(selectedLanguage);
    });

    // --- INITIALIZATION ---
    loadMCQs('Java');  // Load Java MCQs initially
    mcqsButton.classList.add('active');

    // Load languages into <select>
    fetch("<%=request.getContextPath()%>/student/getLanguage")
        .then(res => res.json())
        .then(data => {
            data.forEach(item => {
                const opt = document.createElement("option");
                opt.value = item.languageName;
                opt.textContent = item.languageName;
                languageSelect.appendChild(opt);
            });
        })
        .catch(err => console.error("Error fetching languages:", err));
});
</script>
</body>
</html>