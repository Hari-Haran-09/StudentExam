<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update Coding Questions</title>
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
.select {
    padding: 8px 12px;
    outline: none;
    border: 1px solid #ccc;
    border-radius: 5px;
    width: 200px;
}
.dropdown {
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
</style>
</head>
<body>
<div style="width: 90%; margin: 0 auto; padding: 20px;">

    <div class="add-header">
        <div class="h1" style="font-weight: 600; font-size: 27px;">Update Coding Questions</div>
    </div>

    <form id="questionForm">
        <div class="dropdown">
            <select id="languageName" name="languageName" required class="select">
                <option value="" disabled selected>Select Coding Language</option>
            </select>
        </div>

        <div class="text">
            
            <!-- Easy Level Section -->
            <div class="question-section">
                <h3 class="level-title">Easy Level</h3>
                
                <div class="text1">
                    <p class="ques">Question</p>
                    <textarea class="question-box" id="easyQuestion" name="easyQuestion" placeholder="Enter easy level question" required></textarea>
                </div>
                
                <div class="text1">
                    <p class="sub-ques">Sample Input</p>
                    <textarea class="input-output-box" id="easyInput" name="easyInput" placeholder="Enter sample input for easy question"></textarea>
                </div>
                
                <div class="text1">
                    <p class="sub-ques">Expected Output</p>
                    <textarea class="input-output-box" id="easyExpectedOutput" name="easyExpectedOutput" placeholder="Enter expected output for easy question"></textarea>
                </div>
            </div>

            <!-- Medium Level Section -->
            <div class="question-section">
                <h3 class="level-title">Medium Level</h3>
                
                <div class="text1">
                    <p class="ques">Question</p>
                    <textarea class="question-box" id="mediumQuestion" name="mediumQuestion" placeholder="Enter medium level question" required></textarea>
                </div>
                
                <div class="text1">
                    <p class="sub-ques">Sample Input</p>
                    <textarea class="input-output-box" id="mediumInput" name="mediumInput" placeholder="Enter sample input for medium question"></textarea>
                </div>
                
                <div class="text1">
                    <p class="sub-ques">Expected Output</p>
                    <textarea class="input-output-box" id="mediumExpectedOutput" name="mediumExpectedOutput" placeholder="Enter expected output for medium question"></textarea>
                </div>
            </div>

            <!-- Hard Level Section -->
            <div class="question-section">
                <h3 class="level-title">Hard Level</h3>
                
                <div class="text1">
                    <p class="ques">Question</p>
                    <textarea class="question-box" id="hardQuestion" name="hardQuestion" placeholder="Enter hard level question" required></textarea>
                </div>
                
                <div class="text1">
                    <p class="sub-ques">Sample Input</p>
                    <textarea class="input-output-box" id="hardInput" name="hardInput" placeholder="Enter sample input for hard question"></textarea>
                </div>
                
                <div class="text1">
                    <p class="sub-ques">Expected Output</p>
                    <textarea class="input-output-box" id="hardExpectedOutput" name="hardExpectedOutput" placeholder="Enter expected output for hard question"></textarea>
                </div>
            </div>

        </div>

        <div class="button1">
            <button type="submit" class="save-btn">Save Questions</button>
        </div>
    </form>
</div>

<script>
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
        autofillForm();
    })
    .catch(err => console.error("Error fetching languages:", err));

function autofillForm() {
    const storedData = sessionStorage.getItem("codingToEdit");
    if (!storedData) return;

    const codingData = JSON.parse(storedData);
    console.log("Autofilling form with:", codingData);

    // Fill all fields
    document.getElementById("easyQuestion").value = codingData.easyQuestion || "";
    document.getElementById("mediumQuestion").value = codingData.mediumQuestion || "";
    document.getElementById("hardQuestion").value = codingData.hardQuestion || "";
    
    // Fill input fields
    document.getElementById("easyInput").value = codingData.easyInput || "";
    document.getElementById("mediumInput").value = codingData.mediumInput || "";
    document.getElementById("hardInput").value = codingData.hardInput || "";
    
    // Fill expected output fields
    document.getElementById("easyExpectedOutput").value = codingData.easyExpectedOutput || "";
    document.getElementById("mediumExpectedOutput").value = codingData.mediumExpectedOutput || "";
    document.getElementById("hardExpectedOutput").value = codingData.hardExpectedOutput || "";
    
    const languageSelect = document.getElementById("languageName");
    if (codingData.languageName) {
        languageSelect.value = codingData.languageName;
    }
}

document.getElementById("questionForm").addEventListener("submit", function (e) {
    e.preventDefault(); // Prevent default form submission

    const confirmation = confirm("Do you want to update the coding questions?");
    if (!confirmation) return;

    // Get the ID from stored data
    const storedData = sessionStorage.getItem("codingToEdit");
    if (!storedData) {
        alert("No record ID found for updating.");
        return;
    }

    const codingData = JSON.parse(storedData);
    const id = codingData.id;
    console.log("Updating record with ID:", id);

    const apiUrl = "<%=request.getContextPath()%>/student/updateCoding/" + id;
    console.log("URL:", apiUrl);
    
    // Collect all form data including inputs and expected outputs
    const formData = {
        languageName: document.getElementById("languageName").value,
        easyQuestion: document.getElementById("easyQuestion").value,
        mediumQuestion: document.getElementById("mediumQuestion").value,
        hardQuestion: document.getElementById("hardQuestion").value,
        easyInput: document.getElementById("easyInput").value,
        easyExpectedOutput: document.getElementById("easyExpectedOutput").value,
        mediumInput: document.getElementById("mediumInput").value,
        mediumExpectedOutput: document.getElementById("mediumExpectedOutput").value,
        hardInput: document.getElementById("hardInput").value,
        hardExpectedOutput: document.getElementById("hardExpectedOutput").value
    };

    console.log("Sending data:", formData);

    // Send POST request to the API
    fetch(apiUrl, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(formData)
    })
    .then(response => {
        if (response.ok) {
            return response.text().then(text => {
                alert("Coding questions updated successfully!");
                // Clear session storage after successful update
                sessionStorage.removeItem("codingToEdit");
                // Optionally redirect or clear form
                // window.location.href = "examOverview"; // Uncomment to redirect
            });
        } else {
            return response.text().then(text => {
                alert("Error: " + text);
            });
        }
    })
    .catch(err => {
        console.error("Error updating data:", err);
        alert("An error occurred while updating the data.");
    });
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