<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Recent Candidate Details</title>
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
</style>
</head>
<body style="font-family: Arial, sans-serif;">
 
<div style="width:99%; margin: auto; font-size: 23px; padding-top: 10px; font-weight: 600;">Manage Candidates</div>
 
<div style="padding-top:20px; padding-right: 20px; display:flex; flex-direction:column; align-items:center;">
  <div style="width:100%; height:500px; overflow:auto;">
    <table id="dataTable" style="border-collapse:separate; border-spacing:0 8px; min-width:2100px;">
      <thead style="background:#2178BD; color:white; font-size:13px; height: 49px">
        <tr>
          <th style="width:30px; text-align:center; padding:4px;">SL</th>
          <th style="width:290px; text-align:center; padding:4px;">Full Name</th>
		  <th style="width:270px; text-align:center; padding:4px;">Email</th>
          <th style="width:90px; text-align:center; padding:4px;">Gender</th>
          <th style="width:180px; text-align:center; padding:4px;">Contact Number</th>
          <th style="width:230px; text-align:center; padding:4px;">City</th>
		  <th style="width:230px; text-align:center; padding:4px;">State</th>
          <th style="width:170px; text-align:center; padding:4px;">Role</th>
          <th style="width:190px; text-align:center; padding:4px;">Course</th>
          <th style="width:230px; text-align:center; padding:4px;">Specialization</th>
          <th style="width:150px; text-align:center; padding:4px;">Marks</th>
          <th style="width:150px; text-align:center; padding:4px;">Status</th>
          <th style="width:150px; text-align:center; padding:4px;">Action</th>
        </tr>
      </thead>
      <tbody id="studentTableBody">
        <!-- <tr style="background:white; box-shadow:0px 2px 4px rgba(0,0,0,0.1);" onmouseover="this.style.background='#f1f1f1'" onmouseout="this.style.background='white'">
          <td style="width:30px; text-align:center; padding:4px;">1</td>
          <td style="width:200px; text-align:center; padding:4px;"></td>
          <td style="width:90px; text-align:center; padding:4px;">Male</td>
          <td style="width:180px; text-align:center; padding:4px;">+91 8919382928</td>
          <td style="width:230px; text-align:center; padding:4px;">Anaparthi</td>
          <td style="width:170px; text-align:center; padding:4px;">React</td>
          <td style="width:190px; text-align:center; padding:4px;">B.Tech</td>
          <td style="width:230px; text-align:center; padding:4px;">Mechanical Engineering</td>
          <td style="width:150px; text-align:center; padding:4px;">78</td>
          <td style="width:150px; text-align:center; padding:4px;">Pass</td>
          <td style="width:150px; text-align:center; padding:4px;">Delete</td>
        </tr> -->
      </tbody>
    </table>
  </div>
  <div class="pagination" id="pagination"></div>
</div>
 
<script>
const rowsPerPage = 10;
const table = document.getElementById("dataTable");
const tbody = table.querySelector("tbody");
const rows = tbody.querySelectorAll("tr");
const totalPages = Math.ceil(rows.length / rowsPerPage);
const pagination = document.getElementById("pagination");
 
function showPage(page) {
  rows.forEach((row, index) => {
    row.style.display = (index >= (page-1)*rowsPerPage && index < page*rowsPerPage) ? "" : "none";
  });
  document.querySelectorAll(".pagination button").forEach(btn => btn.classList.remove("active"));
  document.getElementById("page" + page).classList.add("active");
}
 
for (let i = 1; i <= totalPages; i++) {
  const btn = document.createElement("button");
  btn.innerText = i;
  btn.id = "page" + i;
  btn.onclick = () => showPage(i);
  pagination.appendChild(btn);
}
 
if (totalPages > 0) showPage(1);


async function fetchRegistration() {
    const tbody = document.getElementById("studentTableBody");
    try {
        const response = await fetch("<%=request.getContextPath()%>/student/all-results");
        <!--if (!response.ok) throw new Error("Network response was not ok");-->
        
        const registerData = await response.json();
        <!--console.log("Fetched data:", registerData);-->

        tbody.innerHTML = registerData.map((student, index) => `
            <tr>
                <td style="width:30px; text-align:center; padding:4px;">\${index + 1}</td>
                <td style="width:290px; text-align:center; padding:4px;">\${student.name}</td>
				<td style="width:270px; text-align:center; padding:4px;">\${student.email}</td>
                <td style="width:90px; text-align:center; padding:4px;">\${student.gender}</td>
				<td style="width:180px; text-align:center; padding:4px;">\${student.phone}</td>
                <td style="width:230px; text-align:center; padding:4px;">\${student.city}</td>
				<td style="width:230px; text-align:center; padding:4px;">\${student.state}</td>
				<td style="width:170px; text-align:center; padding:4px;">\${student.role}</td>
				<td style="width:190px; text-align:center; padding:4px;">\${student.course}</td>
				<td style="width:230px; text-align:center; padding:4px;">\${student.specialization}</td>
				<td style="width:90px; text-align:center; padding:4px;">\${student.totalMarks}</td>
				<td style="width:100px; text-align:center; padding:4px;">\${student.status}</td>
				<th style="width:150px; text-align:center; padding:4px;"><button style="cursor: pointer; color: red" onclick="deleteFeedback(\${student.id})">Delete</button></th>
            </tr>
        `).join("");
		const rows = tbody.querySelectorAll("tr");
		        const totalPages = Math.ceil(rows.length / rowsPerPage);
		        pagination.innerHTML = "";

		        let currentPage = 1;
		        const maxVisible = 2; // show only 2 page numbers

		        function showPage(page) {
		            rows.forEach((row, index) => {
		                row.style.display = (index >= (page - 1) * rowsPerPage && index < page * rowsPerPage)
		                    ? "" : "none";
		            });
		            updatePagination();
		        }

		        function updatePagination() {
		            pagination.innerHTML = "";

		            // Previous button
		            const prevBtn = document.createElement("button");
		            prevBtn.innerText = "Previous";
		            prevBtn.disabled = (currentPage === 1);
		            prevBtn.onclick = () => {
		                if (currentPage > 1) {
		                    currentPage--;
		                    showPage(currentPage);
		                }
		            };
		            pagination.appendChild(prevBtn);

		            // Determine visible page range
		            let startPage = currentPage;
		            if (currentPage > totalPages - 1) {
		                startPage = totalPages - 1;
		            }
		            startPage = Math.max(1, startPage);
		            const endPage = Math.min(totalPages, startPage + maxVisible - 1);

		            // Page number buttons
		            for (let i = startPage; i <= endPage; i++) {
		                const btn = document.createElement("button");
		                btn.innerText = i;
		                btn.classList.add("page-btn");
		                if (i === currentPage) btn.classList.add("active");
		                btn.onclick = () => {
		                    currentPage = i;
		                    showPage(currentPage);
		                };
		                pagination.appendChild(btn);
		            }

		            // Next button
		            const nextBtn = document.createElement("button");
		            nextBtn.innerText = "Next";
		            nextBtn.disabled = (currentPage === totalPages);
		            nextBtn.onclick = () => {
		                if (currentPage < totalPages) {
		                    currentPage++;
		                    showPage(currentPage);
		                }
		            };
		            pagination.appendChild(nextBtn);
		        }

		        if (totalPages > 0) showPage(1);
    } catch (error) {
        console.error("Error fetching registration data:", error);
        tbody.innerHTML = "<tr><td colspan='4' style='text-align:center;'>Failed to load data</td></tr>";
    }
}


async function deleteFeedback(id) { 
	    if (!confirm("Are you sure you want to delete this record?")) return;

	    try {
			<!--console.log("id is", id);-->
	        <!--const url = "http://localhost:4049/student/delete/" + id;-->
			const url = "<%=request.getContextPath()%>/student/delete/" + id;
	        const response = await fetch(url, { method: 'DELETE' });
	        const result = await response.text();
	        alert(result);
			
			
			fetchRegistration();

	        

	    } catch (error) {
	        console.error("Error deleting feedback:", error);
	        alert("Failed to delete feedback.");
	    }
	}



window.onload = fetchRegistration();
</script>
 
</body>
</html>
 
 