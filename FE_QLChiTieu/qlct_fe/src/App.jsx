import { useEffect, useMemo, useState, useCallback } from 'react';
import { api } from './api.js';

// ─── Constants ────────────────────────────────────────────────────────────────

const emptyTransaction = {
  type: 'EXPENSE',
  amount: '',
  transactionDate: new Date().toISOString().slice(0, 10),
  description: '',
  categoryId: '',
};

const emptyCategory = {
  name: '',
  type: 'EXPENSE',
  color: '#6c5ce7',
};

const emptyBudget = {
  month: new Date().toISOString().slice(0, 8) + '01',
  amount: '',
  categoryId: '',
};

const currency = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

// ─── App ──────────────────────────────────────────────────────────────────────

export default function App() {
  const [transactions, setTransactions]   = useState([]);
  const [categories, setCategories]       = useState([]);
  const [budgets, setBudgets]             = useState([]);
  const [summary, setSummary]             = useState({ totalIncome: 0, totalExpense: 0, balance: 0, expensesByCategory: [] });

  const [transactionForm, setTransactionForm] = useState(emptyTransaction);
  const [categoryForm, setCategoryForm]       = useState(emptyCategory);
  const [budgetForm, setBudgetForm]           = useState(emptyBudget);

  const [editingTransactionId, setEditingTransactionId] = useState(null);
  const [editingCategoryId, setEditingCategoryId]       = useState(null);
  const [editingBudgetId, setEditingBudgetId]           = useState(null);

  const [filters, setFilters] = useState({ dateFrom: '', dateTo: '', type: '', categoryId: '' });
  const [apiStatus, setApiStatus] = useState('checking'); // 'ok' | 'error' | 'checking'
  const [error, setError]         = useState('');
  const [loading, setLoading]     = useState(true);

  // Only show categories matching the current transaction type
  const visibleCategories = useMemo(
      () => categories.filter((c) => c.type === transactionForm.type),
      [categories, transactionForm.type],
  );

  // ─── Data loading ──────────────────────────────────────────────────────────

  const loadData = useCallback(async (nextFilters = filters) => {
    setLoading(true);
    setError('');
    try {
      const [categoryData, transactionData, summaryData, budgetData] = await Promise.all([
        api.getCategories(),
        api.getTransactions(nextFilters),
        api.getSummary({ dateFrom: nextFilters.dateFrom, dateTo: nextFilters.dateTo }),
        api.getBudgets(),
      ]);
      setCategories(categoryData);
      setTransactions(transactionData);
      setSummary(summaryData);
      setBudgets(budgetData);
      setApiStatus('ok');
    } catch (err) {
      setError(err.message);
      setApiStatus('error');
    } finally {
      setLoading(false);
    }
  }, []); // eslint-disable-line

  useEffect(() => {
    api.health()
        .then(() => loadData())
        .catch((err) => {
          setApiStatus('error');
          setError(`Không kết nối được backend: ${err.message}`);
          setLoading(false);
        });
  }, []); // eslint-disable-line

  function updateFilters(name, value) {
    const next = { ...filters, [name]: value };
    setFilters(next);
    loadData(next);
  }

  // ─── Transaction CRUD ──────────────────────────────────────────────────────

  async function saveTransaction(event) {
    event.preventDefault();
    setError('');
    const payload = {
      ...transactionForm,
      amount: Number(transactionForm.amount),
      categoryId: Number(transactionForm.categoryId),
    };
    try {
      if (editingTransactionId) {
        await api.updateTransaction(editingTransactionId, payload);
      } else {
        await api.createTransaction(payload);
      }
      setTransactionForm(emptyTransaction);
      setEditingTransactionId(null);
      await loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  function editTransaction(t) {
    setEditingTransactionId(t.id);
    setTransactionForm({
      type:            t.type,
      amount:          t.amount,
      transactionDate: t.transactionDate,
      description:     t.description,
      categoryId:      t.category?.id ?? '',
    });
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function cancelEditTransaction() {
    setTransactionForm(emptyTransaction);
    setEditingTransactionId(null);
  }

  async function removeTransaction(id) {
    if (!window.confirm('Xóa giao dịch này?')) return;
    setError('');
    try {
      await api.deleteTransaction(id);
      await loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  // ─── Category CRUD ─────────────────────────────────────────────────────────

  async function saveCategory(event) {
    event.preventDefault();
    setError('');
    try {
      if (editingCategoryId) {
        await api.updateCategory(editingCategoryId, categoryForm);
      } else {
        await api.createCategory(categoryForm);
      }
      setCategoryForm(emptyCategory);
      setEditingCategoryId(null);
      await loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  function editCategory(c) {
    setEditingCategoryId(c.id);
    setCategoryForm({ name: c.name, type: c.type, color: c.color || '#6c5ce7' });
  }

  async function removeCategory(id) {
    if (!window.confirm('Xóa danh mục này?')) return;
    setError('');
    try {
      await api.deleteCategory(id);
      await loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  // ─── Budget CRUD ───────────────────────────────────────────────────────────

  async function saveBudget(event) {
    event.preventDefault();
    setError('');
    const payload = {
      month:      budgetForm.month,
      amount:     Number(budgetForm.amount),
      categoryId: budgetForm.categoryId ? Number(budgetForm.categoryId) : null,
    };
    try {
      if (editingBudgetId) {
        await api.updateBudget(editingBudgetId, payload);
      } else {
        await api.createBudget(payload);
      }
      setBudgetForm(emptyBudget);
      setEditingBudgetId(null);
      await loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  function editBudget(b) {
    setEditingBudgetId(b.id);
    setBudgetForm({ month: b.month, amount: b.amount, categoryId: b.category?.id ?? '' });
  }

  async function removeBudget(id) {
    if (!window.confirm('Xóa ngân sách này?')) return;
    setError('');
    try {
      await api.deleteBudget(id);
      await loadData();
    } catch (err) {
      setError(err.message);
    }
  }

  // ─── Render ────────────────────────────────────────────────────────────────

  return (
      <main className="app-shell">
        {/* Top bar */}
        <header className="topbar">
          <div>
            <p className="eyebrow">Personal Finance</p>
            <h1>Quản lý chi tiêu</h1>
          </div>
          <div className={`api-badge ${apiStatus}`}>
            <span className="api-dot" />
            {apiStatus === 'ok' ? 'API sẵn sàng' : apiStatus === 'checking' ? 'Đang kết nối…' : 'Mất kết nối'}
          </div>
        </header>

        {/* Global error banner */}
        {error && (
            <div className="error-banner">
              ⚠ {error}
              <button onClick={() => setError('')}>✕</button>
            </div>
        )}

        {/* Summary metrics */}
        <section className="summary-grid">
          <Metric label="Tổng thu"  value={summary.totalIncome}   tone="income"  />
          <Metric label="Tổng chi"  value={summary.totalExpense}  tone="expense" />
          <Metric label="Số dư"     value={summary.balance}       tone="balance" />
        </section>

        {/* Main workspace */}
        <div className="workspace">

          {/* ── Transactions panel ── */}
          <div className="panel wide">
            <div className="panel-head">
              <h2>Giao dịch {loading && <span className="spinner" />}</h2>
              <div className="filters">
                <input type="date" value={filters.dateFrom} onChange={(e) => updateFilters('dateFrom', e.target.value)} title="Từ ngày" />
                <input type="date" value={filters.dateTo}   onChange={(e) => updateFilters('dateTo',   e.target.value)} title="Đến ngày" />
                <select value={filters.type}       onChange={(e) => updateFilters('type',       e.target.value)}>
                  <option value="">Tất cả loại</option>
                  <option value="INCOME">Thu</option>
                  <option value="EXPENSE">Chi</option>
                </select>
                <select value={filters.categoryId} onChange={(e) => updateFilters('categoryId', e.target.value)}>
                  <option value="">Tất cả danh mục</option>
                  {categories.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
                </select>
              </div>
            </div>

            {/* Transaction form */}
            <form className="txn-form" onSubmit={saveTransaction}>
              <select
                  value={transactionForm.type}
                  onChange={(e) => setTransactionForm({ ...transactionForm, type: e.target.value, categoryId: '' })}
              >
                <option value="EXPENSE">Chi</option>
                <option value="INCOME">Thu</option>
              </select>

              <input
                  required type="number" min="1" step="1"
                  placeholder="Số tiền (VND)"
                  value={transactionForm.amount}
                  onChange={(e) => setTransactionForm({ ...transactionForm, amount: e.target.value })}
              />

              <input
                  required type="date"
                  value={transactionForm.transactionDate}
                  onChange={(e) => setTransactionForm({ ...transactionForm, transactionDate: e.target.value })}
              />

              <select
                  required
                  value={transactionForm.categoryId}
                  onChange={(e) => setTransactionForm({ ...transactionForm, categoryId: e.target.value })}
              >
                <option value="">— Danh mục —</option>
                {visibleCategories.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
              </select>

              <input
                  required className="span-4"
                  placeholder="Mô tả giao dịch"
                  value={transactionForm.description}
                  onChange={(e) => setTransactionForm({ ...transactionForm, description: e.target.value })}
              />

              <div className="form-actions span-4">
                <button className="btn-primary" type="submit">
                  {editingTransactionId ? '💾 Cập nhật' : '+ Thêm giao dịch'}
                </button>
                {editingTransactionId && (
                    <button className="btn-ghost" type="button" onClick={cancelEditTransaction}>Hủy</button>
                )}
              </div>
            </form>

            {/* Transaction table */}
            <div className="table-wrap">
              <table>
                <thead>
                <tr>
                  <th>Ngày</th>
                  <th>Loại</th>
                  <th>Danh mục</th>
                  <th>Mô tả</th>
                  <th>Số tiền</th>
                  <th></th>
                </tr>
                </thead>
                <tbody>
                {transactions.map((t) => (
                    <tr key={t.id} className={editingTransactionId === t.id ? 'editing-row' : ''}>
                      <td>{t.transactionDate}</td>
                      <td>
                      <span className={`pill ${t.type.toLowerCase()}`}>
                        {t.type === 'INCOME' ? 'Thu' : 'Chi'}
                      </span>
                      </td>
                      <td>
                      <span className="cat-chip" style={{ borderColor: t.category?.color || '#888' }}>
                        {t.category?.name ?? '—'}
                      </span>
                      </td>
                      <td className="desc-cell">{t.description}</td>
                      <td className={`money ${t.type === 'INCOME' ? 'income-text' : 'expense-text'}`}>
                        {t.type === 'INCOME' ? '+' : '-'}{currency.format(t.amount)}
                      </td>
                      <td className="row-actions">
                        <button className="btn-xs" onClick={() => editTransaction(t)}>Sửa</button>
                        <button className="btn-xs danger" onClick={() => removeTransaction(t.id)}>Xóa</button>
                      </td>
                    </tr>
                ))}
                {!loading && transactions.length === 0 && (
                    <tr><td colSpan={6} className="empty">Chưa có giao dịch nào</td></tr>
                )}
                </tbody>
              </table>
            </div>
          </div>

          {/* ── Side stack ── */}
          <aside className="side-stack">

            {/* Category panel */}
            <div className="panel">
              <h2>Danh mục</h2>
              <form className="compact-form" onSubmit={saveCategory}>
                <input
                    required placeholder="Tên danh mục"
                    value={categoryForm.name}
                    onChange={(e) => setCategoryForm({ ...categoryForm, name: e.target.value })}
                />
                <select
                    value={categoryForm.type}
                    onChange={(e) => setCategoryForm({ ...categoryForm, type: e.target.value })}
                >
                  <option value="EXPENSE">Chi</option>
                  <option value="INCOME">Thu</option>
                </select>
                <label className="color-wrap" title="Màu sắc">
                  <input
                      type="color" value={categoryForm.color}
                      onChange={(e) => setCategoryForm({ ...categoryForm, color: e.target.value })}
                  />
                </label>
                <button className="btn-primary" type="submit">{editingCategoryId ? 'Lưu' : '+'}</button>
                {editingCategoryId && (
                    <button className="btn-ghost span-4" type="button"
                            onClick={() => { setCategoryForm(emptyCategory); setEditingCategoryId(null); }}>
                      Hủy
                    </button>
                )}
              </form>
              <div className="cat-list">
                {categories.map((c) => (
                    <div className="cat-row" key={c.id}>
                      <span className="swatch" style={{ background: c.color || '#888' }} />
                      <strong>{c.name}</strong>
                      <span className={`type-badge ${c.type.toLowerCase()}`}>{c.type === 'INCOME' ? 'Thu' : 'Chi'}</span>
                      <button className="btn-xs" onClick={() => editCategory(c)}>Sửa</button>
                      <button className="btn-xs danger" onClick={() => removeCategory(c.id)}>Xóa</button>
                    </div>
                ))}
                {categories.length === 0 && <p className="empty">Chưa có danh mục</p>}
              </div>
            </div>

            {/* Budget panel */}
            <div className="panel">
              <h2>Ngân sách tháng</h2>
              <form className="compact-form" onSubmit={saveBudget}>
                {/* month input expects YYYY-MM but backend stores YYYY-MM-DD (first of month) */}
                <input
                    required type="month"
                    value={budgetForm.month.slice(0, 7)}
                    onChange={(e) => setBudgetForm({ ...budgetForm, month: `${e.target.value}-01` })}
                    style={{ gridColumn: '1 / span 2' }}
                />
                <input
                    required type="number" min="1" step="1"
                    placeholder="Hạn mức (VND)"
                    value={budgetForm.amount}
                    onChange={(e) => setBudgetForm({ ...budgetForm, amount: e.target.value })}
                    style={{ gridColumn: '1 / span 2' }}
                />
                <select
                    value={budgetForm.categoryId}
                    onChange={(e) => setBudgetForm({ ...budgetForm, categoryId: e.target.value })}
                    style={{ gridColumn: '1 / span 3' }}
                >
                  <option value="">Tổng chi tiêu</option>
                  {categories
                      .filter((c) => c.type === 'EXPENSE')
                      .map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
                </select>
                <button className="btn-primary" type="submit">{editingBudgetId ? 'Lưu' : '+'}</button>
                {editingBudgetId && (
                    <button className="btn-ghost span-4" type="button"
                            onClick={() => { setBudgetForm(emptyBudget); setEditingBudgetId(null); }}>
                      Hủy
                    </button>
                )}
              </form>
              <div className="budget-list">
                {budgets.map((b) => (
                    <div key={b.id} className={`budget-card ${b.exceeded ? 'warn' : ''}`}>
                      <div className="budget-head">
                        <strong>{b.month?.slice(0, 7)} — {b.category?.name ?? 'Tổng chi'}</strong>
                        <div>
                          <button className="btn-xs" onClick={() => editBudget(b)}>Sửa</button>
                          <button className="btn-xs danger" onClick={() => removeBudget(b.id)}>Xóa</button>
                        </div>
                      </div>
                      <BudgetBar spent={b.spent ?? 0} limit={b.amount} exceeded={b.exceeded} />
                      <span className="budget-nums">
                    {currency.format(b.spent ?? 0)} / {currency.format(b.amount)}
                        {b.exceeded && <em className="over-label"> ⚠ Vượt ngân sách</em>}
                  </span>
                    </div>
                ))}
                {budgets.length === 0 && <p className="empty">Chưa có ngân sách</p>}
              </div>
            </div>

            {/* Expense by category chart */}
            <div className="panel">
              <h2>Chi theo danh mục</h2>
              <CategoryChart data={summary.expensesByCategory ?? []} />
            </div>
          </aside>
        </div>
      </main>
  );
}

// ─── Sub-components ───────────────────────────────────────────────────────────

function Metric({ label, value, tone }) {
  return (
      <article className={`metric ${tone}`}>
        <span className="metric-label">{label}</span>
        <strong className="metric-value">{currency.format(value ?? 0)}</strong>
      </article>
  );
}

function BudgetBar({ spent, limit, exceeded }) {
  const pct = limit > 0 ? Math.min((spent / limit) * 100, 100) : 0;
  return (
      <div className="progress-track">
        <div
            className={`progress-fill ${exceeded ? 'over' : ''}`}
            style={{ width: `${pct}%` }}
        />
      </div>
  );
}

function CategoryChart({ data }) {
  const max = Math.max(...data.map((d) => Number(d.amount)), 1);
  if (!data.length) return <p className="empty">Chưa có dữ liệu chi tiêu</p>;

  return (
      <div className="chart">
        {data.map((item) => (
            <div className="bar-row" key={item.categoryId}>
              <span className="bar-label">{item.categoryName}</span>
              <div className="bar-track">
                <div
                    className="bar-fill"
                    style={{
                      width: `${(Number(item.amount) / max) * 100}%`,
                      background: item.color || '#6c5ce7',
                    }}
                />
              </div>
              <strong className="bar-value">{currency.format(item.amount)}</strong>
            </div>
        ))}
      </div>
  );
}