package com.exam.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.Experience;
import com.exam.entity.Student;

public interface ExperienceRepository extends JpaRepository<Experience, Long> {

	List<Student> findByExperienceIgnoreCase(String trimmed);
	
}
