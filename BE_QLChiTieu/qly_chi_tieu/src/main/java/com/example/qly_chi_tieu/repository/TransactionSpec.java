package com.example.qly_chi_tieu.repository;

import com.example.qly_chi_tieu.entity.Transaction;
import com.example.qly_chi_tieu.entity.TransactionType;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Predicate;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import org.springframework.data.jpa.domain.Specification;

public class TransactionSpec {

    private TransactionSpec() {}

    /**
     * Thay thế findFiltered JPQL — không dùng (:param is null or ...) nên
     * không bị PSQLException: could not determine data type of parameter $1
     */
    public static Specification<Transaction> filter(
            LocalDate dateFrom,
            LocalDate dateTo,
            TransactionType type,
            Long categoryId) {

        return (root, query, cb) -> {
            // Fetch join để tránh N+1 (tương đương join fetch trong JPQL)
            if (query.getResultType().equals(Transaction.class)) {
                root.fetch("category", JoinType.INNER);
            }

            List<Predicate> predicates = new ArrayList<>();

            if (dateFrom != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("transactionDate"), dateFrom));
            }
            if (dateTo != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("transactionDate"), dateTo));
            }
            if (type != null) {
                predicates.add(cb.equal(root.get("type"), type));
            }
            if (categoryId != null) {
                predicates.add(cb.equal(root.get("category").get("id"), categoryId));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}