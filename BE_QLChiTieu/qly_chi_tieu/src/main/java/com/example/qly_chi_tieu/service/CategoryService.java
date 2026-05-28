package com.example.qly_chi_tieu.service;

import com.example.qly_chi_tieu.dto.CategoryRequest;
import com.example.qly_chi_tieu.dto.CategoryResponse;
import com.example.qly_chi_tieu.entity.Category;
import com.example.qly_chi_tieu.entity.TransactionType;
import com.example.qly_chi_tieu.exception.ResourceNotFoundException;
import com.example.qly_chi_tieu.repository.CategoryRepository;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Transactional(readOnly = true)
    public List<CategoryResponse> findAll(TransactionType type) {
        List<Category> categories = type == null
                ? categoryRepository.findAll()
                : categoryRepository.findByTypeOrderByNameAsc(type);
        return categories.stream().map(CategoryResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public Category getEntity(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found: " + id));
    }

    @Transactional
    public CategoryResponse create(CategoryRequest request) {
        Category category = new Category();
        apply(category, request);
        return CategoryResponse.from(categoryRepository.save(category));
    }

    @Transactional
    public CategoryResponse update(Long id, CategoryRequest request) {
        Category category = getEntity(id);
        apply(category, request);
        return CategoryResponse.from(category);
    }

    @Transactional
    public void delete(Long id) {
        if (!categoryRepository.existsById(id)) {
            throw new ResourceNotFoundException("Category not found: " + id);
        }
        categoryRepository.deleteById(id);
    }

    private void apply(Category category, CategoryRequest request) {
        category.setName(request.name().trim());
        category.setType(request.type());
        category.setColor(request.color());
    }
}
