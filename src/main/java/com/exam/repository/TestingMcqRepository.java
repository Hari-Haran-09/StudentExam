package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.TestingMcq;

public interface TestingMcqRepository extends JpaRepository<TestingMcq, Long> {
	List<TestingMcq> findByLanguageName(String languageName);
	
	int countByLanguageName(String languageName);
}

