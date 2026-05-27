package com.exam.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.exam.repository.StudentRepository;

@Service
public class AadhrService {

    @Autowired
    private StudentRepository userRepository;

    public boolean exists(String aadharNumber) {
        return userRepository.existsByAadharNumber(aadharNumber);
    }
}


