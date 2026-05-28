package com.example.qly_chi_tieu.service;

import com.example.qly_chi_tieu.dto.BudgetRequest;
import com.example.qly_chi_tieu.dto.BudgetResponse;
import com.example.qly_chi_tieu.entity.Budget;
import com.example.qly_chi_tieu.entity.Category;
import com.example.qly_chi_tieu.entity.TransactionType;
import com.example.qly_chi_tieu.exception.ResourceNotFoundException;
import com.example.qly_chi_tieu.repository.BudgetRepository;
import com.example.qly_chi_tieu.repository.BudgetSpec;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BudgetService {

    private final BudgetRepository budgetRepository;
    private final CategoryService categoryService;
    private final TransactionService transactionService;

    public BudgetService(BudgetRepository budgetRepository,
                         CategoryService categoryService,
                         TransactionService transactionService) {
        this.budgetRepository = budgetRepository;
        this.categoryService = categoryService;
        this.transactionService = transactionService;
    }

    @Transactional(readOnly = true)
    public List<BudgetResponse> findAll(LocalDate month) {
        LocalDate normalizedMonth = month == null ? null : normalizeMonth(month);
        var spec = BudgetSpec.filter(normalizedMonth);
        var sort = Sort.by(Sort.Direction.DESC, "month", "id");
        return budgetRepository.findAll(spec, sort)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public BudgetResponse findById(Long id) {
        return toResponse(getEntity(id));
    }

    @Transactional
    public BudgetResponse create(BudgetRequest request) {
        Budget budget = new Budget();
        apply(budget, request);
        return toResponse(budgetRepository.save(budget));
    }

    @Transactional
    public BudgetResponse update(Long id, BudgetRequest request) {
        Budget budget = getEntity(id);
        apply(budget, request);
        return toResponse(budget);
    }

    @Transactional
    public void delete(Long id) {
        if (!budgetRepository.existsById(id)) {
            throw new ResourceNotFoundException("Budget not found: " + id);
        }
        budgetRepository.deleteById(id);
    }

    // ── private helpers ────────────────────────────────────────────────────────

    private Budget getEntity(Long id) {
        return budgetRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Budget not found: " + id));
    }

    private void apply(Budget budget, BudgetRequest request) {
        budget.setMonth(normalizeMonth(request.month()));
        budget.setAmount(request.amount());
        budget.setCategory(resolveExpenseCategory(request.categoryId()));
    }

    private Category resolveExpenseCategory(Long categoryId) {
        if (categoryId == null) return null;
        Category category = categoryService.getEntity(categoryId);
        if (category.getType() != TransactionType.EXPENSE) {
            throw new IllegalArgumentException("Budget category must be an expense category");
        }
        return category;
    }

    private BudgetResponse toResponse(Budget budget) {
        LocalDate start      = budget.getMonth();
        LocalDate end        = start.withDayOfMonth(start.lengthOfMonth());
        Long categoryId      = budget.getCategory() == null ? null : budget.getCategory().getId();
        BigDecimal spent     = transactionService.sumExpense(start, end, categoryId);
        return BudgetResponse.from(budget, spent);
    }

    private LocalDate normalizeMonth(LocalDate value) {
        return value.withDayOfMonth(1);
    }
}