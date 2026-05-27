package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.exam.entity.ExamScreen;

public interface ExamScreenRepository extends JpaRepository<ExamScreen, Long> {

	ExamScreen findByEmailAndLanguageName(String email, String languageName);
	
	List<ExamScreen> findByNameContainingIgnoreCaseOrPhoneContaining(String name, String phone);
	
	@Query(value = """
			SELECT * 
			FROM exam_screen
			WHERE LOWER(name) LIKE LOWER(CONCAT('%', :query, '%'))
			   OR LOWER(email) LIKE LOWER(CONCAT('%', :query, '%'))
			   OR phone LIKE CONCAT('%', :query, '%')
			   OR DATE_FORMAT(login_time, '%Y-%m-%d') 
			      LIKE CONCAT('%', :query, '%')
			""", nativeQuery = true)
			List<ExamScreen> searchCandidate(@Param("query") String query);
}
