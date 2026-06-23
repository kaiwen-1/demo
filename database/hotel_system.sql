-- =============================================
-- 酒店管理系统 MySQL 数据库脚本
-- 生成时间: 2026-03-29
-- 数据库: hotel_system
-- =============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `hotel_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `hotel_system`;

-- 设置外键检查
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================
-- 清除现有表
-- =============================================
DROP TABLE IF EXISTS `favorites`;
DROP TABLE IF EXISTS `login_logs`;
DROP TABLE IF EXISTS `operation_logs`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `user_coupons`;
DROP TABLE IF EXISTS `coupons`;
DROP TABLE IF EXISTS `promotion_room_types`;
DROP TABLE IF EXISTS `promotions`;
DROP TABLE IF EXISTS `banners`;
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `checkin_records`;
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `room_type_tags`;
DROP TABLE IF EXISTS `tags`;
DROP TABLE IF EXISTS `rooms`;
DROP TABLE IF EXISTS `room_types`;
DROP TABLE IF EXISTS `system_configs`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `users_groups`;
DROP TABLE IF EXISTS `users_user_permissions`;
DROP TABLE IF EXISTS `auth_group_permissions`;
DROP TABLE IF EXISTS `auth_permission`;
DROP TABLE IF EXISTS `auth_group`;
DROP TABLE IF EXISTS `django_content_type`;
DROP TABLE IF EXISTS `django_session`;
DROP TABLE IF EXISTS `django_admin_log`;

-- =============================================
-- Django 内置表
-- =============================================

-- 内容类型表
CREATE TABLE `django_content_type` (
    `id` int NOT NULL AUTO_INCREMENT,
    `app_label` varchar(100) NOT NULL,
    `model` varchar(100) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `django_content_type_app_label_model` (`app_label`, `model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 权限表
CREATE TABLE `auth_permission` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `content_type_id` int NOT NULL,
    `codename` varchar(100) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `auth_permission_content_type_id_codename` (`content_type_id`, `codename`),
    CONSTRAINT `auth_permission_content_type_fk` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 用户组表
CREATE TABLE `auth_group` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(150) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `auth_group_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 用户组权限关联表
CREATE TABLE `auth_group_permissions` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `group_id` int NOT NULL,
    `permission_id` int NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `auth_group_permissions_group_id_permission_id` (`group_id`, `permission_id`),
    CONSTRAINT `auth_group_permissions_group_fk` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
    CONSTRAINT `auth_group_permissions_permission_fk` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Session表
CREATE TABLE `django_session` (
    `session_key` varchar(40) NOT NULL,
    `session_data` longtext NOT NULL,
    `expire_date` datetime(6) NOT NULL,
    PRIMARY KEY (`session_key`),
    KEY `django_session_expire_date` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Admin日志表
CREATE TABLE `django_admin_log` (
    `id` int NOT NULL AUTO_INCREMENT,
    `action_time` datetime(6) NOT NULL,
    `object_id` longtext,
    `object_repr` varchar(200) NOT NULL,
    `action_flag` smallint UNSIGNED NOT NULL,
    `change_message` longtext NOT NULL,
    `content_type_id` int DEFAULT NULL,
    `user_id` bigint NOT NULL,
    PRIMARY KEY (`id`),
    KEY `django_admin_log_content_type_id` (`content_type_id`),
    KEY `django_admin_log_user_id` (`user_id`),
    CONSTRAINT `django_admin_log_content_type_fk` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
    CONSTRAINT `django_admin_log_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 用户表
-- =============================================
CREATE TABLE `users` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `password` varchar(128) NOT NULL,
    `last_login` datetime(6) DEFAULT NULL,
    `is_superuser` tinyint(1) NOT NULL,
    `username` varchar(150) NOT NULL,
    `first_name` varchar(150) NOT NULL,
    `last_name` varchar(150) NOT NULL,
    `email` varchar(254) NOT NULL,
    `is_staff` tinyint(1) NOT NULL,
    `is_active` tinyint(1) NOT NULL,
    `date_joined` datetime(6) NOT NULL,
    `role` varchar(20) NOT NULL DEFAULT 'customer',
    `phone` varchar(20) NOT NULL DEFAULT '',
    `avatar` varchar(100) DEFAULT NULL,
    `id_card` varchar(18) NOT NULL DEFAULT '',
    `address` varchar(200) NOT NULL DEFAULT '',
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `users_username` (`username`),
    KEY `users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 用户组关联表
CREATE TABLE `users_groups` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `user_id` bigint NOT NULL,
    `group_id` int NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `users_groups_user_id_group_id` (`user_id`, `group_id`),
    CONSTRAINT `users_groups_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    CONSTRAINT `users_groups_group_fk` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 用户权限关联表
CREATE TABLE `users_user_permissions` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `user_id` bigint NOT NULL,
    `permission_id` int NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `users_user_permissions_user_id_permission_id` (`user_id`, `permission_id`),
    CONSTRAINT `users_user_permissions_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    CONSTRAINT `users_user_permissions_permission_fk` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 系统配置表
-- =============================================
CREATE TABLE `system_configs` (
    `id` int NOT NULL AUTO_INCREMENT,
    `key` varchar(100) NOT NULL,
    `value` longtext NOT NULL,
    `description` varchar(200) NOT NULL DEFAULT '',
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `system_configs_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 房型表
-- =============================================
CREATE TABLE `room_types` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `description` longtext NOT NULL,
    `price` decimal(10,2) NOT NULL,
    `capacity` int UNSIGNED NOT NULL DEFAULT 2,
    `size` int UNSIGNED NOT NULL DEFAULT 30,
    `amenities` json NOT NULL,
    `image` varchar(100) DEFAULT NULL,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `room_types_price` (`price`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 房间表
-- =============================================
CREATE TABLE `rooms` (
    `id` int NOT NULL AUTO_INCREMENT,
    `room_number` varchar(20) NOT NULL,
    `floor` int UNSIGNED NOT NULL,
    `room_type_id` int NOT NULL,
    `status` varchar(20) NOT NULL DEFAULT 'available',
    `description` longtext NOT NULL,
    `images` json NOT NULL,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `rooms_room_number` (`room_number`),
    KEY `rooms_room_type_id` (`room_type_id`),
    KEY `rooms_status` (`status`),
    CONSTRAINT `rooms_room_type_fk` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 标签表
-- =============================================
CREATE TABLE `tags` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `color` varchar(20) NOT NULL DEFAULT '#409EFF',
    `description` longtext NOT NULL,
    `sort_order` int UNSIGNED NOT NULL DEFAULT 0,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `tags_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 房型标签关联表
-- =============================================
CREATE TABLE `room_type_tags` (
    `id` int NOT NULL AUTO_INCREMENT,
    `room_type_id` int NOT NULL,
    `tag_id` int NOT NULL,
    `created_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `room_type_tags_room_type_id_tag_id` (`room_type_id`, `tag_id`),
    CONSTRAINT `room_type_tags_room_type_fk` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`),
    CONSTRAINT `room_type_tags_tag_fk` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 预订表
-- =============================================
CREATE TABLE `bookings` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` bigint NOT NULL,
    `room_id` int NOT NULL,
    `check_in_date` date NOT NULL,
    `check_out_date` date NOT NULL,
    `guests` int UNSIGNED NOT NULL DEFAULT 1,
    `total_price` decimal(10,2) NOT NULL,
    `status` varchar(20) NOT NULL DEFAULT 'pending',
    `special_requests` longtext NOT NULL,
    `contact_name` varchar(50) NOT NULL,
    `contact_phone` varchar(20) NOT NULL,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `bookings_user_id` (`user_id`),
    KEY `bookings_room_id` (`room_id`),
    KEY `bookings_status` (`status`),
    KEY `bookings_check_in_date` (`check_in_date`),
    CONSTRAINT `bookings_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    CONSTRAINT `bookings_room_fk` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 入住记录表
-- =============================================
CREATE TABLE `checkin_records` (
    `id` int NOT NULL AUTO_INCREMENT,
    `booking_id` int NOT NULL,
    `actual_check_in` datetime(6) NOT NULL,
    `actual_check_out` datetime(6) DEFAULT NULL,
    `id_card_image` varchar(100) DEFAULT NULL,
    `deposit` decimal(10,2) NOT NULL DEFAULT 0.00,
    `deposit_returned` tinyint(1) NOT NULL DEFAULT 0,
    `notes` longtext NOT NULL,
    `created_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `checkin_records_booking_id` (`booking_id`),
    CONSTRAINT `checkin_records_booking_fk` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 评论表
-- =============================================
CREATE TABLE `reviews` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` bigint NOT NULL,
    `room_type_id` int NOT NULL,
    `rating` int UNSIGNED NOT NULL,
    `title` varchar(100) NOT NULL,
    `content` longtext NOT NULL,
    `images` json NOT NULL,
    `is_visible` tinyint(1) NOT NULL DEFAULT 1,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `reviews_user_id` (`user_id`),
    KEY `reviews_room_type_id` (`room_type_id`),
    KEY `reviews_rating` (`rating`),
    CONSTRAINT `reviews_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    CONSTRAINT `reviews_room_type_fk` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 支付记录表
-- =============================================
CREATE TABLE `payments` (
    `id` int NOT NULL AUTO_INCREMENT,
    `payment_no` varchar(64) NOT NULL,
    `booking_id` int NOT NULL,
    `user_id` bigint NOT NULL,
    `amount` decimal(10,2) NOT NULL,
    `payment_method` varchar(20) NOT NULL DEFAULT 'alipay',
    `status` varchar(20) NOT NULL DEFAULT 'pending',
    `transaction_id` varchar(100) NOT NULL DEFAULT '',
    `paid_at` datetime(6) DEFAULT NULL,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `payments_payment_no` (`payment_no`),
    UNIQUE KEY `payments_booking_id` (`booking_id`),
    KEY `payments_user_id` (`user_id`),
    KEY `payments_status` (`status`),
    CONSTRAINT `payments_booking_fk` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
    CONSTRAINT `payments_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 轮播图表
-- =============================================
CREATE TABLE `banners` (
    `id` int NOT NULL AUTO_INCREMENT,
    `title` varchar(100) NOT NULL,
    `subtitle` varchar(200) NOT NULL DEFAULT '',
    `image` varchar(100) NOT NULL,
    `link` varchar(500) NOT NULL DEFAULT '',
    `sort_order` int UNSIGNED NOT NULL DEFAULT 0,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `start_time` datetime(6) DEFAULT NULL,
    `end_time` datetime(6) DEFAULT NULL,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `banners_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 促销活动表
-- =============================================
CREATE TABLE `promotions` (
    `id` int NOT NULL AUTO_INCREMENT,
    `title` varchar(200) NOT NULL,
    `description` longtext NOT NULL,
    `image` varchar(100) DEFAULT NULL,
    `discount_type` varchar(20) NOT NULL DEFAULT 'percentage',
    `discount_value` decimal(10,2) NOT NULL,
    `start_time` datetime(6) NOT NULL,
    `end_time` datetime(6) NOT NULL,
    `status` varchar(20) NOT NULL DEFAULT 'draft',
    `sort_order` int UNSIGNED NOT NULL DEFAULT 0,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `promotions_status` (`status`),
    KEY `promotions_start_time` (`start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 促销活动房型关联表
-- =============================================
CREATE TABLE `promotion_room_types` (
    `id` int NOT NULL AUTO_INCREMENT,
    `promotion_id` int NOT NULL,
    `roomtype_id` int NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `promotion_room_types_promotion_id_roomtype_id` (`promotion_id`, `roomtype_id`),
    CONSTRAINT `promotion_room_types_promotion_fk` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`),
    CONSTRAINT `promotion_room_types_roomtype_fk` FOREIGN KEY (`roomtype_id`) REFERENCES `room_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 优惠券表
-- =============================================
CREATE TABLE `coupons` (
    `id` int NOT NULL AUTO_INCREMENT,
    `code` varchar(50) NOT NULL,
    `name` varchar(100) NOT NULL,
    `coupon_type` varchar(20) NOT NULL DEFAULT 'fixed',
    `discount_value` decimal(10,2) NOT NULL,
    `min_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
    `max_discount` decimal(10,2) DEFAULT NULL,
    `total_count` int UNSIGNED NOT NULL DEFAULT 100,
    `used_count` int UNSIGNED NOT NULL DEFAULT 0,
    `per_user_limit` int UNSIGNED NOT NULL DEFAULT 1,
    `start_time` datetime(6) NOT NULL,
    `end_time` datetime(6) NOT NULL,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `created_at` datetime(6) NOT NULL,
    `updated_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `coupons_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 用户优惠券表
-- =============================================
CREATE TABLE `user_coupons` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` bigint NOT NULL,
    `coupon_id` int NOT NULL,
    `status` varchar(20) NOT NULL DEFAULT 'unused',
    `used_at` datetime(6) DEFAULT NULL,
    `created_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `user_coupons_user_id` (`user_id`),
    KEY `user_coupons_coupon_id` (`coupon_id`),
    KEY `user_coupons_status` (`status`),
    CONSTRAINT `user_coupons_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    CONSTRAINT `user_coupons_coupon_fk` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 消息通知表
-- =============================================
CREATE TABLE `notifications` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` bigint NOT NULL,
    `title` varchar(200) NOT NULL,
    `content` longtext NOT NULL,
    `notification_type` varchar(20) NOT NULL DEFAULT 'system',
    `is_read` tinyint(1) NOT NULL DEFAULT 0,
    `link` varchar(500) NOT NULL DEFAULT '',
    `created_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `notifications_user_id` (`user_id`),
    KEY `notifications_is_read` (`is_read`),
    CONSTRAINT `notifications_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 操作日志表
-- =============================================
CREATE TABLE `operation_logs` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` bigint DEFAULT NULL,
    `action` varchar(20) NOT NULL DEFAULT 'other',
    `model_name` varchar(100) NOT NULL,
    `object_id` varchar(100) NOT NULL DEFAULT '',
    `object_repr` varchar(200) NOT NULL DEFAULT '',
    `detail` longtext NOT NULL,
    `ip_address` char(39) DEFAULT NULL,
    `user_agent` varchar(500) NOT NULL DEFAULT '',
    `created_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `operation_logs_user_id` (`user_id`),
    KEY `operation_logs_action` (`action`),
    KEY `operation_logs_model_name` (`model_name`),
    CONSTRAINT `operation_logs_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 登录日志表
-- =============================================
CREATE TABLE `login_logs` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` bigint DEFAULT NULL,
    `username` varchar(150) NOT NULL,
    `status` varchar(20) NOT NULL DEFAULT 'success',
    `ip_address` char(39) DEFAULT NULL,
    `user_agent` varchar(500) NOT NULL DEFAULT '',
    `message` longtext NOT NULL,
    `created_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `login_logs_user_id` (`user_id`),
    KEY `login_logs_status` (`status`),
    CONSTRAINT `login_logs_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 收藏表
-- =============================================
CREATE TABLE `favorites` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` bigint NOT NULL,
    `room_type_id` int NOT NULL,
    `created_at` datetime(6) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `favorites_user_id_room_type_id` (`user_id`, `room_type_id`),
    KEY `favorites_room_type_id` (`room_type_id`),
    CONSTRAINT `favorites_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    CONSTRAINT `favorites_room_type_fk` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 恢复外键检查
-- =============================================
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- 初始化数据
-- =============================================

-- 插入默认管理员账户 (密码: admin123)
INSERT INTO `users` (`password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`, `role`, `phone`, `avatar`, `id_card`, `address`, `created_at`, `updated_at`) VALUES
('admin123', NULL, 1, 'admin', '', '', 'admin@hotel.com', 1, 1, NOW(), 'admin', '', NULL, '', '', NOW(), NOW());

-- 插入系统配置
INSERT INTO `system_configs` (`key`, `value`, `description`, `created_at`, `updated_at`) VALUES
('hotel_name', '酒店管理系统', '酒店名称', NOW(), NOW()),
('hotel_address', '北京市朝阳区xxx路xxx号', '酒店地址', NOW(), NOW()),
('hotel_phone', '010-12345678', '酒店电话', NOW(), NOW()),
('hotel_email', 'info@hotel.com', '酒店邮箱', NOW(), NOW()),
('check_in_time', '14:00', '入住时间', NOW(), NOW()),
('check_out_time', '12:00', '退房时间', NOW(), NOW()),
('deposit_amount', '500', '默认押金金额', NOW(), NOW());

-- 插入房型数据
INSERT INTO `room_types` (`name`, `description`, `price`, `capacity`, `size`, `amenities`, `image`, `is_active`, `created_at`, `updated_at`) VALUES
('标准单人间', '舒适温馨的标准单人间，配备单人床，适合商务出差或独自旅行。', 288.00, 1, 25, '["WiFi", "空调", "电视", "独立卫浴", "24小时热水"]', NULL, 1, NOW(), NOW()),
('标准双人间', '宽敞明亮的标准双人间，配备双床，适合家庭或朋友出行。', 388.00, 2, 30, '["WiFi", "空调", "电视", "独立卫浴", "24小时热水", "迷你吧"]', NULL, 1, NOW(), NOW()),
('豪华大床房', '豪华舒适的大床房，配备1.8米大床，享受高品质住宿体验。', 488.00, 2, 35, '["WiFi", "空调", "电视", "独立卫浴", "24小时热水", "迷你吧", "浴缸", "保险箱"]', NULL, 1, NOW(), NOW()),
('行政套房', '尊贵行政套房，独立客厅与卧室，享受私密空间。', 888.00, 2, 60, '["WiFi", "空调", "电视", "独立卫浴", "24小时热水", "迷你吧", "浴缸", "保险箱", "行政酒廊", "健身房"]', NULL, 1, NOW(), NOW()),
('总统套房', '顶级总统套房，奢华装修，享受至尊服务。', 2888.00, 4, 120, '["WiFi", "空调", "电视", "独立卫浴", "24小时热水", "迷你吧", "浴缸", "保险箱", "行政酒廊", "健身房", "私人管家", "专属车位"]', NULL, 1, NOW(), NOW());

-- 插入标签数据
INSERT INTO `tags` (`name`, `color`, `description`, `sort_order`, `is_active`, `created_at`, `updated_at`) VALUES
('热门推荐', '#F56C6C', '热门推荐的房型', 1, 1, NOW(), NOW()),
('特价优惠', '#E6A23C', '正在优惠的房型', 2, 1, NOW(), NOW()),
('新开业', '#67C23A', '新装修开业', 3, 1, NOW(), NOW()),
('亲子房', '#409EFF', '适合亲子入住', 4, 1, NOW(), NOW()),
('商务出行', '#909399', '适合商务出差', 5, 1, NOW(), NOW());

-- 插入房间数据
INSERT INTO `rooms` (`room_number`, `floor`, `room_type_id`, `status`, `description`, `images`, `is_active`, `created_at`, `updated_at`) VALUES
('101', 1, 1, 'available', '标准单人间，朝南，采光好', '[]', 1, NOW(), NOW()),
('102', 1, 1, 'available', '标准单人间，朝北，安静', '[]', 1, NOW(), NOW()),
('103', 1, 2, 'available', '标准双人间，朝南', '[]', 1, NOW(), NOW()),
('104', 1, 2, 'available', '标准双人间，朝北', '[]', 1, NOW(), NOW()),
('201', 2, 3, 'available', '豪华大床房，朝南，带阳台', '[]', 1, NOW(), NOW()),
('202', 2, 3, 'available', '豪华大床房，朝南', '[]', 1, NOW(), NOW()),
('203', 2, 3, 'occupied', '豪华大床房，朝北', '[]', 1, NOW(), NOW()),
('301', 3, 4, 'available', '行政套房，朝南', '[]', 1, NOW(), NOW()),
('302', 3, 4, 'available', '行政套房，朝南，带阳台', '[]', 1, NOW(), NOW()),
('401', 4, 5, 'available', '总统套房，全景落地窗', '[]', 1, NOW(), NOW());

-- 插入房型标签关联
INSERT INTO `room_type_tags` (`room_type_id`, `tag_id`, `created_at`) VALUES
(3, 1, NOW()),
(4, 1, NOW()),
(5, 1, NOW()),
(1, 2, NOW()),
(2, 2, NOW()),
(2, 4, NOW()),
(1, 5, NOW()),
(3, 5, NOW());

-- 插入轮播图数据
INSERT INTO `banners` (`title`, `subtitle`, `image`, `link`, `sort_order`, `is_active`, `start_time`, `end_time`, `created_at`, `updated_at`) VALUES
('欢迎入住', '享受舒适住宿体验', 'banners/banner1.jpg', '/rooms', 1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR), NOW(), NOW()),
('限时优惠', '豪华房型8折起', 'banners/banner2.jpg', '/promotions', 2, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), NOW(), NOW());

-- 插入优惠券数据
INSERT INTO `coupons` (`code`, `name`, `coupon_type`, `discount_value`, `min_amount`, `max_discount`, `total_count`, `used_count`, `per_user_limit`, `start_time`, `end_time`, `is_active`, `created_at`, `updated_at`) VALUES
('NEWUSER100', '新用户专享优惠券', 'fixed', 100.00, 300.00, NULL, 1000, 0, 1, NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR), 1, NOW(), NOW()),
('VIP50', 'VIP会员折扣券', 'percentage', 10.00, 500.00, 200.00, 500, 0, 3, NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 1, NOW(), NOW()),
('WEEKEND200', '周末特惠券', 'fixed', 200.00, 800.00, NULL, 200, 0, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 1, NOW(), NOW());

-- =============================================
-- 创建视图
-- =============================================

-- 房型详情视图（包含标签信息）
CREATE OR REPLACE VIEW `v_room_type_detail` AS
SELECT 
    rt.*,
    GROUP_CONCAT(DISTINCT t.name ORDER BY t.sort_order SEPARATOR ',') AS tag_names,
    GROUP_CONCAT(DISTINCT t.color ORDER BY t.sort_order SEPARATOR ',') AS tag_colors,
    COUNT(DISTINCT r.id) AS room_count,
    COUNT(DISTINCT CASE WHEN r.status = 'available' AND r.is_active = 1 THEN r.id END) AS available_count,
    COALESCE(AVG(rv.rating), 0) AS avg_rating,
    COUNT(DISTINCT rv.id) AS review_count
FROM `room_types` rt
LEFT JOIN `room_type_tags` rtt ON rt.id = rtt.room_type_id
LEFT JOIN `tags` t ON rtt.tag_id = t.id AND t.is_active = 1
LEFT JOIN `rooms` r ON rt.id = r.room_type_id
LEFT JOIN `reviews` rv ON rt.id = rv.room_type_id AND rv.is_visible = 1
GROUP BY rt.id;

-- 预订详情视图
CREATE OR REPLACE VIEW `v_booking_detail` AS
SELECT 
    b.*,
    u.username,
    u.phone AS user_phone,
    u.email AS user_email,
    r.room_number,
    r.floor,
    rt.name AS room_type_name,
    rt.price AS room_price,
    p.payment_no,
    p.status AS payment_status,
    p.payment_method,
    p.paid_at
FROM `bookings` b
LEFT JOIN `users` u ON b.user_id = u.id
LEFT JOIN `rooms` r ON b.room_id = r.id
LEFT JOIN `room_types` rt ON r.room_type_id = rt.id
LEFT JOIN `payments` p ON b.id = p.booking_id;

-- =============================================
-- 创建存储过程
-- =============================================

DELIMITER //

-- 检查房间可用性
CREATE PROCEDURE `sp_check_room_available`(
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE,
    OUT p_is_available BOOLEAN
)
BEGIN
    DECLARE conflict_count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO conflict_count
    FROM `bookings`
    WHERE `room_id` = p_room_id
    AND `status` NOT IN ('cancelled')
    AND (
        (`check_in_date` <= p_check_in AND `check_out_date` > p_check_in)
        OR (`check_in_date` < p_check_out AND `check_out_date` >= p_check_out)
        OR (`check_in_date` >= p_check_in AND `check_out_date` <= p_check_out)
    );
    
    SET p_is_available = (conflict_count = 0);
END //

-- 获取可用房间列表
CREATE PROCEDURE `sp_get_available_rooms`(
    IN p_check_in DATE,
    IN p_check_out DATE,
    IN p_room_type_id INT
)
BEGIN
    SELECT r.*, rt.name AS room_type_name, rt.price, rt.capacity
    FROM `rooms` r
    JOIN `room_types` rt ON r.room_type_id = rt.id
    WHERE r.is_active = 1
    AND r.status = 'available'
    AND (p_room_type_id IS NULL OR r.room_type_id = p_room_type_id)
    AND r.id NOT IN (
        SELECT DISTINCT room_id
        FROM `bookings`
        WHERE `status` NOT IN ('cancelled')
        AND (
            (`check_in_date` <= p_check_in AND `check_out_date` > p_check_in)
            OR (`check_in_date` < p_check_out AND `check_out_date` >= p_check_out)
            OR (`check_in_date` >= p_check_in AND `check_out_date` <= p_check_out)
        )
    )
    ORDER BY r.room_number;
END //

DELIMITER ;

-- =============================================
-- 创建触发器
-- =============================================

DELIMITER //

-- 预订状态变更时更新房间状态
CREATE TRIGGER `tr_booking_status_change`
AFTER UPDATE ON `bookings`
FOR EACH ROW
BEGIN
    IF NEW.status = 'checked_in' AND OLD.status != 'checked_in' THEN
        UPDATE `rooms` SET `status` = 'occupied', `updated_at` = NOW() WHERE `id` = NEW.room_id;
    ELSEIF NEW.status = 'checked_out' AND OLD.status != 'checked_out' THEN
        UPDATE `rooms` SET `status` = 'cleaning', `updated_at` = NOW() WHERE `id` = NEW.room_id;
    ELSEIF NEW.status = 'cancelled' AND OLD.status != 'cancelled' THEN
        UPDATE `rooms` SET `status` = 'available', `updated_at` = NOW() WHERE `id` = NEW.room_id;
    END IF;
END //

DELIMITER ;

-- =============================================
-- 创建索引（优化查询性能）
-- =============================================
CREATE INDEX `idx_bookings_user_status` ON `bookings` (`user_id`, `status`);
CREATE INDEX `idx_bookings_room_status` ON `bookings` (`room_id`, `status`);
CREATE INDEX `idx_bookings_dates` ON `bookings` (`check_in_date`, `check_out_date`);
CREATE INDEX `idx_notifications_user_read` ON `notifications` (`user_id`, `is_read`);
CREATE INDEX `idx_reviews_roomtype_rating` ON `reviews` (`room_type_id`, `rating`);

-- =============================================
-- 完成
-- =============================================
SELECT '数据库初始化完成!' AS message;
