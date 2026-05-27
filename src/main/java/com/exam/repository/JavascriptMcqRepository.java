package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.JavascriptMcq;

public interface JavascriptMcqRepository extends JpaRepository<JavascriptMcq, Long> {
	List<JavascriptMcq> findByLanguageName(String languageName);
	
	int countByLanguageName(String languageName);
}
