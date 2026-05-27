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
    body { font-family: "Roboto", sans-serif }
    .main-box { padding: 30px; max-width: 900px }
    .add-header { margin-left: 0; margin-bottom: 20px; }
    .h1 { font-size: 26px; font-weight: bold; color: #333; }
    .ques, .op { font-weight: bold; color: #444; margin: 15px 0 8px; }
    .question-box {
      width: 100%; height: 150px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      border: none; border-radius: 8px; margin-top: 10px; padding: 15px;
      font-size: 16px; resize: none; outline: none; box-sizing: border-box;
    }
    .side { display: flex; justify-content: space-between; align-items: center; margin: 20px 0 10px; }
    .add-q {
      background: #2176bb; color: #fff; border: none; padding: 8px 16px;
      border-radius: 6px; font-size: 14px; font-weight: bold; cursor: pointer;
      transition: background 0.3s;
    }
    .add-q:hover { background: #1a5d94; }
    .option-container { margin-top: 10px; }
    .option-box {
      width: 100%; padding: 14px; margin-bottom: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1); border: none; border-radius: 8px;
      font-size: 15px; outline: none; box-sizing: border-box;
    }
    .save-btn {
      background: #28a745; color: white; font-weight: bold; border: none;
      border-radius: 8px; cursor: pointer; padding: 12px 30px; font-size: 16px;
      transition: background 0.3s;
    }
    .save-btn:hover { background: #218838; }
    .save { text-align: right; margin-top: 25px; }
    .dropdown { text-align: right; margin: 15px 0; }
    .select {
      padding: 10px; outline: none; width: 250px; border-radius: 6px;
      border: 1px solid #ccc; font-size: 15px;
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

      <!-- Language Dropdown -->
      <div class="dropdown">
        <select id="languageName" name="languageName" required class="select">
          <option value="" disabled selected>Select Coding Language</option>
        </select>
      </div>

      <!-- Question -->
      <div class="hh">
        <p class="ques">Question</p>
        <textarea class="question-box" name="question" placeholder="Enter Your Question" required id="questionTextarea"></textarea>
      </div>

      <!-- Options Header -->
      <div class="side">
        <div><p class="op">Options</p></div>
        <div><button type="button" class="add-q" id="add-option-btn">+ Add Option</button></div>
      </div>

      <!-- Dynamic Options -->
      <div class="option-container" id="options-container"></div>

      <!-- Correct Option Dropdown -->
      <div class="dropdown">
        <select id="correctOption" name="correctOption" required class="select">
          <option value="" disabled selected>Select Correct Option (a, b, c, d)</option>
        </select>
      </div>

      <!-- Submit Button -->
      <div class="save">
        <button type="submit" class="save-btn">Update Question</button>
      </div>
    </form>
  </div>

  <script>
  document.addEventListener('DOMContentLoaded', () => {
    const optionsContainer = document.getElementById('options-container');
    const correctOptionSelect = document.getElementById('correctOption');
    const languageSelect = document.getElementById('languageName');
    const questionTextarea = document.getElementById('questionTextarea');
    const addOptionBtn = document.getElementById('add-option-btn');
    const form = document.getElementById('mcqform');

    // Step 1: Load languages from server
    fetch("<%=request.getContextPath()%>/student/getLanguage")
      .then(res => {
        if (!res.ok) throw new Error("Failed to load languages");
        return res.json();
      })
      .then(data => {
        // Populate language dropdown
        data.forEach(item => {
          const opt = document.createElement("option");
          opt.value = item.languageName;
          opt.textContent = item.languageName;
          languageSelect.appendChild(opt);
        });

        // Step 2: NOW safe to auto-fill edit data (options exist!)
        const storedData = sessionStorage.getItem("mcqToEdit");
        if (storedData) {
          try {
            const mcq = JSON.parse(storedData);

            // Helper to decode if needed
            const decodeText = (text, isEncoded) => {
              if (!isEncoded) return text.replace(/&quot;/g, '"');
              try { return decodeURIComponent(escape(atob(text))); }
              catch (e) { return text; }
            };

            const isEncoded = mcq.encoded || false;
            const decodedQuestion = decodeText(mcq.question, isEncoded);
            const decodedOptionText = decodeText(mcq.optionText, isEncoded);

            // Fill form
            document.getElementById("mcqId").value = mcq.id || '';
            questionTextarea.value = decodedQuestion.replace(/\\n/g, "\n");

            // Clear previous options
            optionsContainer.innerHTML = "";
            correctOptionSelect.innerHTML = '<option value="" disabled selected>Select Correct Option</option>';

            // Parse stored options: "a. First", "b. Second", ...
            const options = decodedOptionText.split(/,\s*(?=[a-z]\.)/i).map(o => o.trim());

            options.forEach((opt, index) => {
              if (!opt) return;
              const text = opt.replace(/^[a-z]\.\s*/i, '').trim();
              const label = String.fromCharCode(97 + index); // a, b, c, d

              // Create option input field
              const input = document.createElement("input");
              input.type = "text";
              input.classList.add("option-box");
              input.placeholder = `Option ${label.toUpperCase()}`;
              input.value = text;
              input.required = true;
              input.dataset.label = label;
              optionsContainer.appendChild(input);

              // Add to correct answer dropdown
              const optEl = document.createElement("option");
              optEl.value = label;
              optEl.textContent = label.toUpperCase();
              correctOptionSelect.appendChild(optEl);
            });

            // Auto-select correct option and language
            if (mcq.correctOption) {
              correctOptionSelect.value = mcq.correctOption.toLowerCase();
            }
            if (mcq.languageName) {
              languageSelect.value = mcq.languageName; // NOW WORKS!
              console.log("Language auto-selected:", mcq.languageName);
            }

            sessionStorage.removeItem("mcqToEdit");
          } catch (e) {
            console.error("Failed to load MCQ for edit:", e);
            alert("Could not load question. Please try again.");
          }
        }
      })
      .catch(err => {
        console.error("Error loading languages:", err);
        alert("Failed to load languages. Please refresh the page.");
      });

    // Add new option (max 4)
    addOptionBtn.addEventListener('click', () => {
      const currentCount = optionsContainer.querySelectorAll('.option-box').length;
      if (currentCount >= 4) {
        alert("Maximum 4 options allowed.");
        return;
      }
      const label = String.fromCharCode(97 + currentCount); // a, b, c, d

      const input = document.createElement("input");
      input.type = "text";
      input.classList.add("option-box");
      input.placeholder = `Option ${label.toUpperCase()}`;
      input.required = true;
      input.dataset.label = label;
      optionsContainer.appendChild(input);

      const opt = document.createElement("option");
      opt.value = label;
      opt.textContent = label.toUpperCase();
      correctOptionSelect.appendChild(opt);
    });

    // Form submit - inject optionsJson
    form.addEventListener('submit', (e) => {
      // Remove old optionsJson if exists
      const oldJson = form.querySelector('input[name="optionsJson"]');
      if (oldJson) oldJson.remove();

      const inputs = optionsContainer.querySelectorAll('.option-box');
      const values = Array.from(inputs)
        .map(i => i.value.trim())
        .filter(v => v !== "");

      if (values.length < 2) {
        e.preventDefault();
        alert("At least 2 options are required.");
        return;
      }
      if (values.length > 4) {
        e.preventDefault();
        alert("Maximum 4 options allowed.");
        return;
      }
      if (!correctOptionSelect.value) {
        e.preventDefault();
        alert("Please select the correct option.");
        return;
      }

      // Inject JSON array as hidden field
      const hidden = document.createElement('input');
      hidden.type = 'hidden';
      hidden.name = 'optionsJson';
      hidden.value = JSON.stringify(values);
      form.appendChild(hidden);

      console.log("Updating MCQ with:", { id: document.getElementById("mcqId").value, values });
    });
  });
  </script>
</body>
</html>