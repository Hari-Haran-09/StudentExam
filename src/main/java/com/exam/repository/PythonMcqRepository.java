package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.PythonMcq;

public interface PythonMcqRepository extends JpaRepository<PythonMcq, Long> {
	List<PythonMcq> findByLanguageName(String languageName);
	
	int countByLanguageName(String languageName);
}
