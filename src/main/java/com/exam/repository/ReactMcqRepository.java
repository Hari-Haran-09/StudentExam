package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.ReactMcq;

public interface ReactMcqRepository extends JpaRepository<ReactMcq, Long> {
	List<ReactMcq> findByLanguageName(String languageName);
}
