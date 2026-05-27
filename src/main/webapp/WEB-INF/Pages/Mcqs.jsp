<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add MCQs</title>
  <style>
    body {
      font-family: "Roboto", sans-serif;
    }
    .add-header {
      margin-left: 18%;
    }
    .h1 {
      font-size: 22px;
      font-weight: bold;
    }
    .ques {
      font-weight: bold;
    }
    .question-box {
      width: 65%;
      height: 150px;
      box-shadow: 1px 1px 10px 0px #00000040;
      border: none;
      border-radius: 5px;
      margin-top: 10px;
      padding: 15px;
      font-size: 16px;
      resize: none;
      outline: none;
      box-sizing: border-box;
    }
    .side {
      display: flex;
      flex-direction: row;
      justify-content: space-between;
      align-items: center;
      width: 65%;
    }
    .op {
      font-weight: bold;
    }
    .add-q {
      background: #2176bb;
      color: #fff;
      border: none;
      padding: 7px 14px;
      border-radius: 5px;
      font-size: 13px;
      font-weight: bold;
      cursor: pointer;
    }
    .option-container {
      margin-top: 10px;
      width: 65%;
    }
    .option-box {
      width: 100%;
      padding-top: 15px;
      padding-bottom: 15px;
      margin-bottom: 12px;
      box-shadow: 1px 1px 10px 0px #00000040;
      border: none;
      border-radius: 5px;
      font-size: 14px;
      outline: none;
      box-sizing: border-box;
      padding-left: 10px;
    }
    .save-btn {
      background: #28a745;
      color: white;
      font-weight: bold;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      width: fit-content;
      padding: 10px;
    }
    .save {
      width: 65%;
      display: flex;
      justify-content: end;
      margin-top: 10px;
    }
    .dropdown {
      width: 65%;
      display: flex;
      justify-content: end;
      margin-top: 10px;
    }
    .select {
      padding-top: 7px;
      padding-bottom: 7px;
      outline: none;
      width: 200px;
    }
  </style>
</head>
<body>
  <div class="main-box">
    <div class="add-header">
      <h1 class="h1">Add MCQ'S</h1>
    </div>

    <form id="mcqform" action="saveMcq" method="post">
      <div class="dropdown">
        <select id="languageName" name="languageName" required class="select">
          <option value="" disabled selected>Select Coding Language</option>
        </select>
      </div>
      <div class="hh">
        <p class="ques">Question 1</p>
        <textarea class="question-box" name="question" placeholder="Enter Your Question" required></textarea>
      </div>

      <div class="side">
        <div class="s1">
          <p class="op">Options</p>
        </div>
        <div class="s2">
          <button type="button" class="add-q" id="add-option-btn">+Add Option</button>
        </div>
      </div>

      <div class="option-container" id="options-container">
        <!-- Default 4 options -->
        <input type="text" name="optionText" placeholder="Enter Your Option" class="option-box" required data-label="a.">
        <input type="text" name="optionText" placeholder="Enter Your Option" class="option-box" required data-label="b.">
        <input type="text" name="optionText" placeholder="Enter Your Option" class="option-box" required data-label="c.">
        <input type="text" name="optionText" placeholder="Enter Your Option" class="option-box" required data-label="d.">
      </div>

      <div class="dropdown">
        <select id="correctOption" name="correctOption" required class="select">
          <option value="" disabled selected>Select Correct Option</option>
          <option value="a">a</option>
          <option value="b">b</option>
          <option value="c">c</option>
          <option value="d">d</option>
        </select>
      </div>

      <div class="save">
        <button type="submit" class="save-btn">Save Question</button>
      </div>
    </form>
  </div>

  <!--<script>
    document.addEventListener('DOMContentLoaded', () => {
      const addOptionBtn = document.getElementById('add-option-btn');
      const optionsContainer = document.getElementById('options-container');
      const correctOptionSelect = document.getElementById('correctOption');
      const form = document.getElementById('mcqform');

      // Fetch languages
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

      // Update correctOption dropdown based on number of options
      function updateCorrectOptions() {
        const optionCount = optionsContainer.getElementsByTagName('input').length;
        correctOptionSelect.innerHTML = '<option value="" disabled selected>Select Correct Option</option>';
        for (let i = 0; i < optionCount; i++) {
          const label = String.fromCharCode(97 + i); // a, b, c...
          const option = document.createElement('option');
          option.value = label;
          option.textContent = label;
          correctOptionSelect.appendChild(option);
        }
      }

      // Initialize dropdown
      updateCorrectOptions();

      // Add new option (max 6)
      addOptionBtn.addEventListener('click', () => {
        const currentCount = optionsContainer.getElementsByTagName('input').length;
        if (currentCount >= 6) {
          alert("Maximum 6 options allowed");
          return;
        }

        const newInput = document.createElement('input');
        newInput.type = 'text';
        newInput.name = 'optionText';
        newInput.placeholder = 'Enter Your Option';
        newInput.classList.add('option-box');
        newInput.required = true;
        newInput.setAttribute('data-label', String.fromCharCode(97 + currentCount) + '.');
        optionsContainer.appendChild(newInput);
        updateCorrectOptions();
      });

      // Handle form submission - FIXED: Send options as JSON to avoid comma issues
      form.addEventListener('submit', (e) => {
        // Remove any old hidden field
        const oldJson = form.querySelector('input[name="optionsJson"]');
        if (oldJson) oldJson.remove();

        const optionInputs = document.querySelectorAll('input[name="optionText"].option-box');

        // Collect only non-empty option texts
        const optionValues = Array.from(optionInputs)
          .map(input => input.value.trim())
          .filter(val => val !== "");

        // Create hidden field with JSON array - This solves comma problem completely
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'optionsJson';           // NEW FIELD NAME
        hiddenInput.value = JSON.stringify(optionValues);
        form.appendChild(hiddenInput);

        // Optional: Show what is being sent
        console.log("Sending options as JSON:", hiddenInput.value);

        const confirmation = confirm("Do you want to post the data?");
        if (!confirmation) {
          e.preventDefault();
        }
      });
    });
  </script>-->
  
  <script>
    	    document.addEventListener('DOMContentLoaded', () => {
    	      const addOptionBtn = document.getElementById('add-option-btn');
    	      const optionsContainer = document.getElementById('options-container');
    	      const correctOptionSelect = document.getElementById('correctOption');
    	      const form = document.getElementById('mcqform');
    	      const languageSelect = document.getElementById("languageName");
    	      const saveBtn = document.querySelector('.save-btn');
   
    	      // Fetch languages
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
   
    	      // Function to disable/enable form fields
    	      function toggleFormFields(disable) {
    	        const questionBox = document.querySelector('.question-box');
    	        const optionInputs = document.querySelectorAll('.option-box');
    	        
    	        questionBox.disabled = disable;
    	        optionInputs.forEach(input => input.disabled = disable);
    	        addOptionBtn.disabled = disable;
    	        correctOptionSelect.disabled = disable;
    	        saveBtn.disabled = disable;
    	        
    	        // Visual feedback
    	        if (disable) {
    	          saveBtn.style.background = '#cccccc';
    	          saveBtn.style.cursor = 'not-allowed';
    	        } else {
    	          saveBtn.style.background = '#28a745';
    	          saveBtn.style.cursor = 'pointer';
    	        }
    	      }
   
    	      // Check MCQ limit when language is selected
    	      languageSelect.addEventListener('change', () => {
    	        const selectedLanguage = languageSelect.value;
    	        
    	        if (!selectedLanguage) {
    	          toggleFormFields(true);
    	          return;
    	        }
   
    	        console.log("Selected language:", selectedLanguage); // Debug log
   
    	        // Call the checkMcqLimit endpoint
    	        fetch("<%=request.getContextPath()%>/student/checkMcqLimit?languageName=" + encodeURIComponent(selectedLanguage))
    	          .then(res => {
    	            if (!res.ok) {
    	              throw new Error(`HTTP error! status: ${res.status}`);
    	            }
    	            return res.json();
    	          })
    	          .then(data => {
    	            console.log("Response data:", data); // Debug log
    	            
    	            if (data.error) {
    	              alert(`Error: ${data.error}`);
    	              toggleFormFields(true);
    	              return;
    	            }
   
    	            if (data.limitReached) {
    	              alert(`MCQ Limit Reached! You cannot add more MCQs.`);
    	              toggleFormFields(true);
    	            } else {
    	              // Enable form if limit not reached
    	              toggleFormFields(false);
    	              console.log(`MCQs available for ${data.languageName || selectedLanguage}: ${data.currentCount}/${data.totalAllowed}`);
    	            }
    	          })
    	          .catch(err => {
    	            console.error("Error checking MCQ limit:", err);
    	            alert("Failed to check MCQ limit. Please try again.");
    	            toggleFormFields(true);
    	          });
    	      });
   
    	      // Update correctOption dropdown based on number of options
    	      function updateCorrectOptions() {
    	        const optionCount = optionsContainer.getElementsByTagName('input').length;
    	        correctOptionSelect.innerHTML = '<option value="" disabled selected>Select Correct Option</option>';
    	        for (let i = 0; i < optionCount; i++) {
    	          const label = String.fromCharCode(97 + i); // a, b, c...
    	          const option = document.createElement('option');
    	          option.value = label;
    	          option.textContent = label;
    	          correctOptionSelect.appendChild(option);
    	        }
    	      }
   
    	      // Initialize dropdown and disable form initially
    	      updateCorrectOptions();
    	      toggleFormFields(true); // Disable until language is selected
   
    	      // Add new option (max 6)
    	      addOptionBtn.addEventListener('click', () => {
    	        const currentCount = optionsContainer.getElementsByTagName('input').length;
    	        if (currentCount >= 6) {
    	          alert("Maximum 6 options allowed");
    	          return;
    	        }
   
    	        const newInput = document.createElement('input');
    	        newInput.type = 'text';
    	        newInput.name = 'optionText';
    	        newInput.placeholder = 'Enter Your Option';
    	        newInput.classList.add('option-box');
    	        newInput.required = true;
    	        newInput.setAttribute('data-label', String.fromCharCode(97 + currentCount) + '.');
    	        optionsContainer.appendChild(newInput);
    	        updateCorrectOptions();
    	      });
   
    	      // Handle form submission
    	      form.addEventListener('submit', (e) => {
    	        // Check if form is disabled (limit reached)
    	        if (saveBtn.disabled) {
    	          e.preventDefault();
    	          alert("Cannot submit! MCQ limit has been reached for this language.");
    	          return;
    	        }
   
    	        // Remove any old hidden field
    	        const oldJson = form.querySelector('input[name="optionsJson"]');
    	        if (oldJson) oldJson.remove();
   
    	        const optionInputs = document.querySelectorAll('input[name="optionText"].option-box');
   
    	        // Collect only non-empty option texts
    	        const optionValues = Array.from(optionInputs)
    	          .map(input => input.value.trim())
    	          .filter(val => val !== "");
   
    	        // Create hidden field with JSON array
    	        const hiddenInput = document.createElement('input');
    	        hiddenInput.type = 'hidden';
    	        hiddenInput.name = 'optionsJson';
    	        hiddenInput.value = JSON.stringify(optionValues);
    	        form.appendChild(hiddenInput);
   
    	        console.log("Sending options as JSON:", hiddenInput.value);
   
    	        const confirmation = confirm("Do you want to post the data?");
    	        if (!confirmation) {
    	          e.preventDefault();
    	        }
    	      });
    	    });
    	  </script>
  
</body>
</html>