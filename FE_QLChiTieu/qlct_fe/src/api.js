const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';
// Đổi thành '/api/v1' nếu backend có context-path hoặc prefix v1
const API_PREFIX = '/api';

async function request(path, options = {}) {
  const response = await fetch(`${API_BASE_URL}${API_PREFIX}${path}`, {
    headers: {
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
    ...options,
  });

  if (response.status === 204) return null;

  const data = await response.json();
  if (!response.ok) {
    throw new Error(data.message || `Lỗi ${response.status}: ${response.statusText}`);
  }
  return data;
}

function toQuery(params = {}) {
  const query = new URLSearchParams();
  Object.entries(params).forEach(([key, value]) => {
    if (value !== undefined && value !== null && value !== '') {
      query.set(key, value);
    }
  });
  const value = query.toString();
  return value ? `?${value}` : '';
}

export const api = {
  // ─── Health ───────────────────────────────────────────────────────
  health: () => request('/health'),

  // ─── Categories ───────────────────────────────────────────────────
  getCategories: (type) =>
      request(`/categories${type ? `?type=${type}` : ''}`),

  createCategory: (payload) =>
      request('/categories', { method: 'POST', body: JSON.stringify(payload) }),

  updateCategory: (id, payload) =>
      request(`/categories/${id}`, { method: 'PUT', body: JSON.stringify(payload) }),

  deleteCategory: (id) =>
      request(`/categories/${id}`, { method: 'DELETE' }),

  // ─── Transactions ─────────────────────────────────────────────────
  getTransactions: (query) =>
      request(`/transactions${toQuery(query)}`),

  getTransaction: (id) =>
      request(`/transactions/${id}`),

  getSummary: (query) =>
      request(`/transactions/summary${toQuery(query)}`),

  createTransaction: (payload) =>
      request('/transactions', { method: 'POST', body: JSON.stringify(payload) }),

  updateTransaction: (id, payload) =>
      request(`/transactions/${id}`, { method: 'PUT', body: JSON.stringify(payload) }),

  deleteTransaction: (id) =>
      request(`/transactions/${id}`, { method: 'DELETE' }),

  // ─── Budgets ──────────────────────────────────────────────────────
  getBudgets: (month) =>
      request(`/budgets${month ? `?month=${month}` : ''}`),

  getBudget: (id) =>
      request(`/budgets/${id}`),

  createBudget: (payload) =>
      request('/budgets', { method: 'POST', body: JSON.stringify(payload) }),

  updateBudget: (id, payload) =>
      request(`/budgets/${id}`, { method: 'PUT', body: JSON.stringify(payload) }),

  deleteBudget: (id) =>
      request(`/budgets/${id}`, { method: 'DELETE' }),
};