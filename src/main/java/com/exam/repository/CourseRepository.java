package com.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.Course;

 public interface CourseRepository extends JpaRepository<Course, Long> {
	
}