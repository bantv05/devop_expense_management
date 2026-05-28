package com.example.qly_chi_tieu.dto;

import com.example.qly_chi_tieu.entity.TransactionType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CategoryRequest(
        @NotBlank String name,
        @NotNull TransactionType type,
        String color) {
}
