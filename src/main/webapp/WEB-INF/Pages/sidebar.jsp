<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Menu</title>

<style>
  .menu {
    list-style: none;
    padding: 0;
    margin: 0;
    text-align: center;
  }

  .menu li {
    margin-bottom: 25px;
  }

  .menu li button {
    display: inline-block;
    text-decoration: none;
    color: white;
    padding: 5px 10px;
    font-size: 14.5px;
    border: none;
    background: #2178BD;
    cursor: pointer;
    transition: 0.3s;
  }

  .menu li button:hover {
    background: red;
    color: white;
    padding: 7px 12px;
    border-radius: 5px;
  }

  /* Submenu styles */
  .submenu {
    display: none;
    flex-direction: column;
    margin-top: 10px;
    align-items: center;
  }

  .submenu button {
    margin: 5px 0;
    background: #1E90FF;
    color: white;
    border: none;
    padding: 5px 10px;
    font-size: 13.5px;
    border-radius: 3px;
    transition: 0.3s;
  }

  .submenu button:hover {
    background: red;
    color: white;
  }
</style>
</head>

<body>
  <ul class="menu">
    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/dashboard'">
        Dashboard
      </button>
    </li>

    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/manageExam'">
        Manage Exams
      </button>
    </li>

    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/manageCandidates'">
        Manage Candidates
      </button>
    </li>

    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/candidatesPerformance'">
        Candidates Performance
      </button>
    </li>

    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/feedbackReports'">
        Feedback Reports
      </button>
    </li>

    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/updateQuestions'">
        Update Questions
      </button>
    </li>

    <li>
      <button onclick="toggleSettings()">Settings</button>
      <div id="settingsMenu" class="submenu">
        <button onclick="window.location.href='${pageContext.request.contextPath}/student/getallroles'">
          Add Role
        </button>
        <button onclick="window.location.href='${pageContext.request.contextPath}/student/getallcourses'">
          Add Course
        </button>
        <button onclick="window.location.href='${pageContext.request.contextPath}/student/getallspecializations'">
          Add Specialization
        </button>
        <button onclick="window.location.href='${pageContext.request.contextPath}/student/getpassoutyear'">
          Add Passedout Year
        </button>
        <button onclick="window.location.href='${pageContext.request.contextPath}/student/getalllanguages'">
          Add Language
        </button>
		<button onclick="window.location.href='${pageContext.request.contextPath}/student/getexperience'">
		          Experience
		        </button>
      </div>
    </li>

    <%-- Optional menu items (currently commented out) --%>
    <%-- 
    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/getallmcq'">
        Download MCQs
      </button>
    </li>

    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/ExamList'">
        Exam List
      </button>
    </li>

    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/codingQuestions'">
        Coding Question
      </button>
    </li>

    <li>
      <button onclick="window.location.href='${pageContext.request.contextPath}/student/mcqQuestions'">
        Mcq Question
      </button>
    </li>
    --%>
  </ul>

  <script>
    function toggleSettings() {
      const submenu = document.getElementById("settingsMenu");
      submenu.style.display = (submenu.style.display === "flex") ? "none" : "flex";
    }
  </script>
</body>
</html>
