package com.exam.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.ManageExam;

public interface ManageExamRepository extends JpaRepository<ManageExam, Long> {

	List<ManageExam> findByLanguageName(String languageName);
}
