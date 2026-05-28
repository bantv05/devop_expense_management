package com.example.qly_chi_tieu.dto;

import com.example.qly_chi_tieu.entity.Category;
import com.example.qly_chi_tieu.entity.TransactionType;

public record CategoryResponse(
        Long id,
        String name,
        TransactionType type,
        String color) {

    public static CategoryResponse from(Category category) {
        return new CategoryResponse(
                category.getId(),
                category.getName(),
                category.getType(),
                category.getColor());
    }
}
