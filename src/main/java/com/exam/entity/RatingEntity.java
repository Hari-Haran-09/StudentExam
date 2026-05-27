package com.exam.entity;
 
 
import java.time.LocalDateTime;
 
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
 
@Entity
public class RatingEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long id;
private Long rate;
private String feedback;
private LocalDateTime dateTime;
private String name;
private String email;
private String role;
 
public String getRole() {
	return role;
}
public void setRole(String role) {
	this.role = role;
}
public String getEmail() {
	return email;
}
public void setEmail(String email) {
	this.email = email;
}
public LocalDateTime getDateTime() {
	return dateTime;
}
public void setDateTime(LocalDateTime dateTime) {
	this.dateTime = dateTime;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public Long getId() {
	return id;
}
public void setId(Long id) {
	this.id = id;
}
public Long getRate() {
	return rate;
}
public void setRate(Long rate) {
	this.rate = rate;
}
public String getFeedback() {
	return feedback;
}
public void setFeedback(String feedback) {
	this.feedback = feedback;
}
public RatingEntity() {
	super();
}
 
}