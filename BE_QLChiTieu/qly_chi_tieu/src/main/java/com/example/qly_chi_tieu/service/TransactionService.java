package com.example.qly_chi_tieu.service;

import com.example.qly_chi_tieu.dto.CategoryExpenseResponse;
import com.example.qly_chi_tieu.dto.SummaryResponse;
import com.example.qly_chi_tieu.dto.TransactionRequest;
import com.example.qly_chi_tieu.dto.TransactionResponse;
import com.example.qly_chi_tieu.entity.Category;
import com.example.qly_chi_tieu.entity.Transaction;
import com.example.qly_chi_tieu.entity.TransactionType;
import com.example.qly_chi_tieu.exception.ResourceNotFoundException;
import com.example.qly_chi_tieu.repository.TransactionRepository;
import com.example.qly_chi_tieu.repository.TransactionSpec;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final CategoryService categoryService;

    public TransactionService(TransactionRepository transactionRepository,
                              CategoryService categoryService) {
        this.transactionRepository = transactionRepository;
        this.categoryService = categoryService;
    }

    @Transactional(readOnly = true)
    public List<TransactionResponse> findAll(LocalDate dateFrom, LocalDate dateTo,
                                             TransactionType type, Long categoryId) {
        var spec = TransactionSpec.filter(dateFrom, dateTo, type, categoryId);
        var sort = Sort.by(Sort.Direction.DESC, "transactionDate", "id");
        return transactionRepository.findAll(spec, sort)
                .stream()
                .map(TransactionResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public TransactionResponse findById(Long id) {
        return TransactionResponse.from(getEntity(id));
    }

    @Transactional
    public TransactionResponse create(TransactionRequest request) {
        Transaction transaction = new Transaction();
        apply(transaction, request);
        return TransactionResponse.from(transactionRepository.save(transaction));
    }

    @Transactional
    public TransactionResponse update(Long id, TransactionRequest request) {
        Transaction transaction = getEntity(id);
        apply(transaction, request);
        return TransactionResponse.from(transaction);
    }

    @Transactional
    public void delete(Long id) {
        if (!transactionRepository.existsById(id)) {
            throw new ResourceNotFoundException("Transaction not found: " + id);
        }
        transactionRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public SummaryResponse summary(LocalDate dateFrom, LocalDate dateTo) {
        LocalDate start = dateFrom == null ? LocalDate.of(1970, 1, 1) : dateFrom;
        LocalDate end   = dateTo   == null ? LocalDate.of(2999, 12, 31) : dateTo;

        BigDecimal totalIncome  = zeroIfNull(
                transactionRepository.sumByTypeAndDateRange(TransactionType.INCOME,  start, end));
        BigDecimal totalExpense = zeroIfNull(
                transactionRepository.sumByTypeAndDateRange(TransactionType.EXPENSE, start, end));
        List<CategoryExpenseResponse> expensesByCategory = buildExpensesByCategory(start, end);

        return new SummaryResponse(totalIncome, totalExpense,
                totalIncome.subtract(totalExpense), expensesByCategory);
    }

    @Transactional(readOnly = true)
    public BigDecimal sumExpense(LocalDate start, LocalDate end, Long categoryId) {
        if (categoryId == null) {
            // Tổng chi không lọc theo category
            return zeroIfNull(transactionRepository
                    .sumByTypeAndDateRange(TransactionType.EXPENSE, start, end));
        }
        // Lọc theo category cụ thể
        return zeroIfNull(transactionRepository
                .sumByTypeAndDateRangeAndCategory(TransactionType.EXPENSE, start, end, categoryId));
    }

    // ── private helpers ────────────────────────────────────────────────────────

    private Transaction getEntity(Long id) {
        return transactionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Transaction not found: " + id));
    }

    private void apply(Transaction transaction, TransactionRequest request) {
        Category category = categoryService.getEntity(request.categoryId());
        if (category.getType() != request.type()) {
            throw new IllegalArgumentException("Category type must match transaction type");
        }
        transaction.setType(request.type());
        transaction.setAmount(request.amount());
        transaction.setTransactionDate(request.transactionDate());
        transaction.setDescription(request.description().trim());
        transaction.setCategory(category);
    }

    private List<CategoryExpenseResponse> buildExpensesByCategory(LocalDate start, LocalDate end) {
        var spec = TransactionSpec.filter(start, end, TransactionType.EXPENSE, null);
        var sort = Sort.by(Sort.Direction.DESC, "transactionDate", "id");

        Map<Long, CategoryExpenseResponse> grouped = new LinkedHashMap<>();
        transactionRepository.findAll(spec, sort).forEach(t ->
                grouped.merge(
                        t.getCategory().getId(),
                        new CategoryExpenseResponse(
                                t.getCategory().getId(),
                                t.getCategory().getName(),
                                t.getCategory().getColor(),
                                t.getAmount()),
                        (left, right) -> new CategoryExpenseResponse(
                                left.categoryId(),
                                left.categoryName(),
                                left.color(),
                                left.amount().add(right.amount()))));

        return grouped.values().stream()
                .sorted(Comparator.comparing(CategoryExpenseResponse::amount).reversed())
                .toList();
    }

    private BigDecimal zeroIfNull(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }
}