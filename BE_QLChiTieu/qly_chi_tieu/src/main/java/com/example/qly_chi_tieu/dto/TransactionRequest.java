package com.example.qly_chi_tieu.dto;

import com.example.qly_chi_tieu.entity.TransactionType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

public record TransactionRequest(
        @NotNull TransactionType type,
        @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
        @NotNull LocalDate transactionDate,
        @NotBlank String description,
        @NotNull Long categoryId) {
}
