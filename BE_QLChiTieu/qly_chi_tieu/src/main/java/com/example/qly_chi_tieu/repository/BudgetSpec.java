package com.example.qly_chi_tieu.repository;

import com.example.qly_chi_tieu.entity.Budget;
import jakarta.persistence.criteria.JoinType;
import java.time.LocalDate;
import org.springframework.data.jpa.domain.Specification;

public class BudgetSpec {

    private BudgetSpec() {}

    public static Specification<Budget> filter(LocalDate month) {
        return (root, query, cb) -> {
            // Left join fetch category (tương đương left join fetch trong JPQL gốc)
            if (query.getResultType().equals(Budget.class)) {
                root.fetch("category", JoinType.LEFT);
            }

            if (month == null) {
                return cb.conjunction(); // không filter → lấy tất cả
            }
            return cb.equal(root.get("month"), month);
        };
    }
}