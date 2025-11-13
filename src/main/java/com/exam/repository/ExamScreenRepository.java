package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.ExamScreen;

public interface ExamScreenRepository extends JpaRepository<ExamScreen, Long> {

	ExamScreen findByEmailAndLanguageName(String email, String languageName);
}
