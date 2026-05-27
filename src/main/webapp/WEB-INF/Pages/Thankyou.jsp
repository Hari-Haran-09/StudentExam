<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thank you</title>
<style>
     .thank{
        font-family: "Roboto", sans-serif;;
     }
     .back-btn{
        margin-top:6%;
        /* display: flex;
        justify-content: center;
        align-items: center; */
     
     }
     .back{
        background-color: #0fb325;
        color:white;
        font-weight: bold;
        padding: 10px;
        border-width: 0;
        border-radius: 2%;
        border-radius: 5px;
        width: fit-content;
        cursor: pointer;
     }
    .image{
        margin-right: 15%;
        height:70px;
       
       
    }
    .thanku{
        padding-top:10%;
        padding-right: 3%;
        width: fit-content;
        margin: auto;
    }
	.div-img{
		    display: flex;
		    justify-content: flex-start;
		}
</style>
</head>
<body>
<form>
	<div class="div-img">
		  <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="200" height="70">
		</div>
    <div class = "thanku">
        <div style="width=200; height=70">
            <img class = "image" src = "${pageContext.request.contextPath}/images/Vector.png" alt = "thumbs">
        </div>
        <h1 class = "thank">Thank You For Your Participation</h1>
        <!-- <div class = "back-btn"> -->
			<button type="button" onclick="quitExam()" 

			        style="border: 2px solid gray; padding: 5px 10px; background-color: green;color:white">

			    Quit Exam
			</button>
			 

    <!-- </div> -->
    </div>
   
    </form>
</body>
	 
	 
	 
<script>
    function quitExam() {
        if (confirm("Are you sure want to quit the exam? This cannot be undone.")) {
            fetch("${pageContext.request.contextPath}/student/quit", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                }
            })
            .then(() => {
                window.location.href = "${pageContext.request.contextPath}/student/quit";
            })
            .catch(() => {
                window.location.href = "${pageContext.request.contextPath}/student/quit";
            });
        }
    }
</script>
 

</html>