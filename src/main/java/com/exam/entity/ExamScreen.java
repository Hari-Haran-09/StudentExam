//package com.exam.entity;
//
//import jakarta.persistence.Entity;
//import jakarta.persistence.GeneratedValue;
//import jakarta.persistence.GenerationType;
//import jakarta.persistence.Id;
//import jakarta.persistence.Table;
//
//@Entity
//@Table(name="exam_screen")
//public class ExamScreen {
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long id;
//    private String languageName;
//    private String questionId;
//    private String optionName;
//    private Long marks;
//    
//    
//    public Long getMarks() {
//		return marks;
//	}
//
//	public void setMarks(Long marks) {
//		this.marks = marks;
//	}
//
//	public Long getId() {
//		return id;
//	}
//
//	public void setId(Long id) {
//		this.id = id;
//	}
//
//	public String getLanguageName() {
//		return languageName;
//	}
//
//	public void setLanguageName(String languageName) {
//		this.languageName = languageName;
//	}
//
//	public String getQuestionId() {
//		return questionId;
//	}
//
//	public void setQuestionId(String questionId) {
//		this.questionId = questionId;
//	}
//
//	public String getOptionName() {
//		return optionName;
//	}
//
//	public void setOptionName(String optionName) {
//		this.optionName = optionName;
//	}
//
//	public ExamScreen() {
//        super();
//    }
//}


//package com.exam.entity;
//
//import jakarta.persistence.*;
//
//@Entity
//@Table(name="exam_screen")
//public class ExamScreen {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long id;
//
//    private String languageName;
//
//    private String email;
//
//    @Column(length = 5000)
//    private String answers;
//
//    private Integer marks;
//    
//    private String Status;
//    
//    
//    private String name;
//    
//    private String phone;
//    
//    
//    private String gender;
//    
//    private String city;
//    
//    private String state;
//    
//    private String collegeName;
//    
//    private String role;
//    
//    private String course;
//    
//    private String experience;
//    
//    private String passedOut;
//    
//    private String specialization;
//    
//    
//
//    public String getSpecialization() {
//		return specialization;
//	}
//	public void setSpecialization(String specialization) {
//		this.specialization = specialization;
//	}
//	public String getPassedOut() {
//		return passedOut;
//	}
//	public void setPassedOut(String passedOut) {
//		this.passedOut = passedOut;
//	}
//	public String getExperience() {
//		return experience;
//	}
//	public void setExperience(String experience) {
//		this.experience = experience;
//	}
//	public String getCourse() {
//		return course;
//	}
//	public void setCourse(String course) {
//		this.course = course;
//	}
//	public String getRole() {
//		return role;
//	}
//	public void setRole(String role) {
//		this.role = role;
//	}
//	public String getCollegeName() {
//		return collegeName;
//	}
//	public void setCollegeName(String collegeName) {
//		this.collegeName = collegeName;
//	}
//	public String getCity() {
//		return city;
//	}
//	public void setCity(String city) {
//		this.city = city;
//	}
//	public String getState() {
//		return state;
//	}
//	public void setState(String state) {
//		this.state = state;
//	}
//	public String getGender() {
//		return gender;
//	}
//	public void setGender(String gender) {
//		this.gender = gender;
//	}
//	public String getPhone() {
//		return phone;
//	}
//	public void setPhone(String phone) {
//		this.phone = phone;
//	}
//	public String getName() {
//		return name;
//	}
//	public void setName(String name) {
//		this.name = name;
//	}
//	// getters and setters
//    public Long getId() { return id; }
//    public void setId(Long id) { this.id = id; }
//
//    public String getLanguageName() { return languageName; }
//    public void setLanguageName(String languageName) { this.languageName = languageName; }
//
//    public String getEmail() { return email; }
//    public void setEmail(String email) { this.email = email; }
//
//    public String getAnswers() { return answers; }
//    public void setAnswers(String answers) { this.answers = answers; }
//
//    public Integer getMarks() { return marks; }
//    public void setMarks(Integer marks) { this.marks = marks; }
//    
//    
//    
//
//    public String getStatus() {
//		return Status;
//	}
//	public void setStatus(String status) {
//		Status = status;
//	}
//	public ExamScreen() { super(); }
//}



/*package com.exam.entity;

import jakarta.persistence.*;

@Entity
@Table(name="exam_screen")
public class ExamScreen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String languageName;

    private String email;

    @Column(length = 5000)
    private String answers;

    private Integer marks;
    
    private String Status;
    
    // ADD THESE NEW FIELDS FOR CODING MARKS
    @Column(columnDefinition = "TEXT")
    private String codingAnswers;
    
    private Integer codingMarks ;
    
    private Integer totalMarks;
    
    private String name;
    
    private String phone;
    
    private String gender;
    
    private String city;
    
    private String state;
    
    private String collegeName;
    
    private String role;
    
    private String course;
    
    private String experience;
    
    private String passedOut;
    
    private String specialization;

    // Constructors
    public ExamScreen() { 
        super(); 
    }

    // Getters and Setters for all fields
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

    public String getEmail() { 
        return email; 
    }
    
    public void setEmail(String email) { 
        this.email = email; 
    }

    public String getAnswers() { 
        return answers; 
    }
    
    public void setAnswers(String answers) { 
        this.answers = answers; 
    }

    public Integer getMarks() { 
        return marks; 
    }
    
    public void setMarks(Integer marks) { 
        this.marks = marks; 
    }
    
    public String getStatus() {
        return Status;
    }
    
    public void setStatus(String status) {
        Status = status;
    }
    
    // NEW GETTERS AND SETTERS FOR CODING FIELDS
    public String getCodingAnswers() {
        return codingAnswers;
    }
    
    public void setCodingAnswers(String codingAnswers) {
        this.codingAnswers = codingAnswers;
    }
    
    public Integer getCodingMarks() {
        return codingMarks;
    }
    
    public void setCodingMarks(Integer codingMarks) {
        this.codingMarks = codingMarks;
    }
    
    public Integer getTotalMarks() {
        return totalMarks;
    }
    
    public void setTotalMarks(Integer totalMarks) {
        this.totalMarks = totalMarks;
    }
    
    // Existing getters and setters
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getPassedOut() {
        return passedOut;
    }
    
    public void setPassedOut(String passedOut) {
        this.passedOut = passedOut;
    }
    
    public String getExperience() {
        return experience;
    }
    
    public void setExperience(String experience) {
        this.experience = experience;
    }
    
    public String getCourse() {
        return course;
    }
    
    public void setCourse(String course) {
        this.course = course;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getCollegeName() {
        return collegeName;
    }
    
    public void setCollegeName(String collegeName) {
        this.collegeName = collegeName;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getState() {
        return state;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    @Override
    public String toString() {
        return "ExamScreen{" +
                "id=" + id +
                ", languageName='" + languageName + '\'' +
                ", email='" + email + '\'' +
                ", marks=" + marks +
                ", codingMarks=" + codingMarks +
                ", totalMarks=" + totalMarks +
                ", status='" + Status + '\'' +
                '}';
    }
  }
*/

package com.exam.entity;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name="exam_screen")
public class ExamScreen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String languageName;

    private String email;

    @Column(length = 5000)
    private String answers;

    private Integer marks;
    
    private String Status;
    
    // ADD THESE NEW FIELDS FOR CODING MARKS
    @Column(columnDefinition = "TEXT")
    private String codingAnswers;
    
    private Integer codingMarks ;
    
    private Integer totalMarks;
    
    private String name;
    
    private String phone;
    
    private String gender;
    
    private String city;
    
    private String state;
    
    private String collegeName;
    
    private String role;
    
    private String course;
    
    private String experience;
    
    private String passedOut;
    
    private String specialization;
 
    private LocalDateTime loginTime;

    public LocalDateTime getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(LocalDateTime loginTime) {
        this.loginTime = loginTime;
    }

    // Constructors
    public ExamScreen() { 
        super(); 
    }

    // Getters and Setters for all fields
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

    public String getEmail() { 
        return email; 
    }
    
    public void setEmail(String email) { 
        this.email = email; 
    }

    public String getAnswers() { 
        return answers; 
    }
    
    public void setAnswers(String answers) { 
        this.answers = answers; 
    }

    public Integer getMarks() { 
        return marks; 
    }
    
    public void setMarks(Integer marks) { 
        this.marks = marks; 
    }
    
    public String getStatus() {
        return Status;
    }
    
    public void setStatus(String status) {
        Status = status;
    }
    
    // NEW GETTERS AND SETTERS FOR CODING FIELDS
    public String getCodingAnswers() {
        return codingAnswers;
    }
    
    public void setCodingAnswers(String codingAnswers) {
        this.codingAnswers = codingAnswers;
    }
    
    public Integer getCodingMarks() {
        return codingMarks;
    }
    
    public void setCodingMarks(Integer codingMarks) {
        this.codingMarks = codingMarks;
    }
    
    public Integer getTotalMarks() {
        return totalMarks;
    }
    
    public void setTotalMarks(Integer totalMarks) {
        this.totalMarks = totalMarks;
    }
    
    // Existing getters and setters
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getPassedOut() {
        return passedOut;
    }
    
    public void setPassedOut(String passedOut) {
        this.passedOut = passedOut;
    }
    
    public String getExperience() {
        return experience;
    }
    
    public void setExperience(String experience) {
        this.experience = experience;
    }
    
    public String getCourse() {
        return course;
    }
    
    public void setCourse(String course) {
        this.course = course;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getCollegeName() {
        return collegeName;
    }
    
    public void setCollegeName(String collegeName) {
        this.collegeName = collegeName;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getState() {
        return state;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    @Override
    public String toString() {
        return "ExamScreen{" +
                "id=" + id +
                ", languageName='" + languageName + '\'' +
                ", email='" + email + '\'' +
                ", marks=" + marks +
                ", codingMarks=" + codingMarks +
                ", totalMarks=" + totalMarks +
                ", status='" + Status + '\'' +
                '}';
    }
}