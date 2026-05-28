package com.example.qly_chi_tieu.dto;

import com.example.qly_chi_tieu.entity.Budget;
import java.math.BigDecimal;
import java.time.LocalDate;

public record BudgetResponse(
        Long id,
        LocalDate month,
        BigDecimal amount,
        CategoryResponse category,
        BigDecimal spent,
        boolean exceeded) {

    public static BudgetResponse from(Budget budget, BigDecimal spent) {
        return new BudgetResponse(
                budget.getId(),
                budget.getMonth(),
                budget.getAmount(),
                budget.getCategory() == null ? null : CategoryResponse.from(budget.getCategory()),
                spent,
                spent.compareTo(budget.getAmount()) > 0);
    }
}
