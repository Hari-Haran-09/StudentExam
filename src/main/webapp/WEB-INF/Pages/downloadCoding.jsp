<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Coding Questions Overview</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap');

  body {
      font-family: "Roboto", sans-serif;
      background-color: #f9f9f9;
  }

  .main-box {
      display: flex;
      flex-direction: row;
      justify-content: end;
      padding: 1%;
      width: 95%;
      margin: auto;
      align-items: center;
  }

  button {
      padding: 10px 12px;
      font-size: 80%;
      cursor: pointer;
      margin-left: 10px;
  }

  .main-container {
      position: relative;
  }

  .coding-question {
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      margin-bottom: 20px;
      padding: 15px;
  }

  .easy, .medium, .hard {
      font-size: 140%;
      margin-bottom: 10px;
  }

  .question-section {
      margin-bottom: 20px;
  }

  .test-case {
      background: #f3f3f3;
      padding: 10px;
      margin: 8px 0;
      border-radius: 6px;
  }

  .test-case strong {
      display: block;
      color: #333;
      margin-bottom: 5px;
  }

  .no-test-cases {
      font-style: italic;
      color: gray;
  }
</style>
</head>
<body>
<div class="main-container">
    <div class="main-box">
        <button id="download-btn" style="color: white; background-color: #FD3B3B; padding: 9px 21px; border-radius: 10px; border: none; cursor: pointer">
            Download
        </button>
    </div>

    <!-- Language Selection -->
    <div style="width: 80%; display: flex; justify-content: end; margin-bottom: 10px">
        <select id="languageName" name="languageName" required style="padding: 7px; outline: none;">
            <option value="" disabled selected>Select Coding Language</option>
        </select>
    </div>

    <!-- Coding Questions -->
    <div id="all-coding-questions-wrapper"></div>

    <p id="empty-message" style="width: 80%; display: none; padding: 20px; text-align: center; font-style: italic;">
        No coding questions found. Click "Add Coding Questions" to create one.
    </p>
</div>

<!-- Include jsPDF -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const codingWrapper = document.getElementById('all-coding-questions-wrapper');
    const emptyMessage = document.getElementById('empty-message');
    const languageSelect = document.getElementById("languageName");
    const downloadBtn = document.getElementById("download-btn");

    // Utility to parse stored array strings like "[val1;val2;val3]"
    function parseStoredArray(str) {
        if (!str) return [];
        return str.replace(/[\[\]]/g, '').split(';').map(s => s.trim()).filter(Boolean);
    }

    // Utility to create formatted test case HTML
    function createTestCaseHTML(index, input, output) {
        return `
            <div class="test-case">
                <strong>Test Case \${index}:</strong>
                <div><b>Input:</b> \${input}</div>
                <div><b>Expected Output:</b> \${output}</div>
            </div>
        `;
    }

    function loadCodingQuestions(language = 'Java') {
        if (!language) return;

        const url = "<%=request.getContextPath()%>/student/getQuestions?languageName=" + language;

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error('Failed to fetch coding questions');
                return response.json();
            })
            .then(data => {
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

                    // Parse arrays
                    const easyInputs = parseStoredArray(item.easyInput);
                    const easyOutputs = parseStoredArray(item.easyExpectedOutput);
                    const mediumInputs = parseStoredArray(item.mediumInput);
                    const mediumOutputs = parseStoredArray(item.mediumExpectedOutput);
                    const hardInputs = parseStoredArray(item.hardInput);
                    const hardOutputs = parseStoredArray(item.hardExpectedOutput);

                    // Build question sections
                    let easySection = `
                        <div class="question-section">
                            <h1 class="easy">Easy Level</h1>
                            <div><strong>Question:</strong><p class="ques">\${item.easyQuestion || 'No Easy Question Available'}</p></div>
                    `;
                    if (easyInputs.length > 0 && easyOutputs.length > 0) {
                        for (let i = 0; i < easyInputs.length; i++) {
                            if (easyInputs[i] && easyOutputs[i]) {
                                easySection += createTestCaseHTML(i + 1, easyInputs[i], easyOutputs[i]);
                            }
                        }
                    } else {
                        easySection += '<div class="no-test-cases">No test cases available</div>';
                    }
                    easySection += '</div>';

                    let mediumSection = `
                        <div class="question-section">
                            <h1 class="medium">Medium Level</h1>
                            <div><strong>Question:</strong><p class="ques">\${item.mediumQuestion || 'No Medium Question Available'}</p></div>
                    `;
                    if (mediumInputs.length > 0 && mediumOutputs.length > 0) {
                        for (let i = 0; i < mediumInputs.length; i++) {
                            if (mediumInputs[i] && mediumOutputs[i]) {
                                mediumSection += createTestCaseHTML(i + 1, mediumInputs[i], mediumOutputs[i]);
                            }
                        }
                    } else {
                        mediumSection += '<div class="no-test-cases">No test cases available</div>';
                    }
                    mediumSection += '</div>';

                    let hardSection = `
                        <div class="question-section">
                            <h1 class="hard">Hard Level</h1>
                            <div><strong>Question:</strong><p class="ques">\${item.hardQuestion || 'No Hard Question Available'}</p></div>
                    `;
                    if (hardInputs.length > 0 && hardOutputs.length > 0) {
                        for (let i = 0; i < hardInputs.length; i++) {
                            if (hardInputs[i] && hardOutputs[i]) {
                                hardSection += createTestCaseHTML(i + 1, hardInputs[i], hardOutputs[i]);
                            }
                        }
                    } else {
                        hardSection += '<div class="no-test-cases">No test cases available</div>';
                    }
                    hardSection += '</div>';

                    codingDiv.innerHTML = easySection + mediumSection + hardSection;
                    codingWrapper.appendChild(codingDiv);
                });
            })
            .catch(error => {
                console.error('Error fetching coding questions:', error);
                codingWrapper.innerHTML = '<p style="color:red;text-align:center;">Error loading coding questions.</p>';
            });
    }

    // --- Download PDF ---
	downloadBtn.addEventListener("click", function() {
	        const { jsPDF } = window.jspdf;
	        const doc = new jsPDF();
	        let y = 10;

	        const codingDivs = codingWrapper.querySelectorAll(".coding-question");
	        if (codingDivs.length === 0) {
	            alert("No coding questions available to download.");
	            return;
	        }

	        codingDivs.forEach((div, index) => {
	            const easyQ = div.querySelector(".easy + div .ques")?.innerText || '';
	            const mediumQ = div.querySelector(".medium + div .ques")?.innerText || '';
	            const hardQ = div.querySelector(".hard + div .ques")?.innerText || '';

	            doc.setFontSize(12);
	            const wrapEasy = doc.splitTextToSize(`Easy Question: \${easyQ}`, 180);
	            doc.text(wrapEasy, 10, y); y += wrapEasy.length * 7;

	            const easyTests = div.querySelectorAll(".easy ~ .test-case");
	            easyTests.forEach((test, i) => {
	                const text = test.innerText;
	                const wrap = doc.splitTextToSize(text, 170);
	                doc.text(wrap, 15, y); y += wrap.length * 6;
	            });

	            const wrapMedium = doc.splitTextToSize(`Medium Question: \${mediumQ}`, 180);
	            doc.text(wrapMedium, 10, y); y += wrapMedium.length * 7;

	            const mediumTests = div.querySelectorAll(".medium ~ .test-case");
	            mediumTests.forEach((test, i) => {
	                const text = test.innerText;
	                const wrap = doc.splitTextToSize(text, 170);
	                doc.text(wrap, 15, y); y += wrap.length * 6;
	            });

	            const wrapHard = doc.splitTextToSize(`Hard Question: \${hardQ}`, 180);
	            doc.text(wrapHard, 10, y); y += wrapHard.length * 7;

	            const hardTests = div.querySelectorAll(".hard ~ .test-case");
	            hardTests.forEach((test, i) => {
	                const text = test.innerText;
	                const wrap = doc.splitTextToSize(text, 170);
	                doc.text(wrap, 15, y); y += wrap.length * 6;
	            });

	            y += 10;
	            if (y > 270) { doc.addPage(); y = 10; }
	        });

	        doc.save("Coding_Questions.pdf");
	    });

    // Load languages
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

    // Initial load
    loadCodingQuestions('Java');

    languageSelect.addEventListener("change", function() {
        loadCodingQuestions(languageSelect.value);
    });
});
</script>
</body>
</html>
