package com.example.qly_chi_tieu.repository;

import com.example.qly_chi_tieu.entity.Category;
import com.example.qly_chi_tieu.entity.TransactionType;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<Category> findByTypeOrderByNameAsc(TransactionType type);
}
