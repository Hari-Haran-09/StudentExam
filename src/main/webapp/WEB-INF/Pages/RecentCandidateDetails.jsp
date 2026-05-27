 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="UTF-8">
 <title>Manage Candidates</title>
 <style>
   /* Base Table Styling */
   #dataTable {
     border-collapse: collapse; /* Removes vertical gaps/lines */
     width: 100%;
     min-width: 2300px;
     table-layout: fixed;
   }

   /* Header Styling */
   #dataTable th {
     background: #2178BD;
     color: white;
     font-size: 13px;
     height: 30px;
     text-align: center; /* Centers text */
     padding: 10px 5px;
     border-bottom: 1px solid #ddd;
   }

   /* Body Cell Styling */
   #dataTable td {
     text-align: center; /* Centers all data */
     padding: 12px 5px;
     border-bottom: 1px solid #ddd;
     background: white;
     font-size: 14px;
     word-wrap: break-word;
   }

   /* Row Hover Effect */
   #dataTable tr:hover td {
     background-color: #f9f9f9;
   }

   /* Pagination Styling */
   .pagination {
     margin-top: 20px;
     display: flex;
     justify-content: center;
     gap: 8px;
     padding-bottom: 20px;
   }
   .pagination button {
     padding: 8px 15px;
     border: 1px solid #2178BD;
     background: #fff;
     color: #2178BD;
     cursor: pointer;
     border-radius: 4px;
   }
   .pagination button.active {
     background: #2178BD;
     color: white;
   }
   .pagination button:disabled {
     border-color: #ccc;
     color: #ccc;
     cursor: not-allowed;
   }
 </style>
 </head>
 <body style="font-family: Arial, sans-serif; background-color: #f4f4f4;">

 <div style="width:95%; margin: auto; padding-bottom: 10px; display: flex; justify-content: flex-end; align-items: center; gap: 5px;">
     
     <input type="text" id="searchInput" placeholder="Search name or phone..." 
            style="padding: 6px 10px; width: 200px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; height: 30px; box-sizing: border-box;">
     
     <button onclick="searchCandidates()" 
             style="padding: 0 10px; height: 30px; background: #2178BD; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: bold; transition: 0.3s;">
         Search
     </button>
     
     <button onclick="fetchRegistration()" 
             style="padding: 0 10px; height: 30px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: bold; transition: 0.3s;">
         Reset
     </button>
 </div>

 <div style="width:95%; margin: auto; font-size: 23px; padding: 20px 0; font-weight: 600;">Manage Candidates</div>


 <div style="width:95%; margin: auto; background: white; padding: 10px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
   <div style="width:100%; height:550px; overflow:auto;">
     <table id="dataTable">
       <thead>
         <tr>
           <th style="width:50px;">SL</th>
           <th style="width:250px;">Full Name</th>
           <th style="width:250px;">Email</th>
           <th style="width:100px;">Gender</th>
           <th style="width:150px;">Contact Number</th>
           <th style="width:150px;">City</th>
           <th style="width:150px;">State</th>
           <th style="width:150px;">Role</th>
           <th style="width:150px;">Course</th>
           <th style="width:200px;">Specialization</th>
           <th style="width:100px;">Marks</th>
           <th style="width:120px;">Status</th>
           <th style="width:200px;">Login Time</th>
           <th style="width:150px;">Action</th>
         </tr>
       </thead>
       <tbody id="studentTableBody">
           <tr><td colspan="14">Loading data...</td></tr>
       </tbody>
     </table>
   </div>
   <div class="pagination" id="pagination"></div>
 </div>

 <script>
 const rowsPerPage = 10;

 async function searchCandidates() {
     const query = document.getElementById("searchInput").value;
     const tbody = document.getElementById("studentTableBody");
     
     if (!query) {
         alert("Please enter a name or phone number");
         return;
     }

     try {
         // Updated URL to match the new Controller endpoint
         const response = await fetch(`<%=request.getContextPath()%>/student/searchcandidate?query=\${encodeURIComponent(query)}`);
         const searchData = await response.json();

         if (!searchData || searchData.length === 0) {
             tbody.innerHTML = "<tr><td colspan='14' style='text-align: left; padding:20px 126px; font-weight:bold;'>No results found for: " + query + "</td></tr>";
             document.getElementById("pagination").innerHTML = "";
             return;
         }

         // Use the existing render function to display the data
         renderTableData(searchData);

     } catch (error) {
         console.error("Search Error:", error);
         alert("Search failed. Check console for details.");
     }
 }

 // We move the mapping logic to a separate function so both fetch and search can use it
 function renderTableData(data) {
     const tbody = document.getElementById("studentTableBody");
     tbody.innerHTML = data.map((student, index) => {
         const check = (val) => (val === null || val === undefined || val === "") ? "null" : val;
         const loginTimeDisplay = student.loginTime ? new Date(student.loginTime).toLocaleString() : "null";

         return `
             <tr>
                 <td>\${index + 1}</td>
                 <td>\${check(student.name)}</td>
                 <td>\${check(student.email)}</td>
                 <td>\${check(student.gender)}</td>
                 <td>\${check(student.phone)}</td>
                 <td>\${check(student.city)}</td>
                 <td>\${check(student.state)}</td>
                 <td>\${check(student.role)}</td>
                 <td>\${check(student.course)}</td>
                 <td>\${check(student.specialization)}</td>
                 <td>\${student.totalMarks ?? "0"}</td>
                 <td style="font-weight:bold; color: \${student.status === 'PASS' ? 'green' : 'red'};">
                     \${check(student.status)}
                 </td>
                 <td>\${loginTimeDisplay}</td>
                 <td>
                     <button style="cursor: pointer; color: red; font-weight:bold;" 
                             onclick="deleteFeedback(\${student.id})">Delete</button>
                 </td>
             </tr>
         `;
     }).join("");

     setupPagination(tbody.querySelectorAll("tr"));
 }

 // Main function to fetch data
 async function fetchRegistration() {
     const tbody = document.getElementById("studentTableBody");
     const pagination = document.getElementById("pagination");

     try {
         const response = await fetch("<%=request.getContextPath()%>/student/all-results");
         const registerData = await response.json();

         if (!registerData || registerData.length === 0) {
             tbody.innerHTML = "<tr><td colspan='14'>No records found</td></tr>";
             return;
         }

         // Map data to rows
         tbody.innerHTML = registerData.map((student, index) => {
             const check = (val) => (val === null || val === undefined || val === "") ? "null" : val;
             
             const loginTimeDisplay = student.loginTime 
                 ? new Date(student.loginTime).toLocaleString() 
                 : "null";

             return `
                 <tr>
                     <td>\${index + 1}</td>
                     <td>\${check(student.name)}</td>
                     <td>\${check(student.email)}</td>
                     <td>\${check(student.gender)}</td>
                     <td>\${check(student.phone)}</td>
                     <td>\${check(student.city)}</td>
                     <td>\${check(student.state)}</td>
                     <td>\${check(student.role)}</td>
                     <td>\${check(student.course)}</td>
                     <td>\${check(student.specialization)}</td>
                     <td>\${student.totalMarks ?? "0"}</td>
                     <td style="font-weight:bold; color: \${student.status === 'PASS' ? 'green' : 'red'};">
                         \${check(student.status)}
                     </td>
                     <td>\${loginTimeDisplay}</td>
                     <td>
                         <button style="cursor: pointer; color: red; font-weight:bold;" 
                                 onclick="deleteFeedback(\${student.id})">Delete</button>
                     </td>
                 </tr>
             `;
         }).join("");

         // Initialize Pagination
         setupPagination(tbody.querySelectorAll("tr"));

     } catch (error) {
         console.error("Error fetching data:", error);
         tbody.innerHTML = "<tr><td colspan='14' style='color:red;'>Failed to load data from server</td></tr>";
     }
 }

 function setupPagination(allRows) {
     const pagination = document.getElementById("pagination");
     const totalPages = Math.ceil(allRows.length / rowsPerPage);
     let currentPage = 1;

     function showPage(page) {
         currentPage = page;
         allRows.forEach((row, index) => {
             row.style.display = (index >= (page - 1) * rowsPerPage && index < page * rowsPerPage) ? "" : "none";
         });
         renderPaginationButtons();
     }

     function renderPaginationButtons() {
         pagination.innerHTML = "";
         
         // Prev Button
         const prevBtn = document.createElement("button");
         prevBtn.innerText = "Previous";
         prevBtn.disabled = currentPage === 1;
         prevBtn.onclick = () => showPage(currentPage - 1);
         pagination.appendChild(prevBtn);

         // Page Numbers (Showing max 5 for clean UI)
         for (let i = 1; i <= totalPages; i++) {
             if (i === 1 || i === totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
                 const btn = document.createElement("button");
                 btn.innerText = i;
                 if (i === currentPage) btn.classList.add("active");
                 btn.onclick = () => showPage(i);
                 pagination.appendChild(btn);
             }
         }

         // Next Button
         const nextBtn = document.createElement("button");
         nextBtn.innerText = "Next";
         nextBtn.disabled = currentPage === totalPages;
         nextBtn.onclick = () => showPage(currentPage + 1);
         pagination.appendChild(nextBtn);
     }

     if (totalPages > 0) showPage(1);
 }

 async function deleteFeedback(id) { 
     if (!confirm("Are you sure you want to delete this record?")) return;

     try {
         const url = "<%=request.getContextPath()%>/student/delete/" + id;
         const response = await fetch(url, { method: 'DELETE' });
         const result = await response.text();
         alert(result);
         fetchRegistration(); // Refresh table
     } catch (error) {
         console.error("Error:", error);
         alert("Delete failed.");
     }
 }

 // Start fetch on load
 window.onload = fetchRegistration;
 </script>

 </body>
 </html>