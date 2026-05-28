package com.example.qly_chi_tieu.repository;

import com.example.qly_chi_tieu.entity.Budget;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface BudgetRepository
        extends JpaRepository<Budget, Long>, JpaSpecificationExecutor<Budget> {
    // findFiltered đã chuyển sang BudgetSpec + JpaSpecificationExecutor
    // để tránh PSQLException: could not determine data type of parameter $1
}