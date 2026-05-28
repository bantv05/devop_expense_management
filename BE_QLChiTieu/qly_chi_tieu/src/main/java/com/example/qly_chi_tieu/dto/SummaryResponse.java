package com.example.qly_chi_tieu.dto;

import java.math.BigDecimal;
import java.util.List;

public record SummaryResponse(
        BigDecimal totalIncome,
        BigDecimal totalExpense,
        BigDecimal balance,
        List<CategoryExpenseResponse> expensesByCategory) {
}
