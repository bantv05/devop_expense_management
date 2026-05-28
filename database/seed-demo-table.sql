BEGIN;

TRUNCATE TABLE
    coupon_usage,
    order_participants,
    order_details,
    reviews,
    notifications,
    wishlists,
    cart,
    orders,
    tour_detail,
    tour_schedules,
    tours,
    coupons,
    contacts,
    statistics_daily,
    settings,
    users,
    roles,
    categories
RESTART IDENTITY CASCADE;

INSERT INTO roles (id, role_name, description, created_at, updated_at) VALUES
    (1, 'ADMIN', 'Quản trị viên toàn hệ thống', NOW(), NOW()),
    (2, 'STAFF', 'Nhân viên tư vấn và xử lý đơn tour', NOW(), NOW()),
    (3, 'CUSTOMER', 'Khách hàng đặt tour', NOW(), NOW());

INSERT INTO users (
    id, full_name, email, phone, password_hash, address, avatar_url,
    date_of_birth, gender, email_verified, status, role_id, created_at, updated_at
) VALUES
    (1, 'Nguyễn Minh Quản Trị', 'admin@dulichviet.vn', '0901000001',
     '$2a$10$demoHashAdmin', 'Quận Hải Châu, Đà Nẵng', NULL,
     '1990-01-15', 'MALE', TRUE, 'ACTIVE', 1, NOW(), NOW()),
    (2, 'Trần Thị Thu Hằng', 'staff@dulichviet.vn', '0901000002',
     '$2a$10$demoHashStaff', 'Quận Cầu Giấy, Hà Nội', NULL,
     '1994-08-20', 'FEMALE', TRUE, 'ACTIVE', 2, NOW(), NOW()),
    (3, 'Lê Văn Nam', 'nam.le@example.com', '0912345678',
     '$2a$10$demoHashCustomer1', '25 Nguyễn Trãi, Thanh Xuân, Hà Nội', NULL,
     '1996-04-12', 'MALE', TRUE, 'ACTIVE', 3, NOW(), NOW()),
    (4, 'Phạm Thuỳ Linh', 'linh.pham@example.com', '0987654321',
     '$2a$10$demoHashCustomer2', '18 Võ Văn Tần, Quận 3, TP. Hồ Chí Minh', NULL,
     '1998-11-03', 'FEMALE', TRUE, 'ACTIVE', 3, NOW(), NOW()),
    (5, 'Hoàng Gia Bảo', 'bao.hoang@example.com', '0977001122',
     '$2a$10$demoHashCustomer3', 'Phường An Hải Bắc, Sơn Trà, Đà Nẵng', NULL,
     '1992-06-25', 'MALE', FALSE, 'ACTIVE', 3, NOW(), NOW());

INSERT INTO categories (
    id, category_name, slug, description, image_url, display_order, status,
    parent_id, created_at, updated_at
) VALUES
    (1, 'Du lịch trong nước', 'du-lich-trong-nuoc',
     'Các tour khám phá Việt Nam theo vùng miền.', '/images/categories/trong-nuoc.jpg',
     1, 'ACTIVE', NULL, NOW(), NOW()),
    (2, 'Du lịch nước ngoài', 'du-lich-nuoc-ngoai',
     'Tour quốc tế trọn gói, lịch trình rõ ràng.', '/images/categories/nuoc-ngoai.jpg',
     2, 'ACTIVE', NULL, NOW(), NOW()),
    (3, 'Miền Bắc', 'mien-bac',
     'Hà Nội, Ninh Bình, Sapa, Hạ Long và các điểm phía Bắc.', '/images/categories/mien-bac.jpg',
     1, 'ACTIVE', 1, NOW(), NOW()),
    (4, 'Miền Trung', 'mien-trung',
     'Đà Nẵng, Huế, Hội An, Quảng Bình, Quy Nhơn.', '/images/categories/mien-trung.jpg',
     2, 'ACTIVE', 1, NOW(), NOW()),
    (5, 'Miền Nam', 'mien-nam',
     'TP. Hồ Chí Minh, miền Tây, Phú Quốc, Côn Đảo.', '/images/categories/mien-nam.jpg',
     3, 'ACTIVE', 1, NOW(), NOW()),
    (6, 'Đông Bắc Á', 'dong-bac-a',
     'Nhật Bản, Hàn Quốc, Đài Loan với lịch trình theo mùa.', '/images/categories/dong-bac-a.jpg',
     1, 'ACTIVE', 2, NOW(), NOW()),
    (7, 'Đông Nam Á', 'dong-nam-a',
     'Thái Lan, Singapore, Malaysia, Bali.', '/images/categories/dong-nam-a.jpg',
     2, 'ACTIVE', 2, NOW(), NOW());

INSERT INTO tours (
    id, tour_code, tour_name, slug, short_description, description,
    departure_location, destination, duration_days, duration_nights,
    base_price, adult_price, child_price, infant_price,
    featured_image, video_url, rating_average, total_reviews, view_count,
    status, category_id, created_by, created_at, updated_at
) VALUES
    (1, 'TOUR-DN-HA-001', 'Đà Nẵng - Hội An - Bà Nà Hills 3N2Đ',
     'da-nang-hoi-an-ba-na-hills-3n2d',
     'Tour miền Trung nổi bật, phù hợp gia đình và nhóm bạn.',
     'Khám phá cầu Rồng, phố cổ Hội An, Bà Nà Hills, thưởng thức ẩm thực miền Trung và nghỉ khách sạn 3 sao gần biển.',
     'Hà Nội', 'Đà Nẵng - Hội An', 3, 2,
     4390000.00, 4390000.00, 3290000.00, 500000.00,
     '/images/tours/da-nang-hoi-an.jpg', NULL, 4.70, 12, 1380,
     'ACTIVE', 4, 1, NOW(), NOW()),
    (2, 'TOUR-SP-002', 'Sapa - Fansipan - Bản Cát Cát 3N2Đ',
     'sapa-fansipan-ban-cat-cat-3n2d',
     'Trải nghiệm khí hậu vùng cao và văn hoá Tây Bắc.',
     'Lịch trình gồm thị trấn Sapa, cáp treo Fansipan, bản Cát Cát, nhà thờ đá và chợ đêm Sapa.',
     'Hà Nội', 'Lào Cai - Sapa', 3, 2,
     3690000.00, 3690000.00, 2790000.00, 400000.00,
     '/images/tours/sapa-fansipan.jpg', NULL, 4.55, 9, 980,
     'ACTIVE', 3, 1, NOW(), NOW()),
    (3, 'TOUR-PQ-003', 'Phú Quốc nghỉ dưỡng 4N3Đ',
     'phu-quoc-nghi-duong-4n3d',
     'Tour biển đảo nghỉ dưỡng, có thời gian tự do.',
     'Tham quan Grand World, VinWonders, Sunset Sanato, làng chài Hàm Ninh và trải nghiệm cáp treo Hòn Thơm.',
     'TP. Hồ Chí Minh', 'Phú Quốc', 4, 3,
     6890000.00, 6890000.00, 5290000.00, 700000.00,
     '/images/tours/phu-quoc.jpg', NULL, 4.80, 18, 2160,
     'ACTIVE', 5, 1, NOW(), NOW()),
    (4, 'TOUR-JP-004', 'Nhật Bản mùa hoa anh đào 5N4Đ',
     'nhat-ban-mua-hoa-anh-dao-5n4d',
     'Hành trình Tokyo - Fuji - Kyoto theo mùa đẹp nhất.',
     'Tour quốc tế trọn gói gồm vé máy bay, khách sạn, visa, tham quan núi Phú Sĩ, Tokyo, Kyoto và trải nghiệm ẩm thực Nhật.',
     'TP. Hồ Chí Minh', 'Tokyo - Fuji - Kyoto', 5, 4,
     32900000.00, 32900000.00, 28900000.00, 5000000.00,
     '/images/tours/nhat-ban-hoa-anh-dao.jpg', NULL, 4.90, 25, 3520,
     'ACTIVE', 6, 1, NOW(), NOW()),
    (5, 'TOUR-TH-005', 'Bangkok - Pattaya 5N4Đ',
     'bangkok-pattaya-5n4d',
     'Tour Thái Lan phổ biến, giá tốt, lịch trình dễ đi.',
     'Tham quan chùa Phật Vàng, đảo Coral, Nong Nooch, chợ nổi 4 miền và mua sắm tại Bangkok.',
     'Hà Nội', 'Bangkok - Pattaya', 5, 4,
     8990000.00, 8990000.00, 7490000.00, 1500000.00,
     '/images/tours/bangkok-pattaya.jpg', NULL, 4.40, 7, 745,
     'ACTIVE', 7, 1, NOW(), NOW());

INSERT INTO tour_schedules (
    id, tour_id, departure_date, return_date, available_seats, booked_seats,
    status, note, created_at, updated_at
) VALUES
    (1, 1, '2026-06-05', '2026-06-07', 35, 12, 'OPEN', 'Khởi hành chắc chắn, còn phòng view biển.', NOW(), NOW()),
    (2, 1, '2026-06-20', '2026-06-22', 30, 28, 'OPEN', 'Còn ít chỗ, ưu tiên khách đặt sớm.', NOW(), NOW()),
    (3, 2, '2026-06-12', '2026-06-14', 25, 10, 'OPEN', 'Nên mang áo khoác nhẹ.', NOW(), NOW()),
    (4, 3, '2026-07-03', '2026-07-06', 40, 18, 'OPEN', 'Combo nghỉ dưỡng hè cho gia đình.', NOW(), NOW()),
    (5, 4, '2027-03-25', '2027-03-29', 30, 22, 'OPEN', 'Lịch trình dự kiến mùa hoa anh đào.', NOW(), NOW()),
    (6, 5, '2026-06-18', '2026-06-22', 45, 15, 'OPEN', 'Đã bao gồm vé tham quan đảo Coral.', NOW(), NOW());

INSERT INTO tour_detail (
    id, tour_id, day_number, day_title, dep, description, image, created_at, updated_at
) VALUES
    (1, 1, 'Ngày 1', 'Hà Nội - Đà Nẵng - Sơn Trà', 'Hà Nội',
     'Đón khách tại sân bay, di chuyển về Đà Nẵng, tham quan bán đảo Sơn Trà và ăn tối hải sản.',
     '/images/tour-detail/son-tra.jpg', NOW(), NOW()),
    (2, 1, 'Ngày 2', 'Bà Nà Hills - Cầu Vàng', 'Đà Nẵng',
     'Tham quan Bà Nà Hills, Cầu Vàng, Fantasy Park và buffet trưa trên đỉnh núi.',
     '/images/tour-detail/ba-na.jpg', NOW(), NOW()),
    (3, 1, 'Ngày 3', 'Hội An - Đà Nẵng - Hà Nội', 'Hội An',
     'Dạo phố cổ Hội An, mua đặc sản miền Trung và tiễn khách ra sân bay.',
     '/images/tour-detail/hoi-an.jpg', NOW(), NOW()),
    (4, 2, 'Ngày 1', 'Hà Nội - Sapa', 'Hà Nội',
     'Di chuyển cao tốc Nội Bài - Lào Cai, tham quan nhà thờ đá và chợ đêm Sapa.',
     '/images/tour-detail/sapa-town.jpg', NOW(), NOW()),
    (5, 2, 'Ngày 2', 'Fansipan - Bản Cát Cát', 'Sapa',
     'Đi cáp treo Fansipan, khám phá bản Cát Cát và thưởng thức đặc sản Tây Bắc.',
     '/images/tour-detail/fansipan.jpg', NOW(), NOW()),
    (6, 3, 'Ngày 1', 'TP.HCM - Phú Quốc', 'TP. Hồ Chí Minh',
     'Bay đến Phú Quốc, nhận phòng resort, tự do tắm biển buổi chiều.',
     '/images/tour-detail/phu-quoc-bien.jpg', NOW(), NOW()),
    (7, 4, 'Ngày 1', 'TP.HCM - Tokyo', 'TP. Hồ Chí Minh',
     'Làm thủ tục bay đến Tokyo, nhận phòng và nghỉ ngơi sau chuyến bay.',
     '/images/tour-detail/tokyo.jpg', NOW(), NOW()),
    (8, 5, 'Ngày 1', 'Hà Nội - Bangkok - Pattaya', 'Hà Nội',
     'Bay đến Bangkok, di chuyển Pattaya, dùng bữa tối và nhận phòng khách sạn.',
     '/images/tour-detail/pattaya.jpg', NOW(), NOW());

INSERT INTO coupons (
    id, coupon_code, coupon_name, description, valid_from, valid_to,
    max_usage_total, status, created_by, created_at, updated_at
) VALUES
    (1, 'HE2026', 'Ưu đãi hè 2026', 'Giảm 500.000đ cho tour nội địa mùa hè.', '2026-05-01 00:00:00', '2026-08-31 23:59:59',
     200, 'ACTIVE', 1, NOW(), NOW()),
    (2, 'NHATBAN2027', 'Đặt sớm Nhật Bản', 'Giảm 2.000.000đ cho tour Nhật Bản đặt trước 60 ngày.', '2026-05-01 00:00:00', '2027-02-28 23:59:59',
     80, 'ACTIVE', 1, NOW(), NOW()),
    (3, 'KHACHMOI', 'Ưu đãi khách hàng mới', 'Giảm 300.000đ cho đơn đầu tiên.', '2026-01-01 00:00:00', '2026-12-31 23:59:59',
     500, 'ACTIVE', 1, NOW(), NOW());

INSERT INTO orders (
    id, order_code, user_id, total_amount, discount_amount, final_amount,
    order_status, payment_status, payment_method, payment_date, transaction_id,
    customer_note, admin_note, created_at, updated_at
) VALUES
    (1, 'OD202605140001', 3, 12070000.00, 500000.00, 11570000.00,
     'CONFIRMED', 'PAID', 'BANK_TRANSFER', '2026-05-14 09:35:00', 'VCB202605140001',
     'Gia đình có một bé 8 tuổi, cần phòng gần thang máy.', 'Đã xác nhận thanh toán và gửi voucher.',
     '2026-05-14 09:10:00', '2026-05-14 09:35:00'),
    (2, 'OD202605150002', 4, 13780000.00, 300000.00, 13480000.00,
     'PENDING', 'UNPAID', 'COD', NULL, NULL,
     'Tư vấn thêm lịch bay buổi sáng.', 'Nhân viên cần gọi xác nhận trước 18h.',
     '2026-05-15 14:20:00', '2026-05-15 14:20:00'),
    (3, 'OD202605160003', 5, 65800000.00, 2000000.00, 63800000.00,
     'CONFIRMED', 'PAID', 'CREDIT_CARD', '2026-05-16 20:05:00', 'VNPAY202605160003',
     'Cần hỗ trợ hồ sơ visa Nhật.', 'Đã nhận đủ hộ chiếu scan.',
     '2026-05-16 19:40:00', '2026-05-16 20:05:00');

INSERT INTO order_details (
    id, order_id, tour_id, tour_schedule_id, tour_name,
    departure_date, return_date, adult_quantity, child_quantity, infant_quantity,
    adult_price, child_price, infant_price, subtotal
) VALUES
    (1, 1, 1, 1, 'Đà Nẵng - Hội An - Bà Nà Hills 3N2Đ',
     '2026-06-05', '2026-06-07', 2, 1, 0,
     4390000.00, 3290000.00, 500000.00, 12070000.00),
    (2, 2, 3, 4, 'Phú Quốc nghỉ dưỡng 4N3Đ',
     '2026-07-03', '2026-07-06', 2, 0, 0,
     6890000.00, 5290000.00, 700000.00, 13780000.00),
    (3, 3, 4, 5, 'Nhật Bản mùa hoa anh đào 5N4Đ',
     '2027-03-25', '2027-03-29', 2, 0, 0,
     32900000.00, 28900000.00, 5000000.00, 65800000.00);

INSERT INTO order_participants (
    id, order_detail_id, full_name, date_of_birth, gender, nationality,
    participant_type, passport_number, special_requirements
) VALUES
    (1, 1, 'Lê Văn Nam', '1996-04-12', 'MALE', 'Việt Nam', 'ADULT', 'B1234567', 'Ăn ít cay'),
    (2, 1, 'Nguyễn Thu Hà', '1997-09-08', 'FEMALE', 'Việt Nam', 'ADULT', 'B7654321', NULL),
    (3, 1, 'Lê Gia Hân', '2018-03-20', 'FEMALE', 'Việt Nam', 'CHILD', NULL, 'Cần ghế ngồi trẻ em trên xe'),
    (4, 2, 'Phạm Thuỳ Linh', '1998-11-03', 'FEMALE', 'Việt Nam', 'ADULT', 'C2345678', 'Phòng giường đôi'),
    (5, 2, 'Đỗ Minh Anh', '1998-02-17', 'FEMALE', 'Việt Nam', 'ADULT', 'C8765432', NULL),
    (6, 3, 'Hoàng Gia Bảo', '1992-06-25', 'MALE', 'Việt Nam', 'ADULT', 'P12345678', 'Cần hỗ trợ visa'),
    (7, 3, 'Vũ Thanh Mai', '1993-01-11', 'FEMALE', 'Việt Nam', 'ADULT', 'P87654321', 'Ăn chay 1 bữa');

INSERT INTO coupon_usage (id, coupon_id, user_id, order_id, discount_amount, used_at) VALUES
    (1, 1, 3, 1, 500000.00, '2026-05-14 09:12:00'),
    (2, 3, 4, 2, 300000.00, '2026-05-15 14:21:00'),
    (3, 2, 5, 3, 2000000.00, '2026-05-16 19:42:00');

INSERT INTO reviews (
    id, user_id, tour_id, order_id, rating, title, comment, images,
    location_rating, service_rating, price_rating, is_verified_purchase,
    status, admin_reply, replied_at, created_at, updated_at
) VALUES
    (1, 3, 1, 1, 5, 'Lịch trình hợp lý, hướng dẫn viên nhiệt tình',
     'Gia đình tôi rất hài lòng, khách sạn sạch và bữa ăn phù hợp trẻ nhỏ.',
     '/images/reviews/review-da-nang-1.jpg', 5, 5, 4, TRUE,
     'APPROVED', 'Cảm ơn anh Nam đã tin tưởng dịch vụ của chúng tôi.', '2026-05-18 08:30:00',
     '2026-05-17 21:10:00', '2026-05-18 08:30:00'),
    (2, 4, 3, 2, 4, 'Tư vấn nhanh, giá ổn',
     'Tôi chưa khởi hành nhưng nhân viên tư vấn chi tiết và phản hồi nhanh.',
     NULL, 4, 5, 4, TRUE,
     'APPROVED', NULL, NULL, '2026-05-16 10:00:00', '2026-05-16 10:00:00');

INSERT INTO contacts (
    id, full_name, email, phone, message, admin_reply, replied_at, created_at
) VALUES
    (1, 'Ngô Phương Anh', 'phuonganh.ngo@example.com', '0933555777',
     'Tôi muốn hỏi tour Đà Nẵng tháng 7 có hỗ trợ khách ăn chay không?',
     'Dạ tour có hỗ trợ suất ăn chay nếu khách báo trước khi khởi hành 5 ngày.',
     '2026-05-14 16:10:00', '2026-05-14 15:40:00'),
    (2, 'Bùi Quốc Huy', 'huy.bui@example.com', '0944666888',
     'Công ty có xuất hóa đơn VAT cho tour Nhật Bản không?',
     NULL, NULL, '2026-05-15 11:25:00');

INSERT INTO notifications (
    id, user_id, title, content, notification_type, reference_id, is_read, created_at
) VALUES
    (1, 3, 'Đơn hàng đã được xác nhận',
     'Đơn OD202605140001 đã thanh toán thành công. Voucher tour đã được gửi qua email.',
     'ORDER', 1, FALSE, '2026-05-14 09:36:00'),
    (2, 4, 'Đơn hàng đang chờ xác nhận',
     'Nhân viên tư vấn sẽ liên hệ để xác nhận thông tin tour Phú Quốc.',
     'ORDER', 2, FALSE, '2026-05-15 14:22:00'),
    (3, 5, 'Hồ sơ visa Nhật Bản',
     'Vui lòng bổ sung ảnh chân dung nền trắng trước ngày 20/05/2026.',
     'VISA', 3, TRUE, '2026-05-16 20:10:00');

INSERT INTO cart (
    id, user_id, tour_id, tour_schedule_id, adult_quantity, child_quantity,
    infant_quantity, created_at, updated_at
) VALUES
    (1, 3, 2, 3, 2, 0, 0, NOW(), NOW()),
    (2, 4, 5, 6, 2, 1, 0, NOW(), NOW());

INSERT INTO wishlists (id, user_id, tour_id, created_at) VALUES
    (1, 3, 3, NOW()),
    (2, 3, 4, NOW()),
    (3, 4, 1, NOW()),
    (4, 5, 5, NOW());

INSERT INTO settings (
    id, setting_key, setting_value, setting_type, group_name, description, updated_at
) VALUES
    (1, 'site_name', 'Du Lịch Việt Demo', 'TEXT', 'GENERAL', 'Tên website hiển thị trên giao diện.', NOW()),
    (2, 'hotline', '1900 6868', 'TEXT', 'GENERAL', 'Số hotline tư vấn tour.', NOW()),
    (3, 'booking_deposit_percent', '30', 'NUMBER', 'BOOKING', 'Phần trăm đặt cọc tối thiểu khi giữ chỗ.', NOW()),
    (4, 'bank_account_name', 'CONG TY TNHH DU LICH VIET DEMO', 'TEXT', 'PAYMENT', 'Tên chủ tài khoản nhận chuyển khoản.', NOW()),
    (5, 'bank_account_number', '123456789', 'TEXT', 'PAYMENT', 'Số tài khoản nhận chuyển khoản.', NOW());

INSERT INTO statistics_daily (
    id, stat_date, total_orders, total_bookings, total_revenue,
    new_users, page_views, created_at
) VALUES
    (1, '2026-05-14', 1, 1, 11570000.00, 3, 1240, NOW()),
    (2, '2026-05-15', 1, 1, 0.00, 1, 980, NOW()),
    (3, '2026-05-16', 1, 1, 63800000.00, 1, 1560, NOW());

SELECT setval(pg_get_serial_sequence('roles', 'id'), COALESCE((SELECT MAX(id) FROM roles), 1));
SELECT setval(pg_get_serial_sequence('users', 'id'), COALESCE((SELECT MAX(id) FROM users), 1));
SELECT setval(pg_get_serial_sequence('categories', 'id'), COALESCE((SELECT MAX(id) FROM categories), 1));
SELECT setval(pg_get_serial_sequence('tours', 'id'), COALESCE((SELECT MAX(id) FROM tours), 1));
SELECT setval(pg_get_serial_sequence('tour_schedules', 'id'), COALESCE((SELECT MAX(id) FROM tour_schedules), 1));
SELECT setval(pg_get_serial_sequence('tour_detail', 'id'), COALESCE((SELECT MAX(id) FROM tour_detail), 1));
SELECT setval(pg_get_serial_sequence('coupons', 'id'), COALESCE((SELECT MAX(id) FROM coupons), 1));
SELECT setval(pg_get_serial_sequence('orders', 'id'), COALESCE((SELECT MAX(id) FROM orders), 1));
SELECT setval(pg_get_serial_sequence('order_details', 'id'), COALESCE((SELECT MAX(id) FROM order_details), 1));
SELECT setval(pg_get_serial_sequence('order_participants', 'id'), COALESCE((SELECT MAX(id) FROM order_participants), 1));
SELECT setval(pg_get_serial_sequence('coupon_usage', 'id'), COALESCE((SELECT MAX(id) FROM coupon_usage), 1));
SELECT setval(pg_get_serial_sequence('reviews', 'id'), COALESCE((SELECT MAX(id) FROM reviews), 1));
SELECT setval(pg_get_serial_sequence('contacts', 'id'), COALESCE((SELECT MAX(id) FROM contacts), 1));
SELECT setval(pg_get_serial_sequence('notifications', 'id'), COALESCE((SELECT MAX(id) FROM notifications), 1));
SELECT setval(pg_get_serial_sequence('cart', 'id'), COALESCE((SELECT MAX(id) FROM cart), 1));
SELECT setval(pg_get_serial_sequence('wishlists', 'id'), COALESCE((SELECT MAX(id) FROM wishlists), 1));
SELECT setval(pg_get_serial_sequence('settings', 'id'), COALESCE((SELECT MAX(id) FROM settings), 1));
SELECT setval(pg_get_serial_sequence('statistics_daily', 'id'), COALESCE((SELECT MAX(id) FROM statistics_daily), 1));

COMMIT;
