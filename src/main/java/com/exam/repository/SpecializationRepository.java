package com.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.Specialization;

public interface SpecializationRepository extends JpaRepository<Specialization, Long> {
	
}