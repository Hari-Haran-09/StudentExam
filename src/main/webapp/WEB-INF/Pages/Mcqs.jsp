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
<!--        <div class="s2">
          <button type="button" class="add-q" id="add-option-btn">+Add Option</button>
        </div>-->
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

  <script>
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
          const label = String.fromCharCode(97 + i);
          const option = document.createElement('option');
          option.value = label;
          option.textContent = label;
          correctOptionSelect.appendChild(option);
        }
      }

      // Initialize dropdown
      updateCorrectOptions();

      // Add new option
      addOptionBtn.addEventListener('click', () => {
        const currentCount = optionsContainer.getElementsByTagName('input').length;
        
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
        // Prevent multiple hidden inputs
        const existingHiddenInput = form.querySelector('input[name="optionText"][type="hidden"]');
        if (existingHiddenInput) {
          existingHiddenInput.remove();
        }

        // Remove name attributes from individual option inputs
        const optionInputs = document.querySelectorAll('input[name="optionText"].option-box');
        optionInputs.forEach(input => input.removeAttribute('name'));

        // Collect and format options
        const options = Array.from(optionInputs)
          .map((input, index) => {
            const value = input.value.trim();
            if (value) {
              const label = String.fromCharCode(97 + index) + '.';
              return `${label} ${value}`;
            }
            return null;
          })
          .filter(option => option !== null);

        

        const optionText = options.join(', ');
        console.log("Submitting optionText: " + optionText);

        // Create hidden input for formatted optionText
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'optionText';
        hiddenInput.value = optionText;
        form.appendChild(hiddenInput);

        // Confirm submission
        const confirmation = confirm("Do you want to post the data?");
        if (!confirmation) {
          e.preventDefault();
        }

        // Restore name attributes
        optionInputs.forEach(input => input.name = 'optionText');
      });
    });
  </script>
</body>
</html>