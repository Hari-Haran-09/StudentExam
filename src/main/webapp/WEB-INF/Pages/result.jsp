
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- ========================= -->
<!-- MCQ MARKS -->
<!-- ========================= -->

<c:set var="mcqMarks"
       value="${not empty marks ? marks : 0}" />

<!-- ========================= -->
<!-- CODING MARKS -->
<!-- ========================= -->

<c:set var="codingMarks"
       value="${not empty codingMarks ? codingMarks : 0}" />

<!-- ========================= -->
<!-- TOTAL MCQ QUESTIONS -->
<!-- ========================= -->

<c:set var="totalPossibleMarks"
       value="${not empty totalPossibleMarks ? totalPossibleMarks : 0}" />

<!-- ========================= -->
<!-- TOTAL CODING MARKS -->
<!-- ========================= -->

<c:set var="totalPossibleCodingMarks"
       value="${not empty totalPossibleCodingMarks ? totalPossibleCodingMarks : 0}" />

<!-- ========================= -->
<!-- SCORE PERCENTAGE -->
<!-- ========================= -->

<c:set var="scorePercentage"
       value="${not empty scorePercentage ? scorePercentage : 0}" />

<!-- ========================= -->
<!-- STATUS -->
<!-- ========================= -->

<c:set var="status"
       value="${not empty status ? status : 'FAILED'}" />
       
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