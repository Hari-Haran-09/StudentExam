<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Feedback Reports</title>
<style>
        .h1 {
            font-family: "Roboto", sans-serif;
            font-size: 135%;
        }

        .feedback-container {
            display: flex;
            flex-direction: column;
            width: 79%;
            gap: 20px;
            box-sizing: border-box;
        }

        .big-box {
            padding:1%;
            box-shadow: 1px 1px 10px 0px #00000040;
            background-color: #ffffff;
            border-radius: 8px;
            box-sizing: border-box;
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .feedback-info {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .name, .feed {
            font-size: 100%;
            font-family: "Roboto", sans-serif;
            margin: 0;
            line-height: 1.5;
        }
		.role{
			line-height: 1.5;
			font-size: 100%;
		}

        .box1 {
            margin-bottom: 20px;
            padding: 1%;
            border-radius: 4px;
        }

        .rating {
            color: gray;
            font-size: 1.2em;
        }

        .date {
            font-family: "Roboto", sans-serif;
            font-size: 0.9em;
            color: #757575;
        }
		.parent{
			/*display: flex;*/
			padding-right: 10px;
			justify-content: space-between;
			align-items: center;
			text: center;
			/*gap: 15%;*/
			width: 70%;
		}
</style>
</head>
<body>
    <div class="main-box">
        <div class="add-header">
            <h1 class="h1">Feedback Reports</h1>
        </div>
        
        <div class="feedback-container">
            
        </div>
    </div>

    <script>
    async function loadFeedback() {
        try {
            <!--const response = await fetch("http://localhost:4049/student/feedback");-->
			const response = await fetch("<%=request.getContextPath()%>/student/feedback");
            const feedbackList = await response.json();
            <!--console.log("data is:", feedbackList);-->

            const container = document.querySelector(".feedback-container");
            container.innerHTML = "";

            // Convert data into HTML using map
            const feedbackHTML = feedbackList.map(fb => {
                const stars = "★".repeat(fb.rate) + "☆".repeat(5 - fb.rate);
				const formattedDate = fb.dateTime ? fb.dateTime.split("T")[0] : "";

                return `
                    <div class="big-box">
						<div style="display: flex; justify-content: end; cursor: pointer"><button style="cursor: pointer" onclick="deleteFeedback(\${fb.id})">Delete</button></div>
                        <div class="box1">
                            <div class="feedback-header">
                                <div class="parent">
									<h1 class="name">Name: \${fb.name}</h1>
																	<h1 class="role">Role: \${fb.role}</h1>
								</div>
                                <div class="feedback-info">
                                    <div class="rating">\${stars}</div>
									<div class="dateTime">\${formattedDate}</div>
                                </div>
                            </div>
                            <h1 class="feed">Feedback: \${fb.feedback}</h1>
                        </div>
                    </div>
                `;
            }).join(""); 

            container.innerHTML = feedbackHTML;

        } catch (error) {
            console.error("Error fetching feedback:", error);
        }
    }
	async function deleteFeedback(id) { 
	    if (!confirm("Are you sure you want to delete this feedback?")) return;

	    try {
			<!--console.log("id is", id);-->
	        <!--const url = "http://localhost:4049/student/feedback/" + id;-->
			const url = "<%=request.getContextPath()%>/student/feedback/" + id;
	        const response = await fetch(url, { method: 'DELETE' });
	        const result = await response.text();
	        alert(result);
			loadFeedback();

	        

	    } catch (error) {
	        console.error("Error deleting feedback:", error);
	        alert("Failed to delete feedback.");
	    }
	}

    window.onload = loadFeedback;
    </script>

</body>
</html>
