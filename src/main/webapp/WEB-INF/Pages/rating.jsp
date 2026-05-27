<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Feedback Rating</title>
<style>
	.div-img{
	    display: flex;
	    justify-content: flex-start;
	}
    .manage-header {
        display: flex;
        justify-content: space-between;
        align-items: center;        
        margin: 20px 0;
        padding: 0 20px;
    }

    .h1 {
        margin-left:17%;
        font-family:"Roboto", sans-serif;
        font-size: 170%;
        margin-top: 7.6%;
        margin-right: 30%;
    }

    .question-box {
        width: 696px;
        height: 150px;
        box-shadow: 1px 1px 10px 0px #00000040;
        font-family: "Roboto", sans-serif;
        border: none;
        border-radius: 5px;
        margin-top: 1%;
        padding: 4%;
        font-size: 16px;
        resize: none;
        outline: none;
        box-sizing: border-box;
    }

    .hh {
        margin-left: 18%;
        margin-top: 3%;
    }

    .btn {
        margin-left: 18%;
        margin-top: 3%;
    }

    .rating {
        margin-left: 18%;
        display: flex;
        flex-direction: row;
        gap: 4%;
		font-size: 2.5em;
        color: gray;
        cursor: pointer;
    }

    .star.active {
        color: gold;
    }

    .star {
        height: 50px;
        width: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    input::placeholder {
        font-size: 70%;
        text-align: start;
    }

    .sub {
        background-color: rgba(252, 10, 10, 1);
        font-family: "Roboto", sans-serif;
        color: rgba(255, 255, 255, 1);
        padding-right: 5%;
        padding-left: 5%;
        border-width: 0;
        padding-top: 0.7%;
        padding-bottom: 0.7%;
        border-radius: 5%;
        cursor: pointer;
    }
</style>
</head>
<body>

<form id="ratingForm" action="${pageContext.request.contextPath}/student/rating" method="post">
	<div class="div-img">
	  <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70">
	</div>
    <div class="bar">
        <div class="manage-header">
            <h1 class="h1">Rate Us?</h1>
        </div>

        <div class="rating">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
        </div>

        <!-- Hidden input to store star rating -->
        <input type="hidden" name="rate" id="rateInput">

        <div class="hh">
            <input type="text" class="question-box" name="feedback" id="feedback" required placeholder="Enter Your Feedback">
        </div>

        <div class="btn">
            <button type="submit" class="sub">Submit</button>
        </div>
    </div>
</form>

<script>
const stars = document.querySelectorAll('.star');
let selectedRating = 0;

// Star click logic
stars.forEach((star, index) => {
    star.addEventListener('click', () => {
        stars.forEach(s => s.classList.remove('active'));
        for (let i = 0; i <= index; i++) {
            stars[i].classList.add('active');
        }
        selectedRating = index + 1;
        document.getElementById('rateInput').value = selectedRating;
    });
});

// Validation before submitting form
document.getElementById('ratingForm').addEventListener('submit', function(e) {
    const feedback = document.getElementById('feedback').value.trim();
    const rating = document.getElementById('rateInput').value;

    if (rating === "" || rating === "0") {
        e.preventDefault();
        alert("Please select a star rating before submitting.");
        return;
    }

    if (feedback === "") {
        e.preventDefault();
        alert("Please enter your feedback before submitting.");
        return;
    }
});
</script>

</body>
</html>
