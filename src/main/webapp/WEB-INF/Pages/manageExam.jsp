<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Exam</title>
<style>
.image{
     width: 3%;
    position: absolute;
    top: 18px;          
    right: 10px;        
    padding: 0;         
    margin: 0;
}
.box1.box {
  width: 100%;
  height:80px;
  background-color: rgb(255,255,255,1);
  border-radius: 10px;
  box-shadow: 1px 1px 10px 10px rgba(0,0,0,0.25);
}
.manage-header {
  /* display: flex; */
  /* justify-content: space-between; */
  /* align-items: center;  */           
  /* margin: 20px 0; */
  /* padding: 0 20px; */
}
.add-lang-btn {
  background: #2176bb;
  color: #fff;
  border: none;
  padding: 1px 20px;
  border-radius: 5px;
  font-size: 13px;
  cursor: pointer;
}
.mcq-btn-wrapper {
  display: flex;
  justify-content: flex-end;  
  align-items: center;
  gap: 5px;                  
  margin-right:35%;  
  margin-top:20%;          
}
.mcq-btn-wrapper-1 {
  display: flex;
  justify-content: flex-end;  
  align-items: center;
  gap: 5px;                  
  padding-bottom:80%;           
}
.h1{
  /* margin-left:17%; */
   font-family:"Roboto", sans-serif ;
   font-size: 130%;
   margin-bottom: 1%;
}
.row{
  display: flex;
  flex-direction: column;
   flex-wrap: wrap;
  justify-content: center;
  margin-left: 50%;
}
.manage {
  margin-top: 100px;  
  text-align: center;
}
.forms-rows{
  margin-left: 19%;
  display: flex;
  flex-direction: row;
  gap : 1px;
}
.ham{
  width:23.39px;
  height:26.333261489868164px;
  margin-left:18%;
  padding-top: 2%;
  position:absolute;
}
.bar{
    padding-top: 1.8%;
  padding-right:12%;
}
.forms{
  /* padding-left: 18%; */
  /* padding-top: 3%; */
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-direction: row;
  /* border: 2px solid red; */
  width: 79%;
}
.text{
    font-family:"Roboto", sans-serif ;
   font-weight: bold;
   font-size: 80%;
}
.text-1{ text-align: center; }
.place{
    /* padding-left: 10% ; */
    width: 98%;
    box-shadow: 1px 1px 10px 0px #00000040;
    border-width: 0px;
    border-radius: 5px;
    padding-top: 7%;
    padding-bottom: 7%;
    /* padding-top: 2%; */
    /* padding-bottom: 6%; */
    /* margin-top: 3.9%; */
    text-align: start;
}
.time{
    /* padding-left: 10% ; */
    width: 100%;
    box-shadow: 1px 1px 10px 0px #00000040;
    border-width: 0px;
    border-radius: 5px;
    padding-top: 10.7%;
    padding-bottom: 10%;
    /* font-size:66%; */
    text-align: center;
}
.move{
display: flex;
/* flex-direction: row; */
/* padding-top:9%; */
/* gap:5%; */
}
.h{
  padding-top: 7.5%;
   font-family:"Roboto", sans-serif ;
   font-weight: bold;
}
.mcq{
   /* padding-left: 10% ; */
    width: 95%;
    box-shadow: 1px 1px 10px 0px #00000040;
    border-width: 0px;
    border-radius: 5px;
    /* margin-top:8%; */
    text-align: center;
    color:gray;
    outline:none;
}
/* .mcq{ padding-top: 18%; padding-bottom: 9.5%; margin-top:10%; } */
/* .mcq-1{ padding-top: 15%; padding-bottom: 5.9%; } */
.parent{
  display: flex;
  justify-content: space-evenly;
  gap: 9px;
  width: 300px;
  margin-right: 60px;
}
.parent1{
    display: flex;
    /*border: 2px solid red;*/
    width: 53%;
    margin-top: 20px;
    justify-content: space-between;
    padding-left: 3px;
}
.parent2{
    display: flex;
    /* border: 2px solid red; */
    width: 39%;
    margin-top: 20px;
    justify-content: space-between;
    padding-left: 3px;
}
.add-mv-btn, .add-down-btn{
    width: fit-content;
    border: none;
    padding: 11px;
    border-radius: 5px;
    color: #fff;
    cursor: pointer;
}
.add-mv-btn{ background: #2176bb; }
.add-down-btn{ background: orangered; }
.place::placeholder{ text-align:start; }
.code {
  /* margin-top: 30px; */
  /* margin-left: 19%; */        
  display: flex;
  justify-content: space-between;
  /* align-items: flex-start; */
  width: 73%;         
}
.code div {
  display: flex;
  margin-right: 3%;
  /* border: 2px solid blue; */
  flex-direction: column;  
  align-items: flex-start;
}
.code p {
  font-weight: bold;
  font-size: 83%;
  font-family: "Roboto", sans-serif;
  margin-bottom: 6px;     
}
.code input {
  width: 80%;           
  /* height: 40px; */
  /* padding: 4px ; */
  padding-top: 15px;
    padding-bottom: 15px;
  font-size: 14px;
  box-shadow: 1px 1px 6px 0px #00000040;
  border: none;
  border-radius: 6px;
}
.place-2, .place-3, .place-4, .place-5{
    padding-left: 10% ;
    width: 100px;
    box-shadow: 1px 1px 10px 0px #00000040;
    border-width: 0px;
    border-radius: 5px;
    margin-top: 3.9%;
    text-align: center;
    color:gray;
    outline:none;
}
.place-2{ padding-top: 9%; padding-bottom: 6%; }
.place-3{ padding-top: 14.5%; padding-bottom: 6%; }
.place-4{ padding-top: 9%; padding-bottom: 9%; margin-top: 3%; }
.place-5{ padding-top: 9%; padding-bottom: 12.1%; }
.terms{
    text-align: center;
    font-family: "Roboto", sans-serif;
    padding-top: 3%;
    font-size: 60%;
}
.save{
/* border: 2px solid red; */
width: 65%;
display: flex;
justify-content: end;
margin-top: 5%;
}
.save-btn{
    width:13%;
    background-color: rgba(0, 187, 25, 1);
    color:#fff;
    font-weight: bold;
    border-radius: 10px;
    padding-top: 9px;
    padding-bottom: 9px;
    font-size: 15px;
    outline: none;
    border: none;
	cursor: pointer;
}
</style>
</head>
<body>
 
  <div class="stack_boxes.box">
  
  <div class="manage-header" style="display: flex; width: 95%; justify-content: space-between">
    <h1 class="h1">Manage Exams</h1>
    <button type="button" class="add-lang-btn" style="margin-right: 30px" onclick="window.location.href='${pageContext.request.contextPath}/student/ExamList'">Exam List</button>
  </div>
 
  <!-- ✅ Single form for everything -->
  <form id="manageexamform" action="manageExam" method="post" style="width: 100%; margin-top: 3%">

    <!-- Language Input -->
    <div class="forms">
      <div class="forms-1" style="width: 23%">
        <p class="">Programming Language</p>
        <!--<input class="place" type="text" placeholder="Select the language" id="languageName" name="languageName">-->
		<select class="place" id="languageName" name="languageName" required class="select">
								  <option value="" disabled selected>Select Coding Language</option>
								</select>
      </div>

      <!-- Time Duration -->
      <div class="forms-1" style="width: 13%">
        <p class="text-1">Time Duration</p>
        <div class="move" style="">
          <!-- <label class="h">Time</label> -->
          <input class="time" type="number" value="" name="meetingTime" required>
          <!-- <span>:</span>
          <input class="time" type="time" min="0" max="59" value="0" name="minutes">
          <label class="h">M</label>
          <input class="time" type="number" min="0" max="59" value="0" name="seconds1">
          <span>:</span>
          <input class="time" type="number" min="0" max="59" value="0" name="seconds2"> -->
        </div>
      </div>

      <!-- MCQs Section -->
      <div class="parent">
        <div class="forms-1" style="width: 43%">
          <p class="text-3">Total MCQs</p>
          <input style="padding-top: 12%; padding-bottom: 13%;" class="mcq" type="number" placeholder="" name="totalMcq" required oninput="this.value = this.value.replace(/[^0-9]/g, '')">
        </div>
        <div class="forms-1" style="width: 47%">
          <p class="text-3">Each MCQ Marks</p>
          <input style="padding-top: 12%; padding-bottom: 12%;" class="mcq" type="number" placeholder="" name="eachMcqMark" required oninput="this.value = this.value.replace(/[^0-9]/g, '')">
        </div>
      </div>
    </div>

    <div class="parent1">
      <div class="manage-header-1">
        <button type="button" class="add-mv-btn" onclick="window.location.href='${pageContext.request.contextPath}/student/mcqQuestions'">+Add MCQ</button>
      </div>
      <div class="download">
        <button type="button" class="add-down-btn" onclick="window.location.href='${pageContext.request.contextPath}/student/getallmcq'">Download MCQ’S with answer</button>
      </div>
	  <div class="download">
	          <button type="button" class="add-down-btn" onclick="window.location.href='${pageContext.request.contextPath}/student/getallMcqWithoutAnswer'">Download MCQ’S without answer</button>
	        </div>
    </div>

    <!-- Coding Questions Section -->
    <div class="code" style="margin-top: 40px">
      <div class="code-1">
        <p>Total Coding Questions</p>
        <input class="place-2" type="number" name="totalCodingQuestion" required oninput="this.value = this.value.replace(/[^0-9]/g, '')">
      </div>
      <div class="code-2">
        <p>Easy Level Marks</p>
        <input class="place-3" type="number" name="easyLevelMarks" required oninput="this.value = this.value.replace(/[^0-9]/g, '')">
      </div>
      <div class="code-3">
        <p>Medium Level Marks</p>
        <input class="place-4" type="number" name="mediumLevelMarks" required oninput="this.value = this.value.replace(/[^0-9]/g, '')">
      </div>
      <div class="code-4">
        <p>Hard Level Marks</p>
        <input class="place-5" type="number" name="hardLevelMarks" required oninput="this.value = this.value.replace(/[^0-9]/g, '')">
      </div>
    </div>

    <div class="parent2">
      <div class="manage-header-1">
        <button type="button" class="add-mv-btn" onclick="window.location.href='${pageContext.request.contextPath}/student/codingQuestions'">+Add Coding Questions</button>
      </div>
      <div class="download">
        <button type="button" class="add-down-btn" onclick="window.location.href='${pageContext.request.contextPath}/student/getallcoding'">Download Coding Question Paper</button>
      </div>
    </div>

    <!-- Save Button -->
    <div class="save">
      <button type="submit" class="save-btn">Save</button>
    </div>

  </form>
  <!-- ✅ End of single form -->

  <!-- <div class="terms">
        By logging in, you agree to our Privacy Policy & Terms of Use
  </div> -->
   
  </div>
  <!--<script>
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
		    })
		    .catch(err => console.error("Error fetching languages:", err));
			
			document.getElementById("manageexamform").addEventListener("submit", function (e) {
				    const confirmation = confirm("Do you want to post the data?");
				    if (!confirmation) {
				        e.preventDefault();
				    }
				});
  </script>-->
  
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
      		    })
      		    .catch(err => console.error("Error fetching languages:", err));
   
      	document.getElementById("manageexamform").addEventListener("submit", function (e) {
      		    const confirmation = confirm("Do you want to post the data?");
      		    if (!confirmation) {
      		        e.preventDefault();
      		    }
      		});
   
      	// Override the onclick behavior - Check MCQ limit before navigating
      	const addMcqBtn = document.querySelector('.add-mv-btn');
      	
      	// Remove the inline onclick attribute
      	addMcqBtn.removeAttribute('onclick');
      	
      	// Add our own click handler
      	addMcqBtn.addEventListener('click', function(e) {
      		e.preventDefault();
      		e.stopPropagation();
   
      		const languageName = document.getElementById("languageName").value;
   
      		if (!languageName) {
      			alert("Please select a programming language first!");
      			return;
      		}
   
      		// Fetch the MCQ limit and current count for the selected language
      		fetch("<%=request.getContextPath()%>/student/checkMcqLimit?languageName=" + encodeURIComponent(languageName))
      			.then(res => res.json())
      			.then(data => {
      				if (data.limitReached) {
      					alert("MCQ limit reached for: " + languageName + ". So, You cannot add more MCQs.");
      					// Do nothing - stay on current page
      				} else {
      					// Navigate to MCQ questions page
      					window.location.href = '${pageContext.request.contextPath}/student/mcqQuestions?languageName=' + encodeURIComponent(languageName);
      				}
      			})
      			.catch(err => {
      				console.error("Error checking MCQ limit:", err);
      				alert("Error checking MCQ limit. Please try again.");
      			});
      	});
    </script>
</body>
</html>
