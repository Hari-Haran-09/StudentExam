package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.PhpMcq;

public interface PhpMcqRepository extends JpaRepository<PhpMcq, Long> {
	List<PhpMcq> findByLanguageName(String languageName);
	
	int countByLanguageName(String languageName);
}
