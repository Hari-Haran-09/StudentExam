<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Download MCQs Page</title>
 
<!-- Chart.js CDN for CandidateAnalytics -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
 
<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #f5f5f5;
    }
    .main-container {
        /* Full screen height */
        width: 100%;
        display: flex;
        flex-direction: column;
    }
    .header {
        height: 15vh; /* 15% of screen height */
        display: flex;
        align-items: center;
    }
    .content-wrapper {
        height: 83vh; /* 84% of screen height */
        display: flex;
        flex-direction: row;
    }
    .sidebar {
        width: 13%;
        background: #2178BD;
        padding: 1rem;
        color: white;
        /* height: 100%; */ /* Full height of content-wrapper */
        overflow-y: auto; /* Allow scrolling if sidebar content overflows */
    }
    .content {
        flex: 1;
        padding-left: 2rem;
        height: 100%; /* Full height of content-wrapper */
        overflow-y: auto; /* Allow scrolling for content */
    }
</style>
</head>
<body>
 
<div class="main-container">
 
    <!-- Dashboard/Header -->
    <div class="header">
        <jsp:include page="header.jsp" />
    </div>
 
    <div class="content-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">
            <jsp:include page="sidebar.jsp" />
        </div>
 
        <!-- Candidate Analytics Content -->
        <div class="content">
            <jsp:include page="downloadMcq.jsp" />
        </div>
    </div>
 
</div>
 
</body>
</html>
 