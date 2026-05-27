<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Specialization</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap');
  body {
    font-family: "Roboto", sans-serif;
    margin: 0;
    background: #f8f8f8;
  }
  .h1 {
    font-family: "Roboto", sans-serif;  
    font-size: 130%;
  }
  .role-form {
    display: flex;
    flex-direction: row;
    gap: 12%;
  }
  .forms {
    margin-top: 2%;
  }
  .box {
    padding: 9px;
    padding-left: 60%;
    padding-top: 7%;
    box-shadow: 0px 0px 7px 0px #00000040;
    border-width: 0px;
  }
  .role-1 {
    font-family: "Roboto", sans-serif;  
    font-weight: bold;
  }
  input::placeholder {
    font-size: 90%;
    text-align: start;
  }
  .add, .update {
    color: white;
    font-weight: bold;
    border: none;
    padding: 10px 16px;
    border-radius: 5px;
    cursor: pointer;
    margin-left: 66%;
  }
  .add {
    background-color: rgba(33, 120, 189, 1);
  }
  .update {
    background-color: #145A86;
  }
  .add-btn {
    margin-bottom: 2%;
  }
  table {
    width: 100%;
  }
  th, td {
    text-align: center;
    padding: 8px;
  }
  .pagination {
    margin-top: 15px;
    display: flex;
    justify-content: center;
    gap: 8px;
  }
  .pagination button {
    border: none;
    background: #2178BD;
    color: white;
    padding: 6px 10px;
    border-radius: 4px;
    cursor: pointer;
  }
  .pagination button.active {
    background: #145A86;
  }
  .pagination button:disabled {
    background: #ccc;
    cursor: default;
  }
</style>
</head>
<body>
<div class="main-box">
<div class="add-role">
<h1 class="h1">Add Specialization</h1>
</div>
<form class="forms" id="roleForm" method="post" action="javascript:void(0)">
<p class="role-1">Specialization</p>
<div class="role-form">
<div>
<input type="text" class="box" id="roleName" name="departmentName" placeholder="Enter Your Specialization">
<input type="hidden" id="roleId" name="id">
</div>
<div class="add-btn">
<button type="submit" class="add" id="actionButton">Add</button>
</div>
</div>
</form>
</div>
<div style="padding-top:20px; padding-right: 20px; display:flex; flex-direction:column; align-items:center;">
<div style="width:100%; height:500px; overflow:auto;">
<table id="dataTable" style="border-collapse:separate; border-spacing:0 8px; max-width:600px;">
<thead style="background:#2178BD; color:white; font-size:13px; height:49px;">
<tr>
<th style="width:30px;">Sno</th>
<th style="width:200px;">Specialization</th>
<th style="width:90px;">Actions</th>
</tr>
</thead>
<tbody>
<!-- Populated dynamically -->
</tbody>
</table>
</div>
<div class="pagination" id="pagination"></div>
</div>
<script>
const rowsPerPage = 10;
let currentPage = 1;
let roles = [];

// Handle form submission for both add and update
document.getElementById("roleForm").addEventListener("submit", async (event) => {
  event.preventDefault();

  const roleName = document.getElementById("roleName").value.trim();
  const roleId = document.getElementById("roleId").value;
  const actionButton = document.getElementById("actionButton");

  if (!roleName) {
    alert("Please enter a specialization name");
    return;
  }

  try {
    let url, method, payload;
    if (roleId) {
      url = "<%=request.getContextPath()%>/student/editspecialization";
      method = "POST"; // Change to "PUT" if backend supports it
      payload = JSON.stringify({ id: parseInt(roleId), departmentName: roleName });
    } else {
      url = "<%=request.getContextPath()%>/student/savespecializations";
      method = "POST";
      payload = JSON.stringify({ departmentName: roleName });
    }

	const response = await fetch(url, {
			  method: method,
			  headers: {
			    "Content-Type": "application/json"
			  },
			  body: payload
			});

			// ✅ ADD THIS BLOCK (IMPORTANT)
			let data = {};
			const contentType = response.headers.get("content-type");

			if (contentType && contentType.includes("application/json")) {
			  data = await response.json();
			} else {
			  const text = await response.text();
			  data = { message: text };
			}

			// ✅ ERROR HANDLING
			if (!response.ok) {
			  alert(data.message || "Something went wrong");
			  return;
			}

			// ✅ SUCCESS
			alert(data.message || (roleId ? "Updated successfully" : "Added successfully"));
    document.getElementById("roleName").value = "";
    document.getElementById("roleId").value = "";
    actionButton.textContent = "Add";
    actionButton.classList.remove("update");
    actionButton.classList.add("add");
    await fetchRoles();
  } catch (error) {
    console.error(`Error ${roleId ? "updating" : "saving"} specialization:`, error);
    alert("An error occurred while processing your request. Please try again.");
  }
});

// Fetch specializations from backend
async function fetchRoles() {
  try {
    const response = await fetch("<%=request.getContextPath()%>/student/getSpecializations");
    if (!response.ok) throw new Error(`Failed to fetch specializations: ${response.status}`);

    roles = await response.json();
    roles = roles.filter(item => item && typeof item.id === 'number' && item.departmentName);
    renderTable();
  } catch (error) {
    console.error("Error fetching specializations:", error);
    const tbody = document.querySelector("#dataTable tbody");
    tbody.innerHTML = `<tr><td colspan="3" style="color:red;">Failed to load specializations</td></tr>`;
  }
}

// Render table with paginated data
function renderTable() {
  const tbody = document.querySelector("#dataTable tbody");
  tbody.innerHTML = "";

  const start = (currentPage - 1) * rowsPerPage;
  const end = start + rowsPerPage;
  const paginatedData = roles.slice(start, end);

  paginatedData.forEach(item => {
    if (typeof item.id !== 'number') return;

    const row = `
      <tr style="background:#fff; box-shadow:0px 0px 4px #00000020;">
        <td>\${item.id}</td>
        <td>\${item.departmentName}</td>
        <td>
          <button style="background:red; color:white; border:none; padding:4px 8px; border-radius:3px" onclick="deletespecialization(\${item.id})">Delete</button>
          <button style="background:#2178BD; color:white; border:none; padding:4px 8px; border-radius:3px" onclick="editspecialization(\${item.id})">Update</button>
        </td>
      </tr>
    `;
    tbody.innerHTML += row;
  });

  renderPagination();
}

// Render pagination controls
function renderPagination() {
  const totalPages = Math.ceil(roles.length / rowsPerPage);
  const paginationDiv = document.getElementById("pagination");
  paginationDiv.innerHTML = "";

  // Previous button
  const prevBtn = document.createElement("button");
  prevBtn.textContent = "Prev";
  prevBtn.disabled = currentPage === 1;
  prevBtn.onclick = () => {
    currentPage--;
    renderTable();
  };
  paginationDiv.appendChild(prevBtn);

  // Page numbers
  for (let i = 1; i <= totalPages; i++) {
    const pageBtn = document.createElement("button");
    pageBtn.textContent = i;
    pageBtn.classList.toggle("active", i === currentPage);
    pageBtn.onclick = () => {
      currentPage = i;
      renderTable();
    };
    paginationDiv.appendChild(pageBtn);
  }

  // Next button
  const nextBtn = document.createElement("button");
  nextBtn.textContent = "Next";
  nextBtn.disabled = currentPage === totalPages;
  nextBtn.onclick = () => {
    currentPage++;
    renderTable();
  };
  paginationDiv.appendChild(nextBtn);
}

// Delete specialization
async function deletespecialization(id) {
  if (typeof id !== 'number' || id <= 0) {
    alert("Invalid specialization ID");
    return;
  }

  if (!confirm("Are you sure you want to delete this record?")) return;
  console.log("id data is.........."+id);
  try {
    const url = "<%=request.getContextPath()%>/student/deletespecialization?id=" + id;
    console.log("url is....."+url)
    const response = await fetch(url, { method: "DELETE" });
    if (!response.ok) {
      throw new Error("Failed to delete specialization");
    }

    const responseText = await response.text();
    alert(responseText || "Specialization deleted successfully");
    await fetchRoles();
  } catch (error) {
    console.error("Error deleting specialization:", error);
    alert("Failed to delete specialization. Please try again.");
  }
}

// Edit specialization (autofill form)
function editspecialization(id) {
  if (typeof id !== 'number' || id <= 0) {
    alert("Invalid specialization ID");
    return;
  }
  console.log("edit id is......"+id);
  const role = roles.find(item => item.id === id);
  if (role) {
    document.getElementById("roleName").value = role.departmentName || '';
    document.getElementById("roleId").value = id;
    const actionButton = document.getElementById("actionButton");
    actionButton.textContent = "Update";
    actionButton.classList.remove("add");
    actionButton.classList.add("update");
    document.getElementById("roleName").focus();
  } else {
    alert("Specialization not found");
  }
}

// Initial load
fetchRoles();
</script>
</body>
</html>