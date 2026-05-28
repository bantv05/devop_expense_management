package com.example.qly_chi_tieu.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

public record BudgetRequest(
        @NotNull LocalDate month,
        @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
        Long categoryId) {
}
