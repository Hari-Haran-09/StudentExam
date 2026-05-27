 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="UTF-8">
 <title>Candidate Performance</title>
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
   /* Added to ensure the table handles nulls and alignment correctly */
   #dataTable td {
     text-align: center;
     vertical-align: middle;
   }
 </style>
 </head>
 <body style="font-family: Arial, sans-serif;">
  
 <div style="display: flex; justify-content: space-between; margin-top: 5px">
 <div style="width:99%; margin: auto; font-size: 23px; padding-top: 10px; font-weight: 600;">Candidates Performance</div>
 <div id="downloadExcelBtn" style="padding-top: 5px; padding-bottom: 5px; padding-left: 15px; padding-right: 15px; background: #2178BD; text-align: center; color: white; border-radius: 5px; display: flex; justify-content: center; align-items: center; margin-right: 20px; cursor:pointer">
   Download
 </div>
 </div>

 <div style="width:98%; margin: auto; padding-top: 10px; display: flex; justify-content: flex-end; align-items: center; gap: 5px; margin-right: 40px;"> <input type="text" id="searchInput" placeholder="Search name or Email..." 
            style="padding: 6px 10px; width: 200px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; height: 30px; box-sizing: border-box; outline:none;">
     
     <button onclick="searchCandidates()" 
             style="padding: 0 10px; height: 30px; background: #2178BD; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: bold;">
         Search
     </button>
     
     <button onclick="fetchRegistration()" 
             style="padding: 0 10px; height: 30px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: bold;">
         Reset
     </button>
 </div>
  
 <div style="padding-top:10px; padding-right: 20px; display:flex; flex-direction:column; align-items:center">
   <div style="width:98%; height:500px; overflow:auto; border: 1.5px solid rgba(0,0,0,0.1); box-shadow: 0 0 8px rgba(0,0,0,0.1); padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px">
     <table id="dataTable" style="border-collapse:separate; border-spacing:0 8px; min-width:2100px;">
       <thead style="background:#2178BD; color:white; font-size:13px; height: 49px">
         <tr>
           <th style="width:30px; text-align:center; padding:4px;">SL</th>
           <th style="width:290px; text-align:center; padding:4px;">Full Name</th>
 		  <th style="width:290px; text-align:center; padding:4px;">Email</th>
           <th style="width:90px; text-align:center; padding:4px;">Gender</th>
           <th style="width:180px; text-align:center; padding:4px;">Contact Number</th>
           <th style="width:230px; text-align:center; padding:4px;">City</th>
 		  <th style="width:230px; text-align:center; padding:4px;">State</th>
           <th style="width:170px; text-align:center; padding:4px;">Role</th>
           <th style="width:190px; text-align:center; padding:4px;">Course</th>
           <th style="width:130px; text-align:center; padding:4px;">Specialization</th>
           <th style="width:150px; text-align:center; padding:4px;">Marks</th>
           <th style="width:150px; text-align:center; padding:4px;">Status</th>
           <th style="width:150px; text-align:center; padding:4px;">Download</th>
         </tr>
       </thead>
       <tbody id="studentTableBody"></tbody>
     </table>
   </div>
   <div class="pagination" id="pagination"></div>
 </div>
  
 <script>
 const rowsPerPage = 10;
 const pagination = document.getElementById("pagination");

 // Shared function to render data to keep logic clean
 function renderTableData(registerData) {
     const tbody = document.getElementById("studentTableBody");
     const check = (val) => (val === null || val === undefined || val === "") ? "null" : val;

     tbody.innerHTML = registerData.map((student, index) => `
         <tr style="background:white;">
             <td style="width:30px; text-align:center; padding:4px;">\${index + 1}</td>
             <td style="width:290px; text-align:center; padding:4px;">\${check(student.name)}</td>
             <td style="width:290px; text-align:center; padding:4px;">\${check(student.email)}</td>
             <td style="width:90px; text-align:center; padding:4px;">\${check(student.gender)}</td>
             <td style="width:180px; text-align:center; padding:4px;">\${check(student.phone)}</td>
             <td style="width:230px; text-align:center; padding:4px;">\${check(student.city)}</td>
             <td style="width:230px; text-align:center; padding:4px;">\${check(student.state)}</td>
             <td style="width:170px; text-align:center; padding:4px;">\${check(student.role)}</td>
             <td style="width:190px; text-align:center; padding:4px;">\${check(student.course)}</td>
             <td style="width:130px; text-align:center; padding:4px;">\${check(student.specialization)}</td>
             <td style="width:150px; text-align:center; padding:4px;">\${student.totalMarks ?? "0"}</td>
             <td style="width:150px; text-align:center; padding:4px; font-weight:bold; color: \${student.status === 'PASS' ? 'green' : 'red'};">\${check(student.status)}</td>
             <td style="width:150px; text-align:center; padding:4px;">
                 <button style="color:#2178BD; background:none; border:none; cursor:pointer; font-weight:bold;">PDF</button>
             </td>
         </tr>
     `).join("");

     const rows = tbody.querySelectorAll("tr");
     setupPagination(rows);
 }

 async function fetchRegistration() {
     document.getElementById("searchInput").value = ""; // Reset search field
     try {
         const response = await fetch("<%=request.getContextPath()%>/student/all-results");
         const registerData = await response.json();
         renderTableData(registerData);
     } catch (error) {
         console.error("Error fetching data:", error);
         document.getElementById("studentTableBody").innerHTML = "<tr><td colspan='13' style='text-align:center;'>Failed to load data</td></tr>";
     }
 }

 async function searchCandidates() {
     const query = document.getElementById("searchInput").value.trim();
     const tbody = document.getElementById("studentTableBody");
     
     if (!query) {
         alert("Please enter a name or Email...");
         return;
     }

     try {
        const response = await fetch(
    "<%=request.getContextPath()%>/student/searchcandidate?query=" + encodeURIComponent(query));
         const searchData = await response.json();
         console.log(searchData);
console.log(Array.isArray(searchData));

         if (!searchData || searchData.length === 0) {
         	tbody.innerHTML = "<tr><td colspan='13' style='text-align: left; padding: 20px; color: black; font-weight:bold;'>No records found for: " + query + "</td></tr>";            pagination.innerHTML = "";
             return;
         }

         renderTableData(searchData);

     } catch (error) {
         console.error("Search Error:", error);
         alert(error);
     }
 }

 function setupPagination(rows) {
     const totalPages = Math.ceil(rows.length / rowsPerPage);
     pagination.innerHTML = "";
     let currentPage = 1;
     const maxVisible = 2;

     function showPage(page) {
         rows.forEach((row, index) => {
             row.style.display = (index >= (page - 1) * rowsPerPage && index < page * rowsPerPage) ? "" : "none";
         });
         updatePaginationUI(page);
     }

     function updatePaginationUI(page) {
         currentPage = page;
         pagination.innerHTML = "";

         const prevBtn = document.createElement("button");
         prevBtn.innerText = "Previous";
         prevBtn.disabled = (currentPage === 1);
         prevBtn.onclick = () => showPage(currentPage - 1);
         pagination.appendChild(prevBtn);

         let startPage = Math.max(1, Math.min(currentPage, totalPages - maxVisible + 1));
         let endPage = Math.min(totalPages, startPage + maxVisible - 1);

         for (let i = startPage; i <= endPage; i++) {
             const btn = document.createElement("button");
             btn.innerText = i;
             if (i === currentPage) btn.classList.add("active");
             btn.onclick = () => showPage(i);
             pagination.appendChild(btn);
         }

         const nextBtn = document.createElement("button");
         nextBtn.innerText = "Next";
         nextBtn.disabled = (currentPage === totalPages);
         nextBtn.onclick = () => showPage(currentPage + 1);
         pagination.appendChild(nextBtn);
     }

     if (totalPages > 0) showPage(1);
 }

 document.getElementById("downloadExcelBtn").addEventListener("click", function () {
     const table = document.getElementById("dataTable");
     const wb = XLSX.utils.table_to_book(table, { sheet: "Candidates" });
     XLSX.writeFile(wb, "Candidates_Performance.xlsx");
 });

 // Initial Load
 window.onload = fetchRegistration;
 </script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
  
 </body>
 </html>