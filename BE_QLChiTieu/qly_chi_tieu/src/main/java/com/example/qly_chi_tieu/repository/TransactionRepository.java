package com.example.qly_chi_tieu.repository;

import com.example.qly_chi_tieu.entity.Transaction;
import com.example.qly_chi_tieu.entity.TransactionType;
import java.math.BigDecimal;
import java.time.LocalDate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface TransactionRepository
        extends JpaRepository<Transaction, Long>, JpaSpecificationExecutor<Transaction> {

    // Tách 2 method riêng thay vì (:categoryId is null or ...) → tránh PSQLException 42P18
    // PostgreSQL không thể infer kiểu param khi giá trị null được truyền vào

    @Query("""
            select sum(t.amount)
            from Transaction t
            where t.type = :type
              and t.transactionDate >= :dateFrom
              and t.transactionDate <= :dateTo
            """)
    BigDecimal sumByTypeAndDateRange(
            @Param("type") TransactionType type,
            @Param("dateFrom") LocalDate dateFrom,
            @Param("dateTo") LocalDate dateTo);

    @Query("""
            select sum(t.amount)
            from Transaction t
            where t.type = :type
              and t.transactionDate >= :dateFrom
              and t.transactionDate <= :dateTo
              and t.category.id = :categoryId
            """)
    BigDecimal sumByTypeAndDateRangeAndCategory(
            @Param("type") TransactionType type,
            @Param("dateFrom") LocalDate dateFrom,
            @Param("dateTo") LocalDate dateTo,
            @Param("categoryId") Long categoryId);
}