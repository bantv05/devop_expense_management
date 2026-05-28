# Expense Tracker

Ung dung quan ly chi tieu gom Spring Boot MVC, React Vite va PostgreSQL, chay bang Docker Compose.

## Chay bang Docker

```bash
docker compose up -d
```

Mac dinh:
- Frontend: http://localhost:5173
- Backend: http://localhost:8080
- Health check: http://localhost:8080/api/health

Neu can doi cau hinh, copy `.env.example` thanh `.env` va sua gia tri trong file `.env`.

## API chinh

- `GET /api/health`
- `GET|POST /api/categories`
- `PUT|DELETE /api/categories/{id}`
- `GET|POST /api/transactions`
- `GET|PUT|DELETE /api/transactions/{id}`
- `GET /api/transactions/summary`
- `GET|POST /api/budgets`
- `GET|PUT|DELETE /api/budgets/{id}`

## Chay local khi khong dung Docker

Backend can cac bien moi truong:

```bash
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/expense_tracker
SPRING_DATASOURCE_USERNAME=expense_user
SPRING_DATASOURCE_PASSWORD=expense_password
```

Frontend local:

```bash
cd FE_QLChiTieu/qlct_fe
npm install
npm run dev
```

## CI/CD

Đã thêm GitHub Actions workflow tại `.github/workflows/ci-cd.yml`.
- Chạy unit test và build backend Spring Boot
- Cài đặt và build frontend Vite
- Xây dựng ảnh Docker cho backend và frontend
- Có bước publish Docker Hub tùy chọn khi `DOCKERHUB_USERNAME` và `DOCKERHUB_TOKEN` được cấu hình
