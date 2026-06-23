/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80044
 Source Host           : localhost:3306
 Source Schema         : hotel_system

 Target Server Type    : MySQL
 Target Server Version : 80044
 File Encoding         : 65001

 Date: 27/05/2026 13:37:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_name`(`name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `group_id` int(0) NOT NULL,
  `permission_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissions_permission_fk`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissions_group_fk` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_permission_fk` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int(0) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_fk` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 92 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 3, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 3, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 3, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 3, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 2, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 2, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 2, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 2, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO `auth_permission` VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO `auth_permission` VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO `auth_permission` VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO `auth_permission` VALUES (21, 'Can add 用户', 6, 'add_user');
INSERT INTO `auth_permission` VALUES (22, 'Can change 用户', 6, 'change_user');
INSERT INTO `auth_permission` VALUES (23, 'Can delete 用户', 6, 'delete_user');
INSERT INTO `auth_permission` VALUES (24, 'Can view 用户', 6, 'view_user');
INSERT INTO `auth_permission` VALUES (25, 'Can add 房型', 8, 'add_roomtype');
INSERT INTO `auth_permission` VALUES (26, 'Can change 房型', 8, 'change_roomtype');
INSERT INTO `auth_permission` VALUES (27, 'Can delete 房型', 8, 'delete_roomtype');
INSERT INTO `auth_permission` VALUES (28, 'Can view 房型', 8, 'view_roomtype');
INSERT INTO `auth_permission` VALUES (29, 'Can add 房间', 7, 'add_room');
INSERT INTO `auth_permission` VALUES (30, 'Can change 房间', 7, 'change_room');
INSERT INTO `auth_permission` VALUES (31, 'Can delete 房间', 7, 'delete_room');
INSERT INTO `auth_permission` VALUES (32, 'Can view 房间', 7, 'view_room');
INSERT INTO `auth_permission` VALUES (33, 'Can add 预订', 9, 'add_booking');
INSERT INTO `auth_permission` VALUES (34, 'Can change 预订', 9, 'change_booking');
INSERT INTO `auth_permission` VALUES (35, 'Can delete 预订', 9, 'delete_booking');
INSERT INTO `auth_permission` VALUES (36, 'Can view 预订', 9, 'view_booking');
INSERT INTO `auth_permission` VALUES (37, 'Can add 入住记录', 10, 'add_checkinrecord');
INSERT INTO `auth_permission` VALUES (38, 'Can change 入住记录', 10, 'change_checkinrecord');
INSERT INTO `auth_permission` VALUES (39, 'Can delete 入住记录', 10, 'delete_checkinrecord');
INSERT INTO `auth_permission` VALUES (40, 'Can view 入住记录', 10, 'view_checkinrecord');
INSERT INTO `auth_permission` VALUES (41, 'Can add 评论', 11, 'add_review');
INSERT INTO `auth_permission` VALUES (42, 'Can change 评论', 11, 'change_review');
INSERT INTO `auth_permission` VALUES (43, 'Can delete 评论', 11, 'delete_review');
INSERT INTO `auth_permission` VALUES (44, 'Can view 评论', 11, 'view_review');
INSERT INTO `auth_permission` VALUES (45, 'Can add 收藏', 12, 'add_favorite');
INSERT INTO `auth_permission` VALUES (46, 'Can change 收藏', 12, 'change_favorite');
INSERT INTO `auth_permission` VALUES (47, 'Can delete 收藏', 12, 'delete_favorite');
INSERT INTO `auth_permission` VALUES (48, 'Can view 收藏', 12, 'view_favorite');
INSERT INTO `auth_permission` VALUES (49, 'Can add 消息通知', 13, 'add_notification');
INSERT INTO `auth_permission` VALUES (50, 'Can change 消息通知', 13, 'change_notification');
INSERT INTO `auth_permission` VALUES (51, 'Can delete 消息通知', 13, 'delete_notification');
INSERT INTO `auth_permission` VALUES (52, 'Can view 消息通知', 13, 'view_notification');
INSERT INTO `auth_permission` VALUES (53, 'Can add 标签', 15, 'add_tag');
INSERT INTO `auth_permission` VALUES (54, 'Can change 标签', 15, 'change_tag');
INSERT INTO `auth_permission` VALUES (55, 'Can delete 标签', 15, 'delete_tag');
INSERT INTO `auth_permission` VALUES (56, 'Can view 标签', 15, 'view_tag');
INSERT INTO `auth_permission` VALUES (57, 'Can add 房型标签', 14, 'add_roomtypetag');
INSERT INTO `auth_permission` VALUES (58, 'Can change 房型标签', 14, 'change_roomtypetag');
INSERT INTO `auth_permission` VALUES (59, 'Can delete 房型标签', 14, 'delete_roomtypetag');
INSERT INTO `auth_permission` VALUES (60, 'Can view 房型标签', 14, 'view_roomtypetag');
INSERT INTO `auth_permission` VALUES (61, 'Can add 轮播图', 16, 'add_banner');
INSERT INTO `auth_permission` VALUES (62, 'Can change 轮播图', 16, 'change_banner');
INSERT INTO `auth_permission` VALUES (63, 'Can delete 轮播图', 16, 'delete_banner');
INSERT INTO `auth_permission` VALUES (64, 'Can view 轮播图', 16, 'view_banner');
INSERT INTO `auth_permission` VALUES (65, 'Can add 优惠券', 17, 'add_coupon');
INSERT INTO `auth_permission` VALUES (66, 'Can change 优惠券', 17, 'change_coupon');
INSERT INTO `auth_permission` VALUES (67, 'Can delete 优惠券', 17, 'delete_coupon');
INSERT INTO `auth_permission` VALUES (68, 'Can view 优惠券', 17, 'view_coupon');
INSERT INTO `auth_permission` VALUES (69, 'Can add 用户优惠券', 19, 'add_usercoupon');
INSERT INTO `auth_permission` VALUES (70, 'Can change 用户优惠券', 19, 'change_usercoupon');
INSERT INTO `auth_permission` VALUES (71, 'Can delete 用户优惠券', 19, 'delete_usercoupon');
INSERT INTO `auth_permission` VALUES (72, 'Can view 用户优惠券', 19, 'view_usercoupon');
INSERT INTO `auth_permission` VALUES (73, 'Can add 促销活动', 18, 'add_promotion');
INSERT INTO `auth_permission` VALUES (74, 'Can change 促销活动', 18, 'change_promotion');
INSERT INTO `auth_permission` VALUES (75, 'Can delete 促销活动', 18, 'delete_promotion');
INSERT INTO `auth_permission` VALUES (76, 'Can view 促销活动', 18, 'view_promotion');
INSERT INTO `auth_permission` VALUES (77, 'Can add 操作日志', 21, 'add_operationlog');
INSERT INTO `auth_permission` VALUES (78, 'Can change 操作日志', 21, 'change_operationlog');
INSERT INTO `auth_permission` VALUES (79, 'Can delete 操作日志', 21, 'delete_operationlog');
INSERT INTO `auth_permission` VALUES (80, 'Can view 操作日志', 21, 'view_operationlog');
INSERT INTO `auth_permission` VALUES (81, 'Can add 登录日志', 20, 'add_loginlog');
INSERT INTO `auth_permission` VALUES (82, 'Can change 登录日志', 20, 'change_loginlog');
INSERT INTO `auth_permission` VALUES (83, 'Can delete 登录日志', 20, 'delete_loginlog');
INSERT INTO `auth_permission` VALUES (84, 'Can view 登录日志', 20, 'view_loginlog');
INSERT INTO `auth_permission` VALUES (85, 'Can add 系统配置', 22, 'add_systemconfig');
INSERT INTO `auth_permission` VALUES (86, 'Can change 系统配置', 22, 'change_systemconfig');
INSERT INTO `auth_permission` VALUES (87, 'Can delete 系统配置', 22, 'delete_systemconfig');
INSERT INTO `auth_permission` VALUES (88, 'Can view 系统配置', 22, 'view_systemconfig');
INSERT INTO `auth_permission` VALUES (89, 'Can add 支付记录', 23, 'add_payment');
INSERT INTO `auth_permission` VALUES (90, 'Can change 支付记录', 23, 'change_payment');
INSERT INTO `auth_permission` VALUES (91, 'Can delete 支付记录', 23, 'delete_payment');
INSERT INTO `auth_permission` VALUES (92, 'Can view 支付记录', 23, 'view_payment');

-- ----------------------------
-- Table structure for banners
-- ----------------------------
DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort_order` int unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `start_time` datetime(6) NULL DEFAULT NULL,
  `end_time` datetime(6) NULL DEFAULT NULL,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `banners_sort_order`(`sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banners
-- ----------------------------
INSERT INTO `banners` VALUES (1, '欢迎入住', '享受舒适住宿体验', 'banners/banner1.jpg', '/rooms', 1, 1, '2026-03-29 16:31:25.000000', '2027-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `banners` VALUES (2, '限时优惠', '豪华房型8折起', 'banners/banner2.jpg', '/promotions', 2, 1, '2026-03-29 16:31:25.000000', '2026-06-29 16:31:25.000000', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');

-- ----------------------------
-- Table structure for bookings
-- ----------------------------
DROP TABLE IF EXISTS `bookings`;
CREATE TABLE `bookings`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL,
  `room_id` int(0) NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `guests` int unsigned NOT NULL,
  `total_price` decimal(10, 2) NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `special_requests` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `bookings_user_id`(`user_id`) USING BTREE,
  INDEX `bookings_room_id`(`room_id`) USING BTREE,
  INDEX `bookings_status`(`status`) USING BTREE,
  INDEX `bookings_check_in_date`(`check_in_date`) USING BTREE,
  INDEX `idx_bookings_user_status`(`user_id`, `status`) USING BTREE,
  INDEX `idx_bookings_room_status`(`room_id`, `status`) USING BTREE,
  INDEX `idx_bookings_dates`(`check_in_date`, `check_out_date`) USING BTREE,
  CONSTRAINT `bookings_room_fk` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `bookings_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bookings
-- ----------------------------
INSERT INTO `bookings` VALUES (1, 1, 3, '2026-03-29', '2026-03-30', 1, 388.00, 'cancelled', '', 'admin', '13523443453', '2026-03-29 10:15:55.996604', '2026-03-29 10:16:03.553857');
INSERT INTO `bookings` VALUES (6, 9, 2, '2026-04-03', '2026-04-05', 2, 576.00, 'pending', '', 'user2', '13900139006', '2026-03-29 14:03:12.873738', '2026-03-29 14:03:12.873738');
INSERT INTO `bookings` VALUES (7, 8, 3, '2026-04-08', '2026-04-10', 3, 776.00, 'pending', '', 'user1', '13900139005', '2026-03-29 14:03:12.882743', '2026-03-29 14:03:12.882743');
INSERT INTO `bookings` VALUES (8, 7, 3, '2026-04-01', '2026-04-02', 1, 388.00, 'pending', '', 'user', '13900139004', '2026-03-31 07:44:38.232816', '2026-03-31 07:44:38.232816');
INSERT INTO `bookings` VALUES (9, 7, 3, '2026-04-25', '2026-04-27', 1, 776.00, 'cancelled', '', 'user', '13900139004', '2026-04-25 08:48:37.693051', '2026-05-13 03:32:16.486624');
INSERT INTO `bookings` VALUES (10, 7, 3, '2026-05-13', '2026-05-14', 1, 388.00, 'cancelled', '', 'user', '13900139004', '2026-05-13 03:32:40.414466', '2026-05-14 14:00:13.656975');
INSERT INTO `bookings` VALUES (16, 7, 5, '2026-05-14', '2026-05-16', 1, 976.00, 'cancelled', '', 'user', '13900139004', '2026-05-14 14:04:13.420399', '2026-05-14 14:08:50.020700');

-- ----------------------------
-- Table structure for checkin_records
-- ----------------------------
DROP TABLE IF EXISTS `checkin_records`;
CREATE TABLE `checkin_records`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `booking_id` int(0) NOT NULL,
  `actual_check_in` datetime(6) NULL,
  `actual_check_out` datetime(6) NULL DEFAULT NULL,
  `id_card_image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `deposit` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `deposit_returned` tinyint(1) NOT NULL DEFAULT 0,
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `checkin_records_booking_id`(`booking_id`) USING BTREE,
  CONSTRAINT `checkin_records_booking_fk` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupons
-- ----------------------------
DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `coupon_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `discount_value` decimal(10, 2) NOT NULL,
  `min_amount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `max_discount` decimal(10, 2) NULL DEFAULT NULL,
  `total_count` int unsigned NOT NULL,
  `used_count` int unsigned NOT NULL,
  `per_user_limit` int unsigned NOT NULL,
  `start_time` datetime(6) NULL,
  `end_time` datetime(6) NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `coupons_code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coupons
-- ----------------------------
INSERT INTO `coupons` VALUES (1, 'NEWUSER100', '新用户专享优惠券', 'fixed', 100.00, 300.00, NULL, 1000, 0, 1, '2026-03-29 16:31:25.000000', '2027-03-29 16:31:25.000000', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `coupons` VALUES (2, 'VIP50', 'VIP会员折扣券', 'percentage', 10.00, 500.00, 200.00, 500, 0, 3, '2026-03-29 16:31:25.000000', '2026-09-29 16:31:25.000000', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `coupons` VALUES (3, 'WEEKEND200', '周末特惠券', 'fixed', 200.00, 800.00, NULL, 200, 0, 1, '2026-03-29 16:31:25.000000', '2026-06-29 16:31:25.000000', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int(0) NULL DEFAULT NULL,
  `user_id` bigint(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_fk` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (9, 'bookings', 'booking');
INSERT INTO `django_content_type` VALUES (10, 'bookings', 'checkinrecord');
INSERT INTO `django_content_type` VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (12, 'favorites', 'favorite');
INSERT INTO `django_content_type` VALUES (20, 'logs', 'loginlog');
INSERT INTO `django_content_type` VALUES (21, 'logs', 'operationlog');
INSERT INTO `django_content_type` VALUES (13, 'notifications', 'notification');
INSERT INTO `django_content_type` VALUES (16, 'operations', 'banner');
INSERT INTO `django_content_type` VALUES (17, 'operations', 'coupon');
INSERT INTO `django_content_type` VALUES (18, 'operations', 'promotion');
INSERT INTO `django_content_type` VALUES (19, 'operations', 'usercoupon');
INSERT INTO `django_content_type` VALUES (23, 'payments', 'payment');
INSERT INTO `django_content_type` VALUES (11, 'reviews', 'review');
INSERT INTO `django_content_type` VALUES (7, 'rooms', 'room');
INSERT INTO `django_content_type` VALUES (8, 'rooms', 'roomtype');
INSERT INTO `django_content_type` VALUES (5, 'sessions', 'session');
INSERT INTO `django_content_type` VALUES (22, 'system', 'systemconfig');
INSERT INTO `django_content_type` VALUES (14, 'tags', 'roomtypetag');
INSERT INTO `django_content_type` VALUES (15, 'tags', 'tag');
INSERT INTO `django_content_type` VALUES (6, 'users', 'user');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2026-03-29 09:01:20.093490');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2026-03-29 09:01:38.956809');
INSERT INTO `django_migrations` VALUES (3, 'auth', '0001_initial', '2026-03-29 09:01:38.966437');
INSERT INTO `django_migrations` VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2026-03-29 09:01:38.970482');
INSERT INTO `django_migrations` VALUES (5, 'auth', '0003_alter_user_email_max_length', '2026-03-29 09:01:38.973429');
INSERT INTO `django_migrations` VALUES (6, 'auth', '0004_alter_user_username_opts', '2026-03-29 09:01:38.977869');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0005_alter_user_last_login_null', '2026-03-29 09:01:38.981112');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0006_require_contenttypes_0002', '2026-03-29 09:01:38.984963');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2026-03-29 09:01:38.988036');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0008_alter_user_username_max_length', '2026-03-29 09:01:38.992409');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2026-03-29 09:01:38.995465');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0010_alter_group_name_max_length', '2026-03-29 09:01:39.003173');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0011_update_proxy_permissions', '2026-03-29 09:01:39.007680');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0012_alter_user_first_name_max_length', '2026-03-29 09:01:39.012220');
INSERT INTO `django_migrations` VALUES (15, 'users', '0001_initial', '2026-03-29 09:01:39.016546');
INSERT INTO `django_migrations` VALUES (16, 'admin', '0001_initial', '2026-03-29 09:01:39.021148');
INSERT INTO `django_migrations` VALUES (17, 'admin', '0002_logentry_remove_auto_add', '2026-03-29 09:01:39.025718');
INSERT INTO `django_migrations` VALUES (18, 'admin', '0003_logentry_add_action_flag_choices', '2026-03-29 09:01:39.028772');
INSERT INTO `django_migrations` VALUES (19, 'rooms', '0001_initial', '2026-03-29 09:01:39.033112');
INSERT INTO `django_migrations` VALUES (20, 'bookings', '0001_initial', '2026-03-29 09:01:39.036219');
INSERT INTO `django_migrations` VALUES (21, 'bookings', '0002_initial', '2026-03-29 09:01:39.040555');
INSERT INTO `django_migrations` VALUES (22, 'favorites', '0001_initial', '2026-03-29 09:01:39.045547');
INSERT INTO `django_migrations` VALUES (23, 'logs', '0001_initial', '2026-03-29 09:01:39.049177');
INSERT INTO `django_migrations` VALUES (24, 'notifications', '0001_initial', '2026-03-29 09:01:39.052248');
INSERT INTO `django_migrations` VALUES (25, 'operations', '0001_initial', '2026-03-29 09:01:39.056840');
INSERT INTO `django_migrations` VALUES (26, 'payments', '0001_initial', '2026-03-29 09:01:39.061579');
INSERT INTO `django_migrations` VALUES (27, 'reviews', '0001_initial', '2026-03-29 09:01:39.064651');
INSERT INTO `django_migrations` VALUES (28, 'reviews', '0002_initial', '2026-03-29 09:01:39.069136');
INSERT INTO `django_migrations` VALUES (29, 'rooms', '0002_alter_roomtype_image', '2026-03-29 09:01:39.073173');
INSERT INTO `django_migrations` VALUES (30, 'rooms', '0003_remove_room_images_alter_roomtype_image_roomimage', '2026-03-29 09:01:39.076833');
INSERT INTO `django_migrations` VALUES (31, 'rooms', '0004_room_images_delete_roomimage', '2026-03-29 09:01:39.081423');
INSERT INTO `django_migrations` VALUES (32, 'rooms', '0005_alter_roomtype_image_max_length', '2026-03-29 09:01:39.084529');
INSERT INTO `django_migrations` VALUES (33, 'sessions', '0001_initial', '2026-03-29 09:01:39.089095');
INSERT INTO `django_migrations` VALUES (34, 'system', '0001_initial', '2026-03-29 09:01:39.092257');
INSERT INTO `django_migrations` VALUES (35, 'tags', '0001_initial', '2026-03-29 09:01:39.096862');
INSERT INTO `django_migrations` VALUES (36, 'users', '0002_alter_user_avatar', '2026-03-29 09:01:39.101388');
INSERT INTO `django_migrations` VALUES (37, 'payments', '0002_alter_payment_payment_no', '2026-03-29 11:58:53.614515');
INSERT INTO `django_migrations` VALUES (38, 'users', '0003_alter_user_avatar_alter_user_role', '2026-03-29 11:58:53.693719');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('0m6qlwyzaiy6gb912ythnj0exy80egr7', '.eJxVjEsOAiEQRO_C2pAG-bp07xlIN40yaiCZz8p4dyWZha4qqfeqXiLhtta0LWVOE4uTUOLw2xHmR2kD8B3brcvc2zpPJIcid7rIS-fyPO_u30HFpX7XmkyO0QEYYK3ZBw_2CHFECBwJIlv0oK1CKsUb64oDb65ZYXAcSLw_puI2vA:1w6mR0:C-l30rFDHYj-arlYqxgDYF1Rq6PcE_01y_1asgnvfgc', '2026-04-12 09:27:54.658647');
INSERT INTO `django_session` VALUES ('55nr366necnu8lqs3mcjml9qfgbca2zb', '.eJxVjEsOAiEQRO_C2pAG-bp07xlIN40yaiCZz8p4dyWZha4qqfeqXiLhtta0LWVOE4uTUOLw2xHmR2kD8B3brcvc2zpPJIcid7rIS-fyPO_u30HFpX7XmkyO0QEYYK3ZBw_2CHFECBwJIlv0oK1CKsUb64oDb65ZYXAcSLw_puI2vA:1w6mRE:DSLmNf27nPj_SfyFE1Qf6VBzbVW66vCFUkYeZHmsUeM', '2026-04-12 09:28:08.663769');
INSERT INTO `django_session` VALUES ('blm5evh8ehwast54y2ebrqr8rlfkzoc4', '.eJxVjDsOwjAQBe_iGlm2s_5R0nMGa51d4wBypDipEHeHSCmgfTPzXiLhtta0dV7SROIstDj9bhnHB7cd0B3bbZbj3NZlynJX5EG7vM7Ez8vh_h1U7PVbA5hYdHBOFcLCLitmMNYapUczBMDooEAwVoUyePZEEcAFQ2jRs87i_QHJSjdO:1w7UCg:9uHWCGQ6hXdvgwt8OT43AyzOFLaPia7t68YRAgVPDTk', '2026-04-14 08:12:02.091058');
INSERT INTO `django_session` VALUES ('hngnv49mz90tvl5sjwczbci1gwqie0pv', '.eJxVjEsOAiEQRO_C2pAG-bp07xlIN40yaiCZz8p4dyWZha4qqfeqXiLhtta0LWVOE4uTUOLw2xHmR2kD8B3brcvc2zpPJIcid7rIS-fyPO_u30HFpX7XmkyO0QEYYK3ZBw_2CHFECBwJIlv0oK1CKsUb64oDb65ZYXAcSLw_puI2vA:1w6mRt:dUTAj6z3C4Ik7CNwtw7OAE8_sFR2AEDMfN2_56q4WqM', '2026-04-12 09:28:49.704273');
INSERT INTO `django_session` VALUES ('ltj39qpx0sbsc95y81g6i8qvpap1el0x', '.eJxVjEsOAiEQRO_C2pAG-bp07xlIN40yaiCZz8p4dyWZha4qqfeqXiLhtta0LWVOE4uTUOLw2xHmR2kD8B3brcvc2zpPJIcid7rIS-fyPO_u30HFpX7XmkyO0QEYYK3ZBw_2CHFECBwJIlv0oK1CKsUb64oDb65ZYXAcSLw_puI2vA:1w6mQR:bye4qUI2xoNTyF5z4nDuowa_i4_ZQOkpi9EgRTkCbNM', '2026-04-12 09:27:19.978656');
INSERT INTO `django_session` VALUES ('tthu8yxle80bd70zlq0zib3zfr9ug4yq', '.eJxVjEEOwiAQRe_C2pAOBUZcuvcMZGBAqgaS0q6Md7dNutDte-__t_C0LsWvPc1-YnERKE6_LFB8proLflC9NxlbXeYpyD2Rh-3y1ji9rkf7d1Col22drTPq7CCCHYIJOXEeaINsQKdRx6QwIERHSgM6BBoNWUSmEaNlC-LzBeU_N7E:1wGZcT:oRJLYKi9nosxMVYI_zZrOtx3WDnlqnLBDr3jcFEkAUo', '2026-05-09 09:48:13.106281');

-- ----------------------------
-- Table structure for favorites
-- ----------------------------
DROP TABLE IF EXISTS `favorites`;
CREATE TABLE `favorites`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL,
  `room_type_id` int(0) NOT NULL,
  `created_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `favorites_user_id_room_type_id`(`user_id`, `room_type_id`) USING BTREE,
  INDEX `favorites_room_type_id`(`room_type_id`) USING BTREE,
  CONSTRAINT `favorites_room_type_fk` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `favorites_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for login_logs
-- ----------------------------
DROP TABLE IF EXISTS `login_logs`;
CREATE TABLE `login_logs`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NULL DEFAULT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'success',
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `login_logs_user_id`(`user_id`) USING BTREE,
  INDEX `login_logs_status`(`status`) USING BTREE,
  CONSTRAINT `login_logs_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `notification_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `notifications_user_id`(`user_id`) USING BTREE,
  INDEX `notifications_is_read`(`is_read`) USING BTREE,
  INDEX `idx_notifications_user_read`(`user_id`, `is_read`) USING BTREE,
  CONSTRAINT `notifications_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for operation_logs
-- ----------------------------
DROP TABLE IF EXISTS `operation_logs`;
CREATE TABLE `operation_logs`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NULL DEFAULT NULL,
  `action` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `object_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `operation_logs_user_id`(`user_id`) USING BTREE,
  INDEX `operation_logs_action`(`action`) USING BTREE,
  INDEX `operation_logs_model_name`(`model_name`) USING BTREE,
  CONSTRAINT `operation_logs_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for payments
-- ----------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `payment_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `booking_id` int(0) NOT NULL,
  `user_id` bigint(0) NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'alipay',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `transaction_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `paid_at` datetime(6) NULL DEFAULT NULL,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `payments_payment_no`(`payment_no`) USING BTREE,
  UNIQUE INDEX `payments_booking_id`(`booking_id`) USING BTREE,
  INDEX `payments_user_id`(`user_id`) USING BTREE,
  INDEX `payments_status`(`status`) USING BTREE,
  CONSTRAINT `payments_booking_fk` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `payments_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payments
-- ----------------------------
INSERT INTO `payments` VALUES (1, 'PAYAEDF6516DE09485A', 1, 1, 388.00, 'alipay', 'failed', '', NULL, '2026-03-29 10:15:56.038067', '2026-03-29 10:16:03.540401');
INSERT INTO `payments` VALUES (6, 'PAY6C0C5A615BD44A11', 8, 7, 388.00, 'alipay', 'pending', '', NULL, '2026-03-31 07:44:38.576363', '2026-03-31 07:44:38.576363');
INSERT INTO `payments` VALUES (7, 'PAYC318ACA0F4724AFF', 9, 7, 776.00, 'alipay', 'success', 'TXN202604250848507', '2026-04-25 08:48:50.908795', '2026-04-25 08:48:37.724450', '2026-04-25 08:48:50.908795');
INSERT INTO `payments` VALUES (8, 'PAYAD3F84C4C4E3441B', 10, 7, 388.00, 'alipay', 'pending', '', NULL, '2026-05-13 03:32:40.439497', '2026-05-13 03:32:40.439497');
INSERT INTO `payments` VALUES (14, 'PAYD85EC78CC7BB4A59', 16, 7, 976.00, 'alipay', 'success', 'TXN2026051414041714', '2026-05-14 14:04:17.508490', '2026-05-14 14:04:13.442236', '2026-05-14 14:04:17.508490');

-- ----------------------------
-- Table structure for promotion_room_types
-- ----------------------------
DROP TABLE IF EXISTS `promotion_room_types`;
CREATE TABLE `promotion_room_types`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(0) NOT NULL,
  `roomtype_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `promotion_room_types_promotion_id_roomtype_id`(`promotion_id`, `roomtype_id`) USING BTREE,
  INDEX `promotion_room_types_roomtype_fk`(`roomtype_id`) USING BTREE,
  CONSTRAINT `promotion_room_types_promotion_fk` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `promotion_room_types_roomtype_fk` FOREIGN KEY (`roomtype_id`) REFERENCES `room_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for promotions
-- ----------------------------
DROP TABLE IF EXISTS `promotions`;
CREATE TABLE `promotions`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `discount_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'percentage',
  `discount_value` decimal(10, 2) NOT NULL,
  `start_time` datetime(6) NULL,
  `end_time` datetime(6) NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `sort_order` int unsigned NOT NULL,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `promotions_status`(`status`) USING BTREE,
  INDEX `promotions_start_time`(`start_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of promotions
-- ----------------------------
INSERT INTO `promotions` VALUES (1, '春季特惠活动', '春季入住享受8折优惠，限时抢购！活动期间入住指定房型，即可享受超值折扣。房型设施齐全，服务周到，是您出行的理想选择。', '', 'percentage', 20.00, '2026-03-28 11:58:33.533118', '2026-04-28 11:58:33.533118', 'active', 1, '2026-03-29 11:58:33.556370', '2026-03-29 11:58:33.556370');
INSERT INTO `promotions` VALUES (2, '周末狂欢节', '周末入住立减100元！周五至周日入住，享受超值优惠。适合家庭出游、情侣度假、商务出行。', '', 'fixed', 100.00, '2026-03-28 12:04:50.591690', '2026-05-28 12:04:50.591690', 'active', 2, '2026-03-29 12:04:50.596273', '2026-03-29 12:04:50.596273');

-- ----------------------------
-- Table structure for promotions_room_types
-- ----------------------------
DROP TABLE IF EXISTS `promotions_room_types`;
CREATE TABLE `promotions_room_types`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(0) NOT NULL,
  `roomtype_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `promotions_room_types_promotion_id_roomtype_id_uniq`(`promotion_id`, `roomtype_id`) USING BTREE,
  INDEX `promotions_room_types_roomtype_id_fk`(`roomtype_id`) USING BTREE,
  CONSTRAINT `promotions_room_types_promotion_id_fk` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `promotions_room_types_roomtype_id_fk` FOREIGN KEY (`roomtype_id`) REFERENCES `room_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of promotions_room_types
-- ----------------------------
INSERT INTO `promotions_room_types` VALUES (3, 2, 2);
INSERT INTO `promotions_room_types` VALUES (1, 2, 8);
INSERT INTO `promotions_room_types` VALUES (2, 2, 9);

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL,
  `room_type_id` int(0) NOT NULL,
  `rating` int unsigned NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `images` json NOT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `reviews_user_id`(`user_id`) USING BTREE,
  INDEX `reviews_room_type_id`(`room_type_id`) USING BTREE,
  INDEX `reviews_rating`(`rating`) USING BTREE,
  INDEX `idx_reviews_roomtype_rating`(`room_type_id`, `rating`) USING BTREE,
  CONSTRAINT `reviews_room_type_fk` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `reviews_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reviews
-- ----------------------------
INSERT INTO `reviews` VALUES (1, 10, 9, 5, '非常满意的入住体验', '房间非常干净整洁，设施齐全，床很舒适。前台服务态度很好，入住和退房都很顺利。早餐种类丰富，味道也不错。下次出差还会选择这里！', '[]', 1, '2026-03-29 11:51:27.926349', '2026-03-29 11:51:27.926349');
INSERT INTO `reviews` VALUES (2, 9, 8, 4, '性价比不错的酒店', '位置很好，交通便利。房间大小适中，卫生条件良好。唯一不足是隔音效果一般，晚上有点吵。总体来说性价比不错，推荐入住。', '[]', 1, '2026-03-29 11:51:27.932956', '2026-03-29 11:51:27.932956');
INSERT INTO `reviews` VALUES (3, 8, 2, 5, '家庭出游首选', '带孩子来玩，订的家庭房非常宽敞，孩子很喜欢。酒店还有儿童游乐区，非常贴心。服务人员也很热情，主动提供了儿童拖鞋和牙刷。强烈推荐给有孩子的家庭！', '[]', 1, '2026-03-29 11:51:27.937319', '2026-03-29 11:51:27.937319');
INSERT INTO `reviews` VALUES (4, 10, 8, 4, '商务出差好选择', '酒店位置优越，周边配套设施完善。房间干净整洁，WiFi速度快，适合商务办公。早餐丰富，服务周到。下次出差还会选择入住。', '[]', 0, '2026-03-29 11:51:27.940926', '2026-05-14 13:07:35.015663');

-- ----------------------------
-- Table structure for room_type_tags
-- ----------------------------
DROP TABLE IF EXISTS `room_type_tags`;
CREATE TABLE `room_type_tags`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `room_type_id` int(0) NOT NULL,
  `tag_id` int(0) NOT NULL,
  `created_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `room_type_tags_room_type_id_tag_id`(`room_type_id`, `tag_id`) USING BTREE,
  INDEX `room_type_tags_tag_fk`(`tag_id`) USING BTREE,
  CONSTRAINT `room_type_tags_room_type_fk` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `room_type_tags_tag_fk` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room_type_tags
-- ----------------------------
INSERT INTO `room_type_tags` VALUES (1, 3, 1, '2026-03-29 16:31:25.000000');
INSERT INTO `room_type_tags` VALUES (2, 4, 1, '2026-03-29 16:31:25.000000');
INSERT INTO `room_type_tags` VALUES (3, 5, 1, '2026-03-29 16:31:25.000000');
INSERT INTO `room_type_tags` VALUES (4, 1, 2, '2026-03-29 16:31:25.000000');
INSERT INTO `room_type_tags` VALUES (5, 2, 2, '2026-03-29 16:31:25.000000');
INSERT INTO `room_type_tags` VALUES (6, 2, 4, '2026-03-29 16:31:25.000000');
INSERT INTO `room_type_tags` VALUES (7, 1, 5, '2026-03-29 16:31:25.000000');
INSERT INTO `room_type_tags` VALUES (8, 3, 5, '2026-03-29 16:31:25.000000');

-- ----------------------------
-- Table structure for room_types
-- ----------------------------
DROP TABLE IF EXISTS `room_types`;
CREATE TABLE `room_types`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `capacity` int unsigned NOT NULL,
  `size` int unsigned NOT NULL,
  `amenities` json NOT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `room_types_price`(`price`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room_types
-- ----------------------------
INSERT INTO `room_types` VALUES (1, '标准单人间', '舒适温馨的标准单人间，配备单人床，适合商务出差或独自旅行。', 288.00, 1, 25, '[\"WiFi\", \"空调\", \"电视\", \"独立卫浴\", \"24小时热水\"]', 'room_types/2022-10-31-12-32-35_Hj7olpd.png', 0, '2026-03-29 16:31:25.000000', '2026-03-29 10:11:05.792842');
INSERT INTO `room_types` VALUES (2, '标准双人间', '宽敞明亮的标准双人间，适合双人居住。', 388.00, 2, 30, '[\"WiFi\", \"空调\", \"电视\", \"独立卫浴\", \"24小时热水\", \"迷你吧\"]', 'room_types/6_y15uvs5.jpg', 1, '2026-03-29 16:31:25.000000', '2026-05-27 04:57:15.466301');
INSERT INTO `room_types` VALUES (3, '豪华大床房', '豪华舒适的大床房，配备1.8米大床，享受高品质住宿体验。', 488.00, 2, 35, '[\"WiFi\", \"空调\", \"电视\", \"独立卫浴\", \"24小时热水\", \"迷你吧\", \"浴缸\", \"保险箱\"]', 'room_types/3_bH8Ebur.png', 1, '2026-03-29 16:31:25.000000', '2026-05-27 04:57:26.141328');
INSERT INTO `room_types` VALUES (4, '行政套房', '尊贵行政套房，独立客厅与卧室，享受私密空间。', 888.00, 2, 60, '[\"WiFi\", \"空调\", \"电视\", \"独立卫浴\", \"24小时热水\", \"迷你吧\", \"浴缸\", \"保险箱\", \"行政酒廊\", \"健身房\"]', 'room_types/4_3PxvvPL.jpg', 1, '2026-03-29 16:31:25.000000', '2026-05-27 04:57:33.281123');
INSERT INTO `room_types` VALUES (5, '总统套房', '顶级总统套房，奢华装修，享受至尊服务。', 2888.00, 4, 120, '[\"WiFi\", \"空调\", \"电视\", \"独立卫浴\", \"24小时热水\", \"迷你吧\", \"浴缸\", \"保险箱\", \"行政酒廊\", \"健身房\", \"私人管家\", \"专属车位\"]', 'room_types/5_azABxIF.jpg', 1, '2026-03-29 16:31:25.000000', '2026-05-27 04:57:39.408155');
INSERT INTO `room_types` VALUES (6, '1', '', 100.00, 2, 30, '[]', '', 0, '2026-03-29 09:50:56.750028', '2026-03-29 10:09:13.331015');
INSERT INTO `room_types` VALUES (7, '啪啪啪', '', 100.00, 2, 30, '[]', 'room_types/2022-10-31-12-32-35_6IhHad7.png', 0, '2026-03-29 10:04:20.181873', '2026-03-29 10:09:22.040948');
INSERT INTO `room_types` VALUES (8, '标准单人间', '单人居住', 288.00, 1, 30, '[\"免费WiFi\", \"空调\", \"24小时热水\", \"吹风机\"]', 'room_types/2_5gNUCmI.jpg', 1, '2026-03-29 10:12:42.349134', '2026-05-27 04:57:01.339851');
INSERT INTO `room_types` VALUES (9, '特惠单人间', '性价比~', 90.00, 1, 30, '[\"免费WiFi\", \"空调\", \"吹风机\"]', 'room_types/1_bqvrCkb.jpg', 1, '2026-03-29 10:14:06.018880', '2026-05-27 04:56:39.406748');
INSERT INTO `room_types` VALUES (10, '双人间', '', 200.00, 2, 30, '[]', '', 0, '2026-05-14 13:07:08.035378', '2026-05-14 13:07:13.496768');
INSERT INTO `room_types` VALUES (11, '单人间', '', 100.00, 2, 30, '[]', '', 0, '2026-05-14 13:59:41.942247', '2026-05-14 13:59:46.642419');
INSERT INTO `room_types` VALUES (12, '单人间', '', 100.00, 2, 30, '[]', '', 0, '2026-05-14 14:08:37.917594', '2026-05-14 14:08:42.289753');
INSERT INTO `room_types` VALUES (13, '单人间', '', 100.00, 2, 30, '[]', '', 0, '2026-05-14 14:23:45.892798', '2026-05-14 14:23:53.188437');

-- ----------------------------
-- Table structure for rooms
-- ----------------------------
DROP TABLE IF EXISTS `rooms`;
CREATE TABLE `rooms`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `room_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `floor` int unsigned NOT NULL,
  `room_type_id` int(0) NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'available',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `images` json NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `rooms_room_number`(`room_number`) USING BTREE,
  INDEX `rooms_room_type_id`(`room_type_id`) USING BTREE,
  INDEX `rooms_status`(`status`) USING BTREE,
  CONSTRAINT `rooms_room_type_fk` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rooms
-- ----------------------------
INSERT INTO `rooms` VALUES (2, '102', 1, 1, 'available', '标准单人间，朝北，安静', '[]', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `rooms` VALUES (3, '103', 1, 2, 'maintenance', '标准双人间，朝南', '[]', 1, '2026-03-29 16:31:25.000000', '2026-05-14 14:23:24.706303');
INSERT INTO `rooms` VALUES (4, '104', 1, 2, 'cleaning', '标准双人间，朝北', '[]', 1, '2026-03-29 16:31:25.000000', '2026-05-14 14:08:57.126257');
INSERT INTO `rooms` VALUES (5, '201', 2, 3, 'available', '豪华大床房，朝南，带阳台', '[]', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `rooms` VALUES (6, '202', 2, 3, 'available', '豪华大床房，朝南', '[]', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `rooms` VALUES (7, '203', 2, 3, 'occupied', '豪华大床房，朝北', '[]', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `rooms` VALUES (8, '301', 3, 4, 'available', '行政套房，朝南', '[]', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `rooms` VALUES (9, '302', 3, 4, 'available', '行政套房，朝南，带阳台', '[]', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `rooms` VALUES (10, '401', 4, 5, 'available', '总统套房，全景落地窗', '[]', 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `rooms` VALUES (11, '105', 1, 9, 'available', '机制的价格', '[]', 0, '2026-05-14 13:06:29.350598', '2026-05-14 13:06:33.825397');
INSERT INTO `rooms` VALUES (16, '106', 1, 2, 'cleaning', '', '[]', 1, '2026-05-14 14:18:02.431058', '2026-05-14 14:24:03.196449');
INSERT INTO `rooms` VALUES (17, '101', 1, 9, 'available', '', '[]', 1, '2026-05-14 14:23:13.346025', '2026-05-14 14:23:13.346025');

-- ----------------------------
-- Table structure for system_configs
-- ----------------------------
DROP TABLE IF EXISTS `system_configs`;
CREATE TABLE `system_configs`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `system_configs_key`(`key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_configs
-- ----------------------------
INSERT INTO `system_configs` VALUES (1, 'hotel_name', '酒店管理系统', '酒店名称', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `system_configs` VALUES (2, 'hotel_address', '北京市朝阳区xxx路xxx号', '酒店地址', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `system_configs` VALUES (3, 'hotel_phone', '010-12345678', '酒店电话', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `system_configs` VALUES (4, 'hotel_email', 'info@hotel.com', '酒店邮箱', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `system_configs` VALUES (5, 'check_in_time', '14:00', '入住时间', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `system_configs` VALUES (6, 'check_out_time', '12:00', '退房时间', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `system_configs` VALUES (7, 'deposit_amount', '500', '默认押金金额', '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#409EFF',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tags_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tags
-- ----------------------------
INSERT INTO `tags` VALUES (1, '热门推荐', '#F56C6C', '热门推荐的房型', 1, 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `tags` VALUES (2, '特价优惠', '#E6A23C', '正在优惠的房型', 2, 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `tags` VALUES (3, '新开业', '#67C23A', '新装修开业', 3, 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `tags` VALUES (4, '亲子房', '#409EFF', '适合亲子入住', 4, 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');
INSERT INTO `tags` VALUES (5, '商务出行', '#909399', '适合商务出差', 5, 1, '2026-03-29 16:31:25.000000', '2026-03-29 16:31:25.000000');

-- ----------------------------
-- Table structure for user_coupons
-- ----------------------------
DROP TABLE IF EXISTS `user_coupons`;
CREATE TABLE `user_coupons`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL,
  `coupon_id` int(0) NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unused',
  `used_at` datetime(6) NULL DEFAULT NULL,
  `created_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_coupons_user_id`(`user_id`) USING BTREE,
  INDEX `user_coupons_coupon_id`(`coupon_id`) USING BTREE,
  INDEX `user_coupons_status`(`status`) USING BTREE,
  CONSTRAINT `user_coupons_coupon_fk` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_coupons_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'customer',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime(6) NULL,
  `updated_at` datetime(6) NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_username`(`username`) USING BTREE,
  INDEX `users_email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'pbkdf2_sha256$600000$7Fsbn3BGz5yyfcTmBsc28d$L9o+avS8Opr6TQy/a7CZB8NkDFjtylnqT5XeRpAohcc=', '2026-05-27 04:55:34.492572', 1, 'admin', '', '', 'admin@hotel.com', 1, 1, '2026-03-29 16:31:25.000000', 'admin', '', 'avatars/2022-10-31-12-32-35_giQTpOP.png', '', '', '2026-03-29 16:31:25.000000', '2026-05-27 04:55:55.343380');
INSERT INTO `users` VALUES (7, 'pbkdf2_sha256$600000$zU5ufGBt7Is55o3Hw1w2rk$faUouF/LYR/8H/8qwsUgfr1ahz5LDxFN5b8lvLarShg=', '2026-05-14 14:03:53.192129', 0, 'user', '', '', 'user@example.com', 0, 1, '2026-03-29 11:45:51.511497', 'customer', '13900139004', 'avatars/d.jpg', '', '', '2026-03-29 11:45:51.511497', '2026-03-29 14:00:19.346906');
INSERT INTO `users` VALUES (8, 'pbkdf2_sha256$1200000$7nIN7rZ4IDgwBBoRILapYD$NPhYdItfJxER8krGe3aqfImakEQN45zbJmAOLzcDwyw=', NULL, 0, 'user1', '', '', 'user1@example.com', 0, 1, '2026-03-29 11:45:52.477404', 'customer', '13900139005', 'avatars/C.jpg', '', '', '2026-03-29 11:45:52.477404', '2026-03-29 13:59:01.663017');
INSERT INTO `users` VALUES (9, 'pbkdf2_sha256$1200000$KxqE1OluXlxiRDELl21feX$FwOMtiYcu2g9xlp6aSiYHeXe4DNJ+nHsI+XVAUDQrcc=', NULL, 0, 'user2', '', '', 'user2@example.com', 0, 1, '2026-03-29 11:45:53.404117', 'customer', '13900139006', 'avatars/b.jpg', '', '', '2026-03-29 11:45:53.404117', '2026-03-29 13:58:53.691923');
INSERT INTO `users` VALUES (10, 'pbkdf2_sha256$1200000$MOO339ZdHOLtiYB6037Xs1$Qi02PkOfhqUPAsDTAYwnQJffou67SdBJPNEJOrWgJ/4=', NULL, 0, 'user3', '', '', '123456@123.com', 0, 1, '2026-03-29 11:47:48.914088', 'customer', '13524564356', 'avatars/a_CyBb3XC.jpg', '', '', '2026-03-29 11:47:48.914088', '2026-05-27 04:58:28.145521');

-- ----------------------------
-- Table structure for users_groups
-- ----------------------------
DROP TABLE IF EXISTS `users_groups`;
CREATE TABLE `users_groups`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL,
  `group_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_groups_user_id_group_id`(`user_id`, `group_id`) USING BTREE,
  INDEX `users_groups_group_fk`(`group_id`) USING BTREE,
  CONSTRAINT `users_groups_group_fk` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `users_groups_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for users_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `users_user_permissions`;
CREATE TABLE `users_user_permissions`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL,
  `permission_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_user_permissions_user_id_permission_id`(`user_id`, `permission_id`) USING BTREE,
  INDEX `users_user_permissions_permission_fk`(`permission_id`) USING BTREE,
  CONSTRAINT `users_user_permissions_permission_fk` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `users_user_permissions_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- View structure for v_booking_detail
-- ----------------------------
DROP VIEW IF EXISTS `v_booking_detail`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v_booking_detail` AS select `b`.`id` AS `id`,`b`.`user_id` AS `user_id`,`b`.`room_id` AS `room_id`,`b`.`check_in_date` AS `check_in_date`,`b`.`check_out_date` AS `check_out_date`,`b`.`guests` AS `guests`,`b`.`total_price` AS `total_price`,`b`.`status` AS `status`,`b`.`special_requests` AS `special_requests`,`b`.`contact_name` AS `contact_name`,`b`.`contact_phone` AS `contact_phone`,`b`.`created_at` AS `created_at`,`b`.`updated_at` AS `updated_at`,`u`.`username` AS `username`,`u`.`phone` AS `user_phone`,`u`.`email` AS `user_email`,`r`.`room_number` AS `room_number`,`r`.`floor` AS `floor`,`rt`.`name` AS `room_type_name`,`rt`.`price` AS `room_price`,`p`.`payment_no` AS `payment_no`,`p`.`status` AS `payment_status`,`p`.`payment_method` AS `payment_method`,`p`.`paid_at` AS `paid_at` from ((((`bookings` `b` left join `users` `u` on((`b`.`user_id` = `u`.`id`))) left join `rooms` `r` on((`b`.`room_id` = `r`.`id`))) left join `room_types` `rt` on((`r`.`room_type_id` = `rt`.`id`))) left join `payments` `p` on((`b`.`id` = `p`.`booking_id`)));

-- ----------------------------
-- View structure for v_room_type_detail
-- ----------------------------
DROP VIEW IF EXISTS `v_room_type_detail`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `v_room_type_detail` AS select `rt`.`id` AS `id`,`rt`.`name` AS `name`,`rt`.`description` AS `description`,`rt`.`price` AS `price`,`rt`.`capacity` AS `capacity`,`rt`.`size` AS `size`,`rt`.`amenities` AS `amenities`,`rt`.`image` AS `image`,`rt`.`is_active` AS `is_active`,`rt`.`created_at` AS `created_at`,`rt`.`updated_at` AS `updated_at`,group_concat(distinct `t`.`name` order by `t`.`sort_order` ASC separator ',') AS `tag_names`,group_concat(distinct `t`.`color` order by `t`.`sort_order` ASC separator ',') AS `tag_colors`,count(distinct `r`.`id`) AS `room_count`,count(distinct (case when ((`r`.`status` = 'available') and (`r`.`is_active` = 1)) then `r`.`id` end)) AS `available_count`,coalesce(avg(`rv`.`rating`),0) AS `avg_rating`,count(distinct `rv`.`id`) AS `review_count` from ((((`room_types` `rt` left join `room_type_tags` `rtt` on((`rt`.`id` = `rtt`.`room_type_id`))) left join `tags` `t` on(((`rtt`.`tag_id` = `t`.`id`) and (`t`.`is_active` = 1)))) left join `rooms` `r` on((`rt`.`id` = `r`.`room_type_id`))) left join `reviews` `rv` on(((`rt`.`id` = `rv`.`room_type_id`) and (`rv`.`is_visible` = 1)))) group by `rt`.`id`;

-- ----------------------------
-- Procedure structure for sp_check_room_available
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_check_room_available`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_check_room_available`(
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_available_rooms
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_available_rooms`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_available_rooms`(
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
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
