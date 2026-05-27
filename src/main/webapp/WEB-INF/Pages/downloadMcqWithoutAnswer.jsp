<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MCQ Questions Overview</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap');

  .main-box {
      display: flex;
      flex-direction: row;
      width: 95%;
      justify-content: end;
      padding-left: 5%;
      padding-right: 5%;
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

  button {
      padding: 10px 12px;
      font-size: 80%;
  }

  .main-container {
      position: relative;
  }

  .ques {
      font-family: "Roboto", sans-serif;
      font-weight: bold;
	  white-space: pre-wrap;
  }

  .questions {
      display: flex;
      flex-direction: row;
      gap: 5%;
  }

  .mda {
      padding: 1%;
  }

  .mcq {
      background-color: rgba(47, 173, 228, 1);
      color: rgba(255, 255, 255, 1);
      border-width: 0;
      font-weight: bold;
  }
</style>
</head>
<body>
<div class="main-container">
    <div class="main-box">
        <button id="downloadBtn" style="color: white; background-color: #FD3B3B; padding: 9px 21px; border-radius: 10px; border: none; cursor: pointer">
            Download
        </button>
    </div>

    <!-- Language Selection -->
    <form action="mcq" method="get">
        <div style="width: 80%; display: flex; justify-content: end; margin-bottom: 10px">
            <select id="languageName" name="languageName" required class="select" style="padding-top: 7px; padding-bottom: 7px; outline: none;">
                <option value="" disabled selected>Select Coding Language</option>
            </select>
        </div>

        <div id="all-questions-wrapper" style="width: 73%; margin: auto">
            <!-- MCQs populated dynamically -->
        </div>
    </form>
</div>

<!-- jsPDF CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const mcqsWrapper = document.getElementById('all-questions-wrapper');
    const languageSelect = document.getElementById("languageName");
    const downloadBtn = document.getElementById("downloadBtn");

    function loadMCQs(language = 'Java') {
        if (!language) return;
        //const url = "http://localhost:4049/student/getMcqsByLanguage?languageName=" + language;
		const url = "<%=request.getContextPath()%>/student/getMcqsByLanguage?languageName=" + language;

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error(`Failed to fetch MCQs: ${response.status}`);
                return response.json();
            })
            .then(data => {
                populateMCQs(data);
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
            questionDiv.style.marginBottom = "25px";

            let optionsHtml = '';
            //const options = item.optionText.split(', ');
			const options = item.optionText.split(/,\s*(?=[a-z]\.)/);
            options.forEach(opt => {
                const trimmedOpt = opt.trim();
				const escapedOpt = escapeHTML(trimmedOpt);
                const isCorrect = trimmedOpt.startsWith(`${item.correctOption}.`);
                const checkedAttr = isCorrect ? 'checked' : '';

                optionsHtml += `
                    <label class="mda">
                        <input type="radio" name="q\${item.id}" \${checkedAttr} disabled> \${escapedOpt}
                    </label><br><div style="height: 10px;"></div>`;
            });

            questionDiv.innerHTML = `
                <div class="question" style="width: 85%; margin-bottom: 10px">
                    <p class="ques">\${item.id}. \${item.question}</p>
                    \${optionsHtml}
                </div>
            `;

            mcqsWrapper.appendChild(questionDiv);
        });
    }

    // Handle language change
    languageSelect.addEventListener("change", function() {
        const selectedLanguage = languageSelect.value;
        loadMCQs(selectedLanguage);
    });

    // --- INITIALIZATION ---
    loadMCQs('Java');  // Load Java MCQs initially

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

    // --- PDF DOWNLOAD ---
	downloadBtn.addEventListener("click", async () => {
		    const { jsPDF } = window.jspdf;
		    const doc = new jsPDF();

		    const questions = mcqsWrapper.querySelectorAll(".question");
		    if (questions.length === 0) {
		        alert("No questions available to download!");
		        return;
		    }

		    let y = 15;

		    // ✅ Load logo
		    const logoUrl = "<%=request.getContextPath()%>/images/logo.png";
		    const logoImg = await fetch(logoUrl)
		        .then(res => res.blob())
		        .then(blob => {
		            return new Promise((resolve) => {
		                const reader = new FileReader();
		                reader.onload = () => resolve(reader.result);
		                reader.readAsDataURL(blob);
		            });
		        })
		        .catch(() => null);

		    // ✅ Add logo
		    if (logoImg) {
		        doc.addImage(logoImg, "PNG", 80, 5, 50, 20);
		        y = 30;
		    }

		    const lang = languageSelect.value || 'Exam';
		    doc.setFont("helvetica", "bold");
		    doc.text(`${lang} Exam Questions`, 10, y);
		    y += 10;

		    // ✅ Add questions and options
		    questions.forEach(q => {
		        const qText = q.querySelector(".ques").innerText;
		        doc.setFont("helvetica", "bold");
		        //doc.text(qText, 10, y);
		        //y += 7;
				
				
				
				const splitQuestion = doc.splitTextToSize(qText, 180);
							            doc.text(splitQuestion, 10, y);
							            y += splitQuestion.length * 7;

		        const opts = q.querySelectorAll("label");
		        doc.setFont("helvetica", "normal");
		        opts.forEach(opt => {
		            const text = " " + opt.innerText; // No correct answer
		            //doc.text(text, 15, y);
		            //y += 6;
					
					
					
					const splitOption = doc.splitTextToSize(text, 170);
									                doc.text(splitOption, 15, y);
									                y += splitOption.length * 6;
		        });

		        y += 5;

		        if (y > 270) {
		            doc.addPage();
		            y = 20;
		        }
		    });

		    const fileName = `MCQ Questions.pdf`;
		    doc.save(fileName);
		});
});
</script>
</body>
</html>
