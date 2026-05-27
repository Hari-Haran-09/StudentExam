package com.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.AwsMcq;
import java.util.List;


public interface AwsRepository extends JpaRepository<AwsMcq,Long> {
	List<AwsMcq> findByLanguageName(String languageName);
	
	int countByLanguageName(String languageName);

}
