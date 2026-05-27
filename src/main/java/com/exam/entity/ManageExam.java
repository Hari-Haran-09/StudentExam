




package com.exam.entity;

import java.time.LocalTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="manage_exam")
public class ManageExam {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String languageName;
    private String meetingTime;
    private int totalMcq;
    private int eachMcqMark;
    private int totalCodingQuestion;
    private int easyLevelMarks;
    private int mediumLevelMarks;
    private int hardLevelMarks;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getLanguageName() {
		return languageName;
	}

	public void setLanguageName(String languageName) {
		this.languageName = languageName;
	}

	public String getMeetingTime() {
		return meetingTime;
	}

	public void setMeetingTime(String meetingTime) {
		this.meetingTime = meetingTime;
	}

	public int getTotalMcq() {
		return totalMcq;
	}

	public void setTotalMcq(int totalMcq) {
		this.totalMcq = totalMcq;
	}

	public int getEachMcqMark() {
		return eachMcqMark;
	}

	public void setEachMcqMark(int eachMcqMark) {
		this.eachMcqMark = eachMcqMark;
	}

	public int getTotalCodingQuestion() {
		return totalCodingQuestion;
	}

	public void setTotalCodingQuestion(int totalCodingQuestion) {
		this.totalCodingQuestion = totalCodingQuestion;
	}

	public int getEasyLevelMarks() {
		return easyLevelMarks;
	}

	public void setEasyLevelMarks(int easyLevelMarks) {
		this.easyLevelMarks = easyLevelMarks;
	}

	public int getMediumLevelMarks() {
		return mediumLevelMarks;
	}

	public void setMediumLevelMarks(int mediumLevelMarks) {
		this.mediumLevelMarks = mediumLevelMarks;
	}

	public int getHardLevelMarks() {
		return hardLevelMarks;
	}

	public void setHardLevelMarks(int hardLevelMarks) {
		this.hardLevelMarks = hardLevelMarks;
	}

	public ManageExam() {
		super();
	}
    
    
	
    
    
}