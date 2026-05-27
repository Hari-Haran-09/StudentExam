<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Exam List</title>
<style>
  .pagination {
    margin-top: 15px;
    display: flex;
    justify-content: center;
    gap: 8px;
  }
  .pagination button {
    padding: 5px 10px;
    border: 1px solid #1E2D2B;
    background: #fff;
    color: #1E2D2B;
    cursor: pointer;
  }
  .pagination button.active {
    background: #1E2D2B;
    color: white;
  }
  .button1{
	cursor: pointer;
  }
</style>
</head>
<body style="font-family: Arial, sans-serif;">

<div style="display: flex; justify-content: space-between; margin-top: 5px">
  <div style="width:99%; margin: auto; font-size: 23px; padding-top: 10px; font-weight: 600;">Exam List</div>
</div>

<div style="padding-top:20px; padding-right: 20px; display:flex; flex-direction:column; align-items:center;">
  <div style="width:100%; height:500px; overflow:auto;">
    <table id="dataTable" style="border-collapse:separate; border-spacing:0 8px; min-width:2100px;">
      <thead style="background:#2178BD; color:white; font-size:13px; height: 49px">
        <tr>
          <th style="width:30px; text-align:center; padding:4px;">Sno</th>
          <th style="width:200px; text-align:center; padding:4px;">Programming Language</th>
          <th style="width:90px; text-align:center; padding:4px;">Time Duration</th>
          <th style="width:100px; text-align:center; padding:4px;">Total MCQ'S</th>
          <th style="width:100px; text-align:center; padding:4px;">Each MCQ Marks</th>
          <th style="width:110px; text-align:center; padding:4px;">Total Coding Questions</th>
          <th style="width:130px; text-align:center; padding:4px;">Easy Level Marks</th>
          <th style="width:130px; text-align:center; padding:4px;">Medium Level Marks</th>
          <th style="width:130px; text-align:center; padding:4px;">High Level Marks</th>
          <th style="width:150px; text-align:center; padding:4px;">Actions</th>
        </tr>
      </thead>
      <tbody>
        <!-- Rows will be populated dynamically -->
      </tbody>
    </table>
  </div>
  <div class="pagination" id="pagination"></div>
</div>

<script>
const rowsPerPage = 10;
let examsData = [];
const tbody = document.getElementById("dataTable").querySelector("tbody");
const pagination = document.getElementById("pagination");

// Fetch data from API
async function fetchExams() {
    try {
        <!--const response = await fetch("http://localhost:4049/student/manageExamss");-->
		const response = await fetch("<%=request.getContextPath()%>/student/manageExamss");
        examsData = await response.json();
        <!--console.log("Fetched data:", examsData);-->
        setupPagination();
    } catch (error) {
        console.error("Error fetching exams:", error);
        tbody.innerHTML = "<tr><td colspan='10' style='text-align:center'>Failed to load data</td></tr>";
    }
}

// Render table rows for a specific page
function renderTable(page = 1) {
    tbody.innerHTML = "";
    const start = (page - 1) * rowsPerPage;
    const end = page * rowsPerPage;
    const pageData = examsData.slice(start, end);

    pageData.forEach((exam, i) => {
        const row = document.createElement("tr");
        row.style.background = "white";
        row.style.boxShadow = "0px 2px 4px rgba(0,0,0,0.1)";
        row.onmouseover = () => row.style.background = "#f1f1f1";
        row.onmouseout = () => row.style.background = "white";

        <!--console.log("final data is:", exam.languageName);-->
		<!--console.log("id is:", exam.id)-->

        row.innerHTML = `
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">\${start + i + 1}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">\${exam.languageName}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">\${exam.meetingTime}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">\${exam.totalMcq}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">\${exam.eachMcqMark}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">\${exam.totalCodingQuestion}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px; color: black">\${exam.easyLevelMarks}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">\${exam.mediumLevelMarks}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">\${exam.hardLevelMarks}</td>
            <td style="text-align:center; padding-top:11px; padding-bottom:11px; padding-left:4px; padding-right:4px;">
                <!--<button onclick="editExam(${exam.id})">Edit</button>-->
				<button class="button1" onclick="deleteExam(\${exam.id})">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// Setup pagination buttons
function setupPagination() {
    pagination.innerHTML = "";
    const totalPages = Math.ceil(examsData.length / rowsPerPage);

    for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement("button");
        btn.innerText = i;
        btn.id = "page" + i;
        btn.onclick = () => showPage(i);
        pagination.appendChild(btn);
    }

    if (totalPages > 0) showPage(1);
}

// Show a specific page
function showPage(page) {
    renderTable(page);
    document.querySelectorAll(".pagination button").forEach(btn => btn.classList.remove("active"));
    const activeBtn = document.getElementById("page" + page);
    if (activeBtn) activeBtn.classList.add("active");
}


function editExam(id) {
    alert("Edit exam ID: " + id);
}

async function deleteExam(id) {
    if (!confirm("Are you sure you want to delete this exam?")) return;

    try {
        <!--console.log("Exam ID:", id);-->
		<!--const url = "http://localhost:4049/student/manageExams/" + id;-->
		const url = "<%=request.getContextPath()%>/student/manageExams/" + id;
		<!--console.log("DELETE URL:", url)-->;
		const response = await fetch(url, { method: 'DELETE' });
        const result = await response.text();
        alert(result);

        
        examsData = examsData.filter(exam => exam.id !== id);
        
        showPage(1);
    } catch (error) {
        console.error("Error deleting exam:", error);
        alert("Failed to delete exam.");
    }
}



// Load data initially
fetchExams();
</script>

</body>
</html>
