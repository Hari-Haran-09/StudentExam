package com.exam.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.Language;

public interface LanguageRepository extends JpaRepository<Language, Long> {
	
	   Optional<Language> findByLanguageName(String languageName);

	   boolean existsByLanguageNameIgnoreCase(String name);
}