package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.Mcq;

public interface McqRepository extends JpaRepository<Mcq, Long> {
	List<Mcq> findByLanguageName(String languageName);
}
