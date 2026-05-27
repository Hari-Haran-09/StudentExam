package com.exam.repository;
 
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.exam.entity.RatingEntity;

@Repository
 
 
public interface RatingRepository extends JpaRepository<RatingEntity, Long>{
 
}