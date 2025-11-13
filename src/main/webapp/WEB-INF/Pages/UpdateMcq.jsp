<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update MCQs</title>
  <style>
    body { font-family: "Roboto", sans-serif; }
    .add-header { margin-left: 18%; }
    .h1 { font-size: 22px; font-weight: bold; }
    .ques { font-weight: bold; }
    .question-box {
      width: 65%; height: 150px; box-shadow: 1px 1px 10px 0px #00000040;
      border: none; border-radius: 5px; margin-top: 10px; padding: 15px;
      font-size: 16px; resize: none; outline: none; box-sizing: border-box;
    }
    .side { display: flex; justify-content: space-between; align-items: center; width: 65%; }
    .op { font-weight: bold; }
    .add-q { background: #2176bb; color: #fff; border: none; padding: 7px 14px;
      border-radius: 5px; font-size: 13px; font-weight: bold; cursor: pointer; }
    .option-container { margin-top: 10px; width: 65%; }
    .option-box {
      width: 100%; padding: 15px; margin-bottom: 12px; box-shadow: 1px 1px 10px 0px #00000040;
      border: none; border-radius: 5px; font-size: 14px; outline: none; box-sizing: border-box;
    }
    .save-btn { background: #28a745; color: white; font-weight: bold; border: none;
      border-radius: 5px; cursor: pointer; width: fit-content; padding: 10px; }
    .save { width: 65%; display: flex; justify-content: end; margin-top: 10px; }
    .dropdown { width: 65%; display: flex; justify-content: end; margin-top: 10px; }
    .select { padding: 7px; outline: none; width: 200px; }

    /* Fix for preserving multiline question display */
    .question-display {
      white-space: pre-wrap;
      font-size: 16px;
      line-height: 1.5;
      background-color: #f9f9f9;
      padding: 10px;
      border-radius: 5px;
      box-shadow: 1px 1px 8px #00000030;
      width: 65%;
      margin-top: 10px;
    }
  </style>
</head>
<body>
  <div class="main-box">
    <div class="add-header">
      <h1 class="h1">Update MCQ</h1>
    </div>

    <form id="mcqform" action="updateMcq" method="post">
      <input type="hidden" name="id" id="mcqId" />
      <div class="dropdown">
        <select id="languageName" name="languageName" required class="select">
          <option value="" disabled selected>Select Coding Language</option>
        </select>
      </div>

      <div class="hh">
        <p class="ques">Question</p>
        <textarea class="question-box" name="question" placeholder="Enter Your Question" required id="questionTextarea"></textarea>
      </div>

      <div class="side">
        <div><p class="op">Options</p></div>
        <!--<div><button type="button" class="add-q" id="add-option-btn">+Add Option</button></div>-->
      </div>

      <div class="option-container" id="options-container"></div>

      <div class="dropdown">
        <select id="correctOption" name="correctOption" required class="select">
          <option value="" disabled selected>Select Correct Option</option>
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
    const questionTextarea = document.getElementById('questionTextarea');

    // Fetch available languages
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
      });

    // --- ENHANCED AUTO-FILL MCQ DATA WHEN EDITING ---
    const storedData = sessionStorage.getItem("mcqToEdit");
    
    if (storedData) {
      try {
        const mcq = JSON.parse(storedData);
        
        // Handle encoded data
        const decodeText = (text, isEncoded) => {
          if (!isEncoded) {
            // If not encoded, handle simple quote replacement
            return text.replace(/&quot;/g, '"');
          }
          try {
            return decodeURIComponent(escape(atob(text)));
          } catch (e) {
            console.error("Decoding failed, returning as-is:", e);
            return text; // Return as-is if decoding fails
          }
        };
        
        const isEncoded = mcq.encoded || false;
        const decodedQuestion = decodeText(mcq.question, isEncoded);
        const decodedOptionText = decodeText(mcq.optionText, isEncoded);

        // Validate required fields
        if (!decodedQuestion || !decodedOptionText) {
          throw new Error("Missing required MCQ data after decoding");
        }

        const languageSelect = document.getElementById("languageName");

        // Set form values
        document.getElementById("mcqId").value = mcq.id || '';
        
        // Set question - handle newlines properly
        const questionValue = decodedQuestion.replace(/\\n/g, "\n");
        questionTextarea.value = questionValue;

        // Clear and rebuild options
        optionsContainer.innerHTML = "";
        correctOptionSelect.innerHTML = '<option value="" disabled selected>Select Correct Option</option>';

        // Parse options more robustly
        const options = decodedOptionText.split(',').map(opt => opt.trim()).filter(opt => opt);

        if (options.length === 0) {
          throw new Error("No valid options found");
        }

        // Create option inputs - KEEPING YOUR ORIGINAL CORRECT OPTION CODE
        options.forEach((opt, index) => {
          if (opt) {
            // Extract option value without the label (a., b., etc.)
            const optionValue = opt.replace(/^[a-z]\.\s*/i, '').trim();
            const label = String.fromCharCode(97 + index);
            
            const input = document.createElement("input");
            input.type = "text";
            input.name = "optionText";
            input.classList.add("option-box");
            input.placeholder = `Option ${label}`;
            input.required = true;
            input.value = optionValue;
            input.setAttribute("data-label", label);
            optionsContainer.appendChild(input);

            // Add to correct option dropdown - YOUR ORIGINAL CODE
            const optionElement = document.createElement("option");
            optionElement.value = String.fromCharCode(97 + index);
            optionElement.textContent = String.fromCharCode(97 + index);
            correctOptionSelect.appendChild(optionElement);
          }
        });

        // Set correct option - YOUR ORIGINAL CODE
        if (mcq.correctOption) {
          setTimeout(() => {
            const correctOption = mcq.correctOption.toLowerCase();
            correctOptionSelect.value = correctOption;
          }, 100);
        }

        // Set language
        if (mcq.languageName) {
          setTimeout(() => {
            languageSelect.value = mcq.languageName;
          }, 100);
        }

        // Clear session storage
        sessionStorage.removeItem("mcqToEdit");
        
      } catch (error) {
        console.error("Error loading MCQ data:", error);
        alert("Error loading question data: " + error.message);
      }
    }

    // --- Add new option dynamically ---
    addOptionBtn.addEventListener('click', () => {
      const count = optionsContainer.getElementsByTagName('input').length;
      if (count >= 4) {
        alert("You can only add up to 4 options.");
        return;
      }
      
      const label = String.fromCharCode(97 + count);
      const newInput = document.createElement('input');
      newInput.type = 'text';
      newInput.name = 'optionText';
      newInput.placeholder = `Option ${label}`;
      newInput.classList.add("option-box");
      newInput.required = true;
      newInput.setAttribute('data-label', label);
      optionsContainer.appendChild(newInput);

      // YOUR ORIGINAL CORRECT OPTION CODE
      const option = document.createElement("option");
      option.value = String.fromCharCode(97 + count);
      option.textContent = String.fromCharCode(97 + count);
      correctOptionSelect.appendChild(option);
    });

    // --- Enhanced form submission ---
    form.addEventListener('submit', (event) => {
      // Remove any existing hidden inputs
      const existingHiddenInputs = form.querySelectorAll('input[name="optionText"][type="hidden"]');
      existingHiddenInputs.forEach(input => input.remove());

      // Collect options
      const optionInputs = document.querySelectorAll('input[name="optionText"].option-box');
      const options = Array.from(optionInputs)
        .map((input, index) => {
          const value = input.value.trim();
          if (value) {
            const label = String.fromCharCode(97 + index);
            return `${label}. ${value}`;
          }
          return null;
        })
        .filter(option => option !== null);

      // Validate
      if (options.length < 2) {
        event.preventDefault();
        alert("Please provide at least 2 valid options.");
        return;
      }

      if (options.length > 4) {
        event.preventDefault();
        alert("You cannot have more than 4 options.");
        return;
      }

      if (!correctOptionSelect.value) {
        event.preventDefault();
        alert("Please select the correct option.");
        return;
      }

      // Create hidden input with option text
      const optionText = options.join(', ');
      const hiddenInput = document.createElement('input');
      hiddenInput.type = 'hidden';
      hiddenInput.name = 'optionText';
      hiddenInput.value = optionText;
      form.appendChild(hiddenInput);
    });
  });
  </script>
</body>
</html>