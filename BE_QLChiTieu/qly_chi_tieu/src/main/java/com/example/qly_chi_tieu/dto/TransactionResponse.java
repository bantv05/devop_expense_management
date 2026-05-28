package com.example.qly_chi_tieu.dto;

import com.example.qly_chi_tieu.entity.Transaction;
import com.example.qly_chi_tieu.entity.TransactionType;
import java.math.BigDecimal;
import java.time.LocalDate;

public record TransactionResponse(
        Long id,
        TransactionType type,
        BigDecimal amount,
        LocalDate transactionDate,
        String description,
        CategoryResponse category) {

    public static TransactionResponse from(Transaction transaction) {
        return new TransactionResponse(
                transaction.getId(),
                transaction.getType(),
                transaction.getAmount(),
                transaction.getTransactionDate(),
                transaction.getDescription(),
                CategoryResponse.from(transaction.getCategory()));
    }
}
