<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Coding Display</title>
<style>
    /* Popup Modal Styles */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
    }
    
    .modal-content {
        background-color: white;
        margin: 5% auto;
        padding: 20px;
        border-radius: 10px;
        width: 80%;
        max-width: 900px;
        max-height: 80vh;
        overflow-y: auto;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }
    
    .close {
        color: #aaa;
        float: right;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
    }
    
    .close:hover {
        color: black;
    }
    
    .modal-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }
    
    .modal-table th, .modal-table td {
        border: 1px solid #ddd;
        padding: 12px;
        text-align: left;
    }
    
    .modal-table th {
        background-color: #2178BD;
        color: white;
    }
    
    .modal-table tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    
    .loading {
        text-align: center;
        padding: 20px;
        font-style: italic;
        color: #666;
    }
    
    /* Pagination Styles */
    .pagination {
        margin-top: 20px;
        display: flex;
        justify-content: center;
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
    
    .pagination button:hover:not(.active):not(:disabled) {
        background-color: #f1f1f1;
    }
    
    .pagination button:disabled {
        cursor: not-allowed;
        opacity: 0.6;
    }
</style>
</head>
<body>
    <div id="codingModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2 style="text-align: center; color: #2178BD; margin-bottom: 20px;">Coding Answers</h2>
            <div id="modalLoading" class="loading">Loading coding answers...</div>
            <div id="modalContent" style="display: none;">
                <table class="modal-table">
                    <thead>
                        <tr>
                            <th style="width: 10%;">SL</th>
                            <th style="width: 60%;">Answer</th>
                        </tr>
                    </thead>
                    <tbody id="modalTableBody"></tbody>
                </table>
            </div>
            <div id="modalError" style="display: none; text-align: center; color: red; padding: 20px;">
                Failed to load coding answers.
            </div>
        </div>
    </div>

    <div style="padding:20px; display:flex; flex-direction:column; align-items:center; margin: auto">
        
        <div style="width:95.3%; margin: auto; padding-bottom: 10px; display: flex; justify-content: flex-end; align-items: center; gap: 5px; margin-right: 25px;">
            <input type="text" id="searchInput" placeholder="Search name or phone..." 
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

        <div style="width:95.3%; height:500px; overflow:auto">
            <table id="dataTable" style="border-collapse:separate; border-spacing:0 8px; min-width:1100px;">
                <thead style="background:#2178BD; color:white; font-size:13px; height: 49px">
                    <tr>
                        <th style="width:5%;text-align:center; padding:4px;">SL</th>
                        <th style="width:25%; text-align:center; padding:4px;">Name</th>
                        <th style="width:15%; text-align:center; padding:4px;">Email</th>
                        <th style="width:10%; text-align:center; padding:4px;">Coding Answers</th>
						<th style="width:10%; text-align:center; padding:4px;">Action</th>
                    </tr>
                </thead>
                <tbody id="studentTableBody"></tbody>
            </table>
        </div>
        <div class="pagination" id="pagination"></div>
    </div>

    <script>
        const modal = document.getElementById("codingModal");
        const closeBtn = document.querySelector(".close");
        const modalLoading = document.getElementById("modalLoading");
        const modalContent = document.getElementById("modalContent");
        const modalError = document.getElementById("modalError");
        const modalTableBody = document.getElementById("modalTableBody");
        const rowsPerPage = 10;
        const tbody = document.getElementById("studentTableBody");
        const pagination = document.getElementById("pagination");

        closeBtn.onclick = () => modal.style.display = "none";
        window.onclick = (event) => { if (event.target == modal) modal.style.display = "none"; };

        function renderData(data) {
            if (!data || data.length === 0) {
                tbody.innerHTML = "<tr><td colspan='5' style='text-align: left; padding: 20px; color: grey;'>No records found.</td></tr>";
                pagination.innerHTML = "";
                return;
            }

            tbody.innerHTML = data.map((student, index) => `
                <tr>
                    <td style="width:30px; text-align:center; padding:4px;">\${index + 1}</td>
                    <td style="width:290px; text-align:center; padding:4px;">\${student.name || 'null'}</td>
                    <td style="width:290px; text-align:center; padding:4px;">\${student.email || 'null'}</td>
                    <td style="width:90px; text-align:center; padding:4px;">
                        <button style="border: 2px solid gray; width: fit-content; padding: 7px 15px; border-radius: 10px; cursor:pointer;" 
                                onclick="viewCodingAnswers(\${student.id})">View</button>
                    </td>
                    <td style="width:20px; text-align:center; padding:4px;">
                        <button style="cursor: pointer; color: red; background:none; border:none;" onclick="deleteCodingDisplay(\${student.id})">Delete</button>
                    </td>
                </tr>
            `).join("");

            setupPagination();
        }

        async function searchCandidates() {
            const query = document.getElementById("searchInput").value.trim();
            if (!query) { alert("Please enter a name or phone number"); return; }
            try {
                const response = await fetch(`<%=request.getContextPath()%>/student/searchcandidate?query=\${encodeURIComponent(query)}`);
                const searchData = await response.json();
                renderData(searchData);
            } catch (error) { console.error("Search error:", error); }
        }

        async function fetchRegistration() {
            document.getElementById("searchInput").value = "";
            try {
                const response = await fetch("<%=request.getContextPath()%>/student/all-results");
                const registerData = await response.json();
                renderData(registerData);
            } catch (error) {
                tbody.innerHTML = "<tr><td colspan='5' style='text-align:center;'>Failed to load data</td></tr>";
            }
        }

        function setupPagination() {
            const rows = tbody.querySelectorAll("tr");
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

        async function viewCodingAnswers(id) {
            try {
                modalLoading.style.display = "block";
                modalContent.style.display = "none";
                modalError.style.display = "none";
                modal.style.display = "block";
                const response = await fetch("<%=request.getContextPath()%>/student/getCodingById?id=" + id);
                const codingData = await response.json();

                if (codingData && codingData.codingAnswers) {
                    const answersArray = JSON.parse(codingData.codingAnswers);
                    modalTableBody.innerHTML = answersArray.map((item, index) => `
                        <tr>
                            <td style="text-align:center; vertical-align:top;">\${index + 1}</td>
                            <td class="answer-cell">
                                <strong>Level:</strong> \${item.level || 'N/A'}<br><br>
                                <strong>Code:</strong><br>
                                <pre style="background: #f5f5f5; padding: 15px; border-radius: 5px; overflow-x: auto; font-family: 'Courier New', monospace;">\${escapeHtml(item.code)}</pre>
                                <br><strong>Output:</strong><br>
                                <pre style="background: #f0f0f0; padding: 15px; border-radius: 5px;">\${escapeHtml(item.output)}</pre>
                            </td>
                        </tr>
                    `).join("");
                }
                modalLoading.style.display = "none";
                modalContent.style.display = "block";
            } catch (error) {
                modalLoading.style.display = "none";
                modalError.style.display = "block";
            }
        }

        async function deleteCodingDisplay(id) { 
            if (!confirm("Are you sure?")) return;
            try {
                await fetch("<%=request.getContextPath()%>/student/deleteCodingById?id=" + id, { method: 'DELETE' });
                fetchRegistration();
            } catch (error) { alert("Delete failed"); }
        }

        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        fetchRegistration();
    </script>
</body>
</html>