<!--<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Exam Result</title>
</head>
<body>
<h2>${languageName} Exam Result</h2>
<p>Total Marks: ${marks}</p>
<a href="${pageContext.request.contextPath}/student/examScreen/mcq?languageName=${languageName}">Take Exam Again</a>
</body>
</html>



-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- MCQ Marks -->
<c:set var="mcqMarksRaw" value="${not empty marks ? marks : (not empty param.marks ? param.marks : 0)}" />
<c:set var="mcqMarks" value="${mcqMarksRaw + 0}" />

<!-- Coding Marks -->
<c:set var="codingMarksRaw" value="${not empty codingMarks ? codingMarks : (not empty param.codingMarks ? param.codingMarks : 0)}" />
<c:set var="codingMarks" value="${codingMarksRaw + 0}" />

<!-- Total Possible MCQ Marks (last index of MCQ) -->
<c:choose>
  <c:when test="${not empty mcq}">
    <c:set var="totalPossibleMarks" value="${fn:length(mcq)}" />
  </c:when>
  <c:otherwise>
    <c:set var="totalPossibleMarks" value="${not empty param.totalMarks ? param.totalMarks : 0}" />
  </c:otherwise>
</c:choose>

<!-- Total Possible Coding Marks (sum of easy=5, medium=10, hard=15) -->
<c:set var="totalPossibleCodingMarks" value="${not empty totalCodingMarks ? totalCodingMarks : (not empty param.totalCodingMarks ? param.totalCodingMarks : 30)}" />

<!-- Calculate percentages for MCQ and Coding separately -->
<c:set var="mcqPercentage" value="${totalPossibleMarks > 0 ? (mcqMarks * 100 / totalPossibleMarks) : 0}" />
<c:set var="codingPercentage" value="${totalPossibleCodingMarks > 0 ? (codingMarks * 100 / totalPossibleCodingMarks) : 0}" />

<!-- Calculate final score with 50% weight for MCQ and 50% for Coding -->
<c:set var="scorePercentage" value="${(mcqPercentage * 0.5) + (codingPercentage * 0.5)}" />

<!-- Pass/Fail logic -->
<c:choose>
  <c:when test="${scorePercentage >= 50}">
    <c:set var="status" value="Pass"/>
  </c:when>
  <c:otherwise>
    <c:set var="status" value="Fail"/>
  </c:otherwise>
</c:choose>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${languageName} Exam Result</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap');

  .python{
    font-family: "Roboto", sans-serif;
    font-size: 170%;
  }
  .head{
    display: flex;
    justify-content: center;
  }
  .container{
    width:70%;
    height:400px;
    margin-left: 18%;
    margin-top:7%;
  }
  .res{
    font-family:  "Roboto", sans-serif;
    font-size: 150%;
  }
  .container-1{
    display: flex;
    flex-direction: row;
    gap:10%;
  }
  .text{
    font-family:  "Roboto", sans-serif;
    font-weight: bold;
  }
  .container-2{
    padding-top:4.5%;
  }
  .btn{
    padding-top:6.9%;
  }
  .review{
    width:12%;
    padding:0.6%;
    background-color: rgba(13, 157, 83, 1);
    color:rgba(255, 255, 255, 1);
    font-family:  "Roboto", sans-serif;
    font-weight: bold;
    border-width: 0;
    border-radius: 5px;
    cursor: pointer;
  }
  .review a {
    text-decoration: none;
    color: white;
    font-size: 17px;
    display: block;
    width: 100%;
    height: 100%;
  }
</style>
</head>
<body>
  <header class="head">
    <h1 class="python">${languageName} Exam Result</h1>
  </header>

  <div class="container">
    <h1 class="res">Results</h1>
    <form action="online" method="post">
      <div class="container-1">
        <div>
          <p class="text">Score</p>
          <p class="text">
            <fmt:formatNumber value="${scorePercentage}" maxFractionDigits="2" />%
          </p>
        </div>
        <div>
          <p class="text">MCQ'S</p>
          <p>${mcqMarks}/${totalPossibleMarks}</p>
        </div>
        <div>
          <p class="text">Coding</p>
          <p class="text">${codingMarks}/${totalPossibleCodingMarks}</p>
        </div>
        <div>
          <p class="text">Language</p>
          <p class="text">${languageName}</p>
        </div>
      </div>

      <div class="container-2">
        <p class="text">
          Status: 
          <span style="${status == 'Pass' ? 'color:green;font-weight:bold;' : 'color:red;font-weight:bold;'}">
            ${status}
          </span>
        </p>
        <p class="text">Total Marks: ${mcqMarks + codingMarks}</p>
      </div>

      <div class="btn">
        <button class="review">
          <a href="${pageContext.request.contextPath}/student/rating">Next</a>
        </button>
      </div>
    </form>
  </div>
</body>
</html>