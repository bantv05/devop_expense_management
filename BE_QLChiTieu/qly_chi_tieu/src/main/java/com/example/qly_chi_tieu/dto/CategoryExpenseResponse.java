package com.example.qly_chi_tieu.dto;

import java.math.BigDecimal;

public record CategoryExpenseResponse(
        Long categoryId,
        String categoryName,
        String color,
        BigDecimal amount) {
}
