package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.exam.entity.CodingQuestions;

public interface CodingRepository extends JpaRepository<CodingQuestions, Long> {
	// Find by language name
//    List<CodingQuestions> findByLanguageName(String languageName);
    
    // Find questions with specific test case count
    @Query("SELECT cq FROM CodingQuestions cq WHERE LENGTH(cq.easyInput) > 0")
    List<CodingQuestions> findQuestionsWithTestCases();
    
    // Count questions by language
    @Query("SELECT COUNT(cq) FROM CodingQuestions cq WHERE cq.languageName = :languageName")
    Long countByLanguageName(@Param("languageName") String languageName);
    
    // Find questions by language and difficulty level
    @Query("SELECT cq FROM CodingQuestions cq WHERE cq.languageName = :languageName AND cq.easyQuestion IS NOT NULL")
    List<CodingQuestions> findEasyQuestionsByLanguage(@Param("languageName") String languageName);

}
