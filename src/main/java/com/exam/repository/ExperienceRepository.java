package com.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.Experience;
import com.exam.entity.PassedOut;

public interface ExperienceRepository extends JpaRepository<Experience, Long> {
	
}
