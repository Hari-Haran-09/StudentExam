package com.exam.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.exam.entity.Role;

public interface RoleRepository extends JpaRepository<Role, Long> {

	Optional<Role> findByRoleIgnoreCase(String trim);

	List<Role> findAllByRoleIgnoreCase(String trim);

	List<Role> findAllByRole(String role);

	boolean existsByRoleIgnoreCase(String role);
	
}