package com.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.PassedOut;

public interface PassedOutRepository extends JpaRepository<PassedOut, Long> {
	
}