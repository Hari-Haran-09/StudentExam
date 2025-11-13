<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.div1{
width: 20%;
  padding-top: 7px;
  padding-bottom: 7px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  border-radius: 5px;
   justify-content: space-evenly;
  }
  
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
  gap: 5px;
}

.pagination button {
  padding: 8px 12px;
  border: 1px solid #ddd;
  background-color: white;
  cursor: pointer;
  border-radius: 4px;
}

.pagination button.active {
  background-color: #2178BD;
  color: white;
  border-color: #2178BD;
}

.pagination button:hover:not(.active) {
  background-color: #f1f1f1;
}

.pagination button:disabled {
  background-color: #f5f5f5;
  color: #ccc;
  cursor: not-allowed;
}
</style>
 
<body>
<div style="height: 630px;">
<h2 style="color:black; padding-left: 15px">Candidate Analytics</h2>
 
<!-- Summary Cards -->
<!-- first div start -->
<div style="display: flex; justify-content: space-between; padding-left: 17px; padding-right: 37px">
  <div class="div1" style="background: #2178BD; color: white;">
   <div style="width: 50px; height: 50px;">
    <img src="${pageContext.request.contextPath}/images/total_registration.png" alt="Logo" style="height: full; width: full">
     </div> <div style="text-align: center;">
      <p>Total Registered</p>
      <!--<p>90</p>-->
	  <p id="totalRegistered"></p>
      </div>
      
       </div>
        <div class="div1" style="background: #058C17; color: white;">
        <div style="width: 50px; height: 50px;">
         <img src="${pageContext.request.contextPath}/images/exam_pass.png" alt="Logo" style="height: full; width: full">
          </div>
           <div style="text-align: center;">
            <p>Exam Passed</p>
             <p id="examPassed"></p>
              </div>
               </div>
               <div class="div1" style="background: #FC0A0A; color: white;">
                <div style="width: 50px; height: 50px;">
                 <img src="${pageContext.request.contextPath}/images/exam_fail.png" alt="Logo" style="height: full; width: full">
                  </div> <div style="text-align: center;">
                   <p>Exam Failed</p>
                    <p id="examFailed"></p>
                     </div>
                      </div>
                      
                       <div class="div1" style="background: #FFEA08; color: black;">
                        <div style="width: 50px; height: 50px;">
                         <img src="${pageContext.request.contextPath}/images/programming.png" alt="Logo" style="height: full; width: full">
                          </div> <div style="text-align: center;">
                           <p>Programming <br> Languages</p>
                            <p id="count"></p>
                             </div>
                              </div>
                               </div> <!-- first div end -->
 
<div class="analytics-container" style="display:flex; gap:20px; justify-content:space-between; margin-top: 25px; margin-bottom: 25px;">
    <!-- Left Column -->
    <div class="card-inner" style="background:white; padding:20px; border-radius:8px; width:48%; box-shadow: 0 0 8px rgba(0,0,0,0.1); border: 1.5px solid rgba(0,0,0,0.1);">
        <h3 style="color:black; text-align: center">Most Preferred Exam</h3>
        <canvas id="examChart" style="width:100%; height:300px;"></canvas>
    </div>
 
    <!-- Right Column -->
    <div class="card-inner" style="background:white; padding:20px; border-radius:8px; width:48%;">
        <div style="display:flex; gap:10px;">
            <div style="width:50%; box-shadow: 0 0 8px rgba(0,0,0,0.1); border: 1.5px solid rgba(0,0,0,0.1);">
                <h3 style="color:black; text-align: center">Gender</h3>
                <canvas id="genderChart" style="width:100%; height:150px;"></canvas>
                <!--<div style="display:flex; justify-content:space-around; margin-top:10px;">
                    <div style="background:#f2f2f2; padding:5px 10px; border-radius:5px; text-align:center;">
                        <p style="color: black">Highest Score</p>
                        <p style="color:green;">25/30 &#9650;</p>
                    </div>
                    <div style="background:#f2f2f2; padding:5px 10px; border-radius:5px; text-align:center;">
                        <p style="color: black">Lowest Score</p>
                        <p style="color:red;">03/30 &#9660;</p>
                    </div>
                </div>-->
            </div>
 
            <div style="width:50%; box-shadow: 0 0 8px rgba(0,0,0,0.1); border: 1.5px solid rgba(0,0,0,0.1);">
                <h3 style="color:black; text-align: center">Candidates</h3>
                <canvas id="candidateTypeChart" style="width:100%; height:150px;"></canvas>
            </div>
        </div>
    </div>
    
</div>
 
 
<div style="border: 2px solid gray; width: 95%; margin: auto; box-shadow: 0 4px 10px rgba(0,0,0,0.3)">
<h3 style="color: black; width: fit-content; margin-left: 2.5%">Recent Candidate Details</h3>
<div style="width: 90%; padding: 10px; display: flex; align-items: center; gap: 10px; justify-content: end">
  <label for="statusFilter" style="font-weight: bold; color: black;">Filter by Status:</label>
  
  <select id="statusFilter" style="padding: 6px; border-radius: 5px; font-size: 14px;">
    <option value="">-- All Candidates --</option>
    <option value="pass">PASS</option>
    <option value="failed">FAILED</option>
  </select>
</div>

<div style="padding:20px; display:flex; flex-direction:column; align-items:center; margin: auto">
  <div style="width:98.3%; height:500px; overflow:auto;">
    <table id="dataTable" style="border-collapse:separate; border-spacing:0 8px; min-width:1900px;">
      <thead style="background:#2178BD; color:white; font-size:13px; height: 49px">
        <tr>
          <th style="width:30px; text-align:center; padding:4px;">SL</th>
          <th style="width:200px; text-align:center; padding:4px;">Full Name</th>
          <th style="width:90px; text-align:center; padding:4px;">Gender</th>
          <th style="width:180px; text-align:center; padding:4px;">Contact Number</th>
          <th style="width:230px; text-align:center; padding:4px;">City</th>
		  <th style="width:230px; text-align:center; padding:4px;">State</th>
          <th style="width:170px; text-align:center; padding:4px;">Role</th>
          <th style="width:190px; text-align:center; padding:4px;">Course</th>
          <th style="width:230px; text-align:center; padding:4px;">Specialization</th>
          <th style="width:90px; text-align:center; padding:4px;">Marks</th>
          <th style="width:100px; text-align:center; padding:4px;">Status</th>
        </tr>
      </thead>
      <tbody id="studentTableBody">
        <!-- Table rows will be populated by JavaScript -->
      </tbody>
    </table>
  </div>
  <div class="pagination" id="pagination">
    <!-- Pagination buttons will be generated here -->
  </div>
</div>
</div>
 
<script>
// Global variables
let allStudentData = [];
let currentPage = 1;
const rowsPerPage = 10; // Number of rows to display per page

// Fetch total registered students
fetch("<%=request.getContextPath()%>/student/students")
    .then(response => response.json())
    .then(data => {
        document.getElementById('totalRegistered').textContent = data.totalRegistered;
    })
    .catch(error => {
        console.error('Error fetching total registered students:', error);
        document.getElementById('totalRegistered').textContent = 'Error';
    });
    
fetch("<%=request.getContextPath()%>/student/languageCount")
    .then(response => response.json())
    .then(data => {
        document.getElementById('count').textContent = data.count;
    })
    .catch(error => {
        console.error('Error fetching total programming language:', error);
        document.getElementById('count').textContent = 'Error';
    });

// Fetch exam pass and fail counts
fetch("<%=request.getContextPath()%>/student/all-results")
    .then(response => response.json())
    .then(data => {
        let passCount = 0;
        let failCount = 0;

        data.forEach(student => {
            const status = student.status ? student.status.toLowerCase().trim() : "";
            if (status === "pass") passCount++;
            else if (status === "failed") failCount++;
        });

        // Update the counts in your HTML
        document.getElementById("examPassed").textContent = passCount;
        document.getElementById("examFailed").textContent = failCount;
    })
    .catch(error => {
        console.error("Error fetching pass/fail data:", error);
    });

// Fetch data for charts
fetch("<%=request.getContextPath()%>/student/all-results")
    .then(response => response.json())
    .then(data => {
        let java = 0, python = 0, php = 0, react = 0, javascript = 0, testing = 0, others = 0;

        data.forEach(student => {
            if (student.languageName.toLowerCase() === "java") java++;
            else if (student.languageName.toLowerCase() === "python") python++;
            else if (student.languageName.toLowerCase() === "php") php++;
            else if (student.languageName.toLowerCase() === "react") react++;
            else if (student.languageName.toLowerCase() === "javascript") javascript++;
            else if (student.languageName.toLowerCase() === "testing") testing++;
            else others++;
        });

        const examCtx = document.getElementById('examChart').getContext('2d');
        new Chart(examCtx, {
            type: 'bar',
            data: {
                labels: ['Python', 'Java', 'PHP', 'React JS', 'JavaScript', 'testing', 'Others'],
                datasets: [{
                    label: 'Candidates',
                    data: [python, java, php, react, javascript, testing, others],
                    backgroundColor: ['#FF0000','#00BFFF','#4169E1','#32CD32','#FF8C00','#AF3149','#000000']
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });
    })
    .catch(error => {
        console.error('Error fetching exam data:', error);
    });

// Fetch gender data
fetch("<%=request.getContextPath()%>/student/registerrr")
    .then(response => response.json())
    .then(data => {
        let male = 0, female = 0, others = 0;

        data.forEach(student => {
            if (student.gender.toLowerCase() === "male") male++;
            else if (student.gender.toLowerCase() === "female") female++;
            else others++;
        });

        const genderCtx = document.getElementById('genderChart').getContext('2d');
        new Chart(genderCtx, {
            type: 'pie',
            data: {
                labels: ['Male', 'Female', 'Others'],
                datasets: [{
                    data: [male, female, others],
                    backgroundColor: ['#FFA500','#FFFF00','#1E90FF']
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    })
    .catch(error => {
        console.error('Error fetching gender data:', error);
    });

// Fetch candidate type data
fetch("<%=request.getContextPath()%>/student/registerrr")
    .then(response => response.json())
    .then(data => {
        let students = 0 , freshers = 0, experienced = 0;
        
        data.forEach(student=>{
            let exp = student.experience ? student.experience.toString().toLowerCase().trim() : '';

            if (exp === "student") {
                students++;
            } else if (exp === "fresher" || exp === "0-1" || exp === "0–1 years" || exp === "0 to 1") {
                freshers++;
            } else {
                experienced++;
            }
        });
        
        const candidateCtx = document.getElementById('candidateTypeChart').getContext('2d');
        new Chart(candidateCtx, {
            type: 'bar',
            data: {
                labels: ['Students','Freshers','Experienced'],
                datasets: [{
                    data: [students,freshers,experienced],
                    backgroundColor: ['#0000FF','#FF0000','#00FF00']
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });
    })
    .catch(error => {
        console.error('Error fetching candidate type data:', error);
    });

// Main function to fetch and display registration data
async function fetchRegistration() {
    const tbody = document.getElementById("studentTableBody");
    try {
        const response = await fetch("<%=request.getContextPath()%>/student/all-results");
        allStudentData = await response.json();
        
        // Display all data initially
        displayFilteredData(allStudentData);
        
        // Add event listener for filter
        document.getElementById("statusFilter").addEventListener("change", function() {
            const filterValue = this.value;
            currentPage = 1; // Reset to first page when filter changes
            filterTableData(filterValue);
        });
        
    } catch (error) {
        console.error("Error fetching registration data:", error);
        tbody.innerHTML = "<tr><td colspan='11' style='text-align:center;'>Failed to load data</td></tr>";
    }
}

// Function to filter table data based on status
function filterTableData(status) {
    let filteredData;
    
    if (status === "") {
        // Show all data
        filteredData = allStudentData;
    } else {
        // Filter based on status
        filteredData = allStudentData.filter(student => {
            const studentStatus = student.status ? student.status.toLowerCase().trim() : "";
            return studentStatus === status;
        });
    }
    
    displayFilteredData(filteredData);
}

// Function to display filtered data in the table with pagination
function displayFilteredData(data) {
    const tbody = document.getElementById("studentTableBody");
    const paginationElement = document.getElementById("pagination");
    
    // Calculate total pages
    const totalPages = Math.ceil(data.length / rowsPerPage);
    
    // Ensure current page is within bounds
    if (currentPage > totalPages) {
        currentPage = totalPages;
    }
    if (currentPage < 1) {
        currentPage = 1;
    }
    
    // Calculate start and end index for current page
    const startIndex = (currentPage - 1) * rowsPerPage;
    const endIndex = startIndex + rowsPerPage;
    const paginatedData = data.slice(startIndex, endIndex);
    
    // Display the paginated data
    tbody.innerHTML = paginatedData.map((student, index) => {
        // Determine status color
        let statusText = student.status ? student.status.trim().toLowerCase() : "";
        let statusColor = "";

        if (statusText === "pass") statusColor = "green";
        else if (statusText === "failed") statusColor = "red";
        else statusColor = "black";

        return `
            <tr>
                <td style="width:30px; text-align:center; padding:4px;">\${startIndex + index + 1}</td>
                <td style="width:200px; text-align:center; padding:4px;">\${student.name}</td>
                <td style="width:90px; text-align:center; padding:4px;">\${student.email}</td>
                <td style="width:180px; text-align:center; padding:4px;">\${student.phone}</td>
                <td style="width:230px; text-align:center; padding:4px;">\${student.city}</td>
                <td style="width:230px; text-align:center; padding:4px;">\${student.state}</td>
                <td style="width:170px; text-align:center; padding:4px;">\${student.role}</td>
                <td style="width:190px; text-align:center; padding:4px;">\${student.course}</td>
                <td style="width:230px; text-align:center; padding:4px;">\${student.specialization}</td>
                <td style="width:90px; text-align:center; padding:4px;">\${student.totalMarks}</td>
                <td style="width:100px; text-align:center; padding:4px; color:\${statusColor}; font-weight:bold;">
                    \${student.status}
                </td>
            </tr>
        `;
    }).join("");
    
    // Generate pagination buttons
    generatePaginationButtons(totalPages);
}

// Function to generate pagination buttons
function generatePaginationButtons(totalPages) {
    const paginationElement = document.getElementById("pagination");
    
    // Clear existing buttons
    paginationElement.innerHTML = '';
    
    // Don't show pagination if there's only one page
    if (totalPages <= 1) {
        return;
    }
    
    // Previous button
    const prevButton = document.createElement('button');
    prevButton.innerHTML = '&laquo;';
    prevButton.disabled = currentPage === 1;
    prevButton.addEventListener('click', () => {
        if (currentPage > 1) {
            currentPage--;
            updateTableForCurrentFilter();
        }
    });
    paginationElement.appendChild(prevButton);
    
    // Page number buttons
    const maxVisiblePages = 5; // Maximum number of page buttons to show
    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
    let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
    
    // Adjust start page if we're near the end
    if (endPage - startPage + 1 < maxVisiblePages) {
        startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }
    
    // First page button (if needed)
    if (startPage > 1) {
        const firstPageButton = document.createElement('button');
        firstPageButton.textContent = '1';
        firstPageButton.addEventListener('click', () => {
            currentPage = 1;
            updateTableForCurrentFilter();
        });
        paginationElement.appendChild(firstPageButton);
        
        // Ellipsis if needed
        if (startPage > 2) {
            const ellipsis = document.createElement('span');
            ellipsis.textContent = '...';
            ellipsis.style.padding = '8px 12px';
            paginationElement.appendChild(ellipsis);
        }
    }
    
    // Page number buttons
    for (let i = startPage; i <= endPage; i++) {
        const pageButton = document.createElement('button');
        pageButton.textContent = i;
        if (i === currentPage) {
            pageButton.classList.add('active');
        }
        pageButton.addEventListener('click', () => {
            currentPage = i;
            updateTableForCurrentFilter();
        });
        paginationElement.appendChild(pageButton);
    }
    
    // Last page button (if needed)
    if (endPage < totalPages) {
        // Ellipsis if needed
        if (endPage < totalPages - 1) {
            const ellipsis = document.createElement('span');
            ellipsis.textContent = '...';
            ellipsis.style.padding = '8px 12px';
            paginationElement.appendChild(ellipsis);
        }
        
        const lastPageButton = document.createElement('button');
        lastPageButton.textContent = totalPages;
        lastPageButton.addEventListener('click', () => {
            currentPage = totalPages;
            updateTableForCurrentFilter();
        });
        paginationElement.appendChild(lastPageButton);
    }
    
    // Next button
    const nextButton = document.createElement('button');
    nextButton.innerHTML = '&raquo;';
    nextButton.disabled = currentPage === totalPages;
    nextButton.addEventListener('click', () => {
        if (currentPage < totalPages) {
            currentPage++;
            updateTableForCurrentFilter();
        }
    });
    paginationElement.appendChild(nextButton);
}

// Function to update table based on current filter and page
function updateTableForCurrentFilter() {
    const filterValue = document.getElementById("statusFilter").value;
    filterTableData(filterValue);
}

// Initialize the page
fetchRegistration();
</script>
</div>
</body>