package com.exam.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.ExamSet;

public interface ExamSetRepository
        extends JpaRepository<ExamSet, Long> {

    Optional<ExamSet> findByLanguageNameAndSetName( String languageName, String setName  );
}