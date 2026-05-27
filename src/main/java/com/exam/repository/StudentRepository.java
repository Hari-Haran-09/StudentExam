package com.exam.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import com.exam.entity.Student;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
	
    Optional<Student> findByEmail(String email);

    Optional<Student> findByRole(String role);

	boolean existsByEmail(String email);



//	String extractTextFromImage(String aadharFileUrl);
//
  @Query("SELECT s.aadharFileUrl FROM Student s WHERE s.id = :id")
  MultipartFile getAadharFileUrl(@Param("id") Long id);

//void save(String aadharNumber);

void save(String aadharNumber);

Optional<Student> findByAadharNumber(String aadharNumber);
boolean existsByAadharNumber(String aadharNumber);


}
