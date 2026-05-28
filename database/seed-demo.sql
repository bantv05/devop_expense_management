BEGIN;

TRUNCATE TABLE transactions, budgets, categories RESTART IDENTITY CASCADE;

INSERT INTO categories (id, name, type, color, created_at) VALUES
  (1, 'Luong cong ty', 'INCOME', '#16a34a', NOW()),
  (2, 'Freelance', 'INCOME', '#0f766e', NOW()),
  (3, 'Thuong', 'INCOME', '#65a30d', NOW()),
  (4, 'An uong', 'EXPENSE', '#ef4444', NOW()),
  (5, 'Nha o', 'EXPENSE', '#f97316', NOW()),
  (6, 'Di chuyen', 'EXPENSE', '#eab308', NOW()),
  (7, 'Mua sam', 'EXPENSE', '#8b5cf6', NOW()),
  (8, 'Hoa don', 'EXPENSE', '#2563eb', NOW()),
  (9, 'Hoc tap', 'EXPENSE', '#0891b2', NOW()),
  (10, 'Suc khoe', 'EXPENSE', '#db2777', NOW()),
  (11, 'Giai tri', 'EXPENSE', '#7c3aed', NOW()),
  (12, 'Du lich', 'EXPENSE', '#059669', NOW());

INSERT INTO budgets (id, month, amount, category_id, created_at) VALUES
  (1, '2026-05-01', 18000000.00, NULL, NOW()),
  (2, '2026-05-01', 4000000.00, 4, NOW()),
  (3, '2026-05-01', 5000000.00, 5, NOW()),
  (4, '2026-05-01', 1500000.00, 6, NOW()),
  (5, '2026-05-01', 2500000.00, 7, NOW()),
  (6, '2026-05-01', 1200000.00, 11, NOW()),
  (7, '2026-06-01', 18000000.00, NULL, NOW()),
  (8, '2026-06-01', 4200000.00, 4, NOW());

INSERT INTO transactions (id, type, amount, transaction_date, description, category_id, created_at) VALUES
  (1, 'INCOME', 18000000.00, '2026-05-01', 'Luong thang 5', 1, NOW()),
  (2, 'INCOME', 3500000.00, '2026-05-05', 'Du an freelance landing page', 2, NOW()),
  (3, 'INCOME', 2000000.00, '2026-05-10', 'Thuong hoan thanh KPI', 3, NOW()),

  (4, 'EXPENSE', 55000.00, '2026-05-01', 'An sang banh mi va ca phe', 4, NOW()),
  (5, 'EXPENSE', 85000.00, '2026-05-01', 'Com trua van phong', 4, NOW()),
  (6, 'EXPENSE', 3200000.00, '2026-05-02', 'Tien thue phong thang 5', 5, NOW()),
  (7, 'EXPENSE', 280000.00, '2026-05-02', 'Do xang xe may', 6, NOW()),
  (8, 'EXPENSE', 460000.00, '2026-05-03', 'Di sieu thi cuoi tuan', 4, NOW()),
  (9, 'EXPENSE', 180000.00, '2026-05-04', 'Tra sua va an vat', 4, NOW()),
  (10, 'EXPENSE', 650000.00, '2026-05-04', 'Tien dien nuoc internet', 8, NOW()),
  (11, 'EXPENSE', 1290000.00, '2026-05-06', 'Mua giay di lam', 7, NOW()),
  (12, 'EXPENSE', 120000.00, '2026-05-07', 'Gui xe va xang xe', 6, NOW()),
  (13, 'EXPENSE', 950000.00, '2026-05-08', 'Khoa hoc Docker va CI/CD', 9, NOW()),
  (14, 'EXPENSE', 360000.00, '2026-05-09', 'Kham rang dinh ky', 10, NOW()),
  (15, 'EXPENSE', 720000.00, '2026-05-10', 'An toi cung ban be', 4, NOW()),
  (16, 'EXPENSE', 450000.00, '2026-05-11', 'Ve xem phim va bap nuoc', 11, NOW()),
  (17, 'EXPENSE', 1350000.00, '2026-05-12', 'Mua ao so mi va quan tay', 7, NOW()),
  (18, 'EXPENSE', 220000.00, '2026-05-12', 'Grab di gap khach hang', 6, NOW()),
  (19, 'EXPENSE', 980000.00, '2026-05-13', 'Tiec sinh nhat gia dinh', 4, NOW()),
  (20, 'EXPENSE', 850000.00, '2026-05-14', 'Dang ky phong gym', 10, NOW()),
  (21, 'EXPENSE', 780000.00, '2026-05-15', 'Concert cuoi tuan', 11, NOW()),
  (22, 'EXPENSE', 430000.00, '2026-05-16', 'Mua thuc pham nau an', 4, NOW()),
  (23, 'EXPENSE', 2600000.00, '2026-05-18', 'Dat ve xe va khach san Da Lat', 12, NOW()),
  (24, 'EXPENSE', 175000.00, '2026-05-19', 'Xang xe va rua xe', 6, NOW()),
  (25, 'EXPENSE', 510000.00, '2026-05-20', 'Com trua trong tuan', 4, NOW()),

  (26, 'INCOME', 18000000.00, '2026-04-01', 'Luong thang 4', 1, NOW()),
  (27, 'INCOME', 2200000.00, '2026-04-16', 'Sua loi website freelance', 2, NOW()),
  (28, 'EXPENSE', 3200000.00, '2026-04-02', 'Tien thue phong thang 4', 5, NOW()),
  (29, 'EXPENSE', 3850000.00, '2026-04-30', 'Tong chi an uong thang 4', 4, NOW()),
  (30, 'EXPENSE', 1450000.00, '2026-04-22', 'Mua ban phim co', 7, NOW()),
  (31, 'EXPENSE', 680000.00, '2026-04-12', 'Hoa don dien nuoc internet', 8, NOW()),
  (32, 'EXPENSE', 980000.00, '2026-04-18', 'Cafe va xem phim', 11, NOW());

SELECT setval(pg_get_serial_sequence('categories', 'id'), (SELECT MAX(id) FROM categories));
SELECT setval(pg_get_serial_sequence('budgets', 'id'), (SELECT MAX(id) FROM budgets));
SELECT setval(pg_get_serial_sequence('transactions', 'id'), (SELECT MAX(id) FROM transactions));

COMMIT;
