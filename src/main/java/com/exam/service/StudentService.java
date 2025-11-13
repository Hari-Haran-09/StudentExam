//package com.exam.service;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//import org.springframework.stereotype.Service;
//
//import com.exam.entity.Student;
//import com.exam.repository.StudentRepository;
//
//@Service
//public class StudentService {
//
//    @Autowired
//    private StudentRepository userRepository;
//
//    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
//
//    public Student registerUser(Student student) {
//        // Encrypt password before saving
//        student.setPassword(encoder.encode(student.getPassword())); // ✅ use the object
//
//        return userRepository.save(student);
//    }
//
//    public Student loginUser(String email, String rawPassword) {
//        return userRepository.findByEmail(email)
//                .filter(u -> encoder.matches(rawPassword, u.getPassword()))
//                .orElse(null);
//    }
//}
package com.exam.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.exam.entity.Student;
import com.exam.repository.StudentRepository;

@Service
public class StudentService {

    @Autowired
    private StudentRepository userRepository;

    public Student registerUser(Student student) {
        // Save password as plain text (not secure, but simple for now)
        return userRepository.save(student);
    }

    public Student loginUser(String email, String rawPassword) {
        return userRepository.findByEmail(email)
                .filter(u -> rawPassword.equals(u.getPassword()))
                .orElse(null);
    }
    public List<Student> getAllStudents() {
        return userRepository.findAll();
    }
}
