-- 1. 创建并使用外卖专属数据库
CREATE DATABASE IF NOT EXISTS waimai_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE waimai_db;

-- 2. 创建用户表 (C端买家)
CREATE TABLE `user` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  `phone` VARCHAR(20) NOT NULL UNIQUE COMMENT '手机号(用于登录)',
  `password` VARCHAR(100) NOT NULL COMMENT '加密后的密码',
  `username` VARCHAR(50) DEFAULT '外卖达人' COMMENT '用户昵称',
  `avatar` VARCHAR(255) COMMENT '用户头像URL',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间'
) ENGINE=InnoDB COMMENT='C端用户表';

-- 3. 创建商家表 (B端老板)
CREATE TABLE `merchant` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  `name` VARCHAR(100) NOT NULL COMMENT '店铺名称',
  `image` VARCHAR(255) COMMENT '店铺头像URL',
  `rating` DECIMAL(3,1) DEFAULT 5.0 COMMENT '店铺评分',
  `balance` DECIMAL(10,2) DEFAULT 0.00 COMMENT '账户余额(营业额)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '入驻时间'
) ENGINE=InnoDB COMMENT='B端商家表';

-- 4. 创建菜品表
CREATE TABLE `product` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  `merchant_id` BIGINT NOT NULL COMMENT '关联的商家ID',
  `name` VARCHAR(100) NOT NULL COMMENT '菜品名称',
  `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
  `image` VARCHAR(255) COMMENT '菜品图片',
  `category_idx` INT DEFAULT 1 COMMENT '分类索引(0:招牌,1:上新等)',
  `sale_count` INT DEFAULT 0 COMMENT '销量',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '上架时间'
) ENGINE=InnoDB COMMENT='菜品信息表';

-- 5. 创建订单表 (核心枢纽)
CREATE TABLE `order_info` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  `order_no` VARCHAR(50) NOT NULL UNIQUE COMMENT '展示给用户的订单编号(如OD123456)',
  `user_id` BIGINT NOT NULL COMMENT '下单的C端用户ID',
  `merchant_id` BIGINT NOT NULL COMMENT '接单的B端商家ID',
  `product_summary` VARCHAR(255) COMMENT '订单商品摘要(如: 香辣鸡腿堡等2件商品)',
  `total_price` DECIMAL(10,2) NOT NULL COMMENT '用户实付总金额(含配送费)',
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT '状态: pending待接单, accepted制作中, ready已出餐, cancelled已取消',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间'
) ENGINE=InnoDB COMMENT='订单流转表';

-- ==========================================
-- 插入一些初始化的测试数据，方便我们后续测试接口
-- ==========================================

-- 模拟插入一个测试商家：苍穹烧烤 (高新店)
INSERT INTO `merchant` (`id`, `name`, `image`, `rating`, `balance`) 
VALUES (1, '苍穹烧烤 (高新店)', '/images/1.jpg', 4.8, 0.00);

-- 模拟插入几个该商家的测试菜品
INSERT INTO `product` (`merchant_id`, `name`, `price`, `image`, `category_idx`, `sale_count`) VALUES 
(1, '苍穹烤羊肉串(5串)', 28.00, '/images/1.jpg', 0, 1200),
(1, '蜜汁烤翅(一对)', 12.00, '/images/1.jpg', 0, 800),
(1, '脆皮炸薯条', 9.00, '/images/1.jpg', 2, 1500),
(1, '手打柠檬红茶', 10.00, '/images/1.jpg', 3, 3000);

-- 模拟插入一个测试用户
INSERT INTO `user` (`id`, `phone`, `password`, `username`) 
VALUES (1, '13800138000', '123456', '吃货小明');
SELECT * FROM order_info;
SELECT * FROM waimai_db.order_info;
-- 1. 创建秒杀商品活动表
CREATE TABLE `flash_sale_product` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  `product_id` BIGINT NOT NULL COMMENT '关联的商品/菜品ID',
  `flash_price` DECIMAL(10,2) NOT NULL COMMENT '秒杀专属价格',
  `stock` INT NOT NULL DEFAULT 0 COMMENT '秒杀剩余库存',
  `start_time` DATETIME NOT NULL COMMENT '秒杀开始时间',
  `end_time` DATETIME NOT NULL COMMENT '秒杀结束时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB COMMENT='限时秒杀商品表';

-- 2. 插入测试数据 (绑定到我们电机烧烤的商品上)
-- 假设 product_id = 1 是“苍穹烤羊肉串(5串)”，秒杀价 9.9，限量 100 份
INSERT INTO `flash_sale_product` (`product_id`, `flash_price`, `stock`, `start_time`, `end_time`) 
VALUES (1, 9.90, 100, '2026-06-01 10:00:00', '2026-06-30 23:59:59');

-- 假设 product_id = 4 是“手打柠檬红茶”，秒杀价 1.0，限量 50 份
INSERT INTO `flash_sale_product` (`product_id`, `flash_price`, `stock`, `start_time`, `end_time`) 
VALUES (4, 1.00, 50, '2026-06-01 10:00:00', '2026-06-30 23:59:59');

USE waimai_db;

-- =========================================================
-- 1. 扩充更多商家 (插入另外 4 家店，连同之前的共有 5 家)
-- =========================================================
INSERT INTO `merchant` (`id`, `name`, `image`, `rating`, `balance`) VALUES 
(2, '麦当劳 (蓝鲸世界店)', '/images/1.jpg', 4.9, 0.00),
(3, '达美乐比萨 (临港店)', '/images/1.jpg', 4.7, 0.00),
(4, '霸王茶姬 (大学城店)', '/images/1.jpg', 4.9, 0.00),
(5, '张亮麻辣烫 (星空广场店)', '/images/1.jpg', 4.6, 0.00);

-- =========================================================
-- 2. 为每一家新店扩充至少 5 个菜品 (涵盖不同的 category_idx 以在侧边栏显示)
-- =========================================================

-- 为 [商家2: 麦当劳] 插入菜品
INSERT INTO `product` (`merchant_id`, `name`, `price`, `image`, `category_idx`, `sale_count`) VALUES 
(2, '经典巨无霸汉堡', 24.00, '/images/1.jpg', 0, 5000),
(2, '麦辣鸡腿堡套餐', 29.90, '/images/1.jpg', 0, 8000),
(2, '金黄大薯条', 14.00, '/images/1.jpg', 2, 6000),
(2, '麦乐鸡块(5块)', 12.50, '/images/1.jpg', 2, 4500),
(2, '冰雪草莓新地', 11.00, '/images/1.jpg', 3, 2000);

-- 为 [商家3: 达美乐比萨] 插入菜品
INSERT INTO `product` (`merchant_id`, `name`, `price`, `image`, `category_idx`, `sale_count`) VALUES 
(3, '照烧风味牛肉土豆比萨', 59.00, '/images/1.jpg', 0, 2100),
(3, '夏威夷风情比萨', 49.00, '/images/1.jpg', 0, 1500),
(3, '意式肉酱面', 28.00, '/images/1.jpg', 1, 800),
(3, '香甜烤翅(4块)', 22.00, '/images/1.jpg', 2, 1100),
(3, '百事可乐(听装)', 8.00, '/images/1.jpg', 3, 3000);

-- 为 [商家4: 霸王茶姬] 插入菜品
INSERT INTO `product` (`merchant_id`, `name`, `price`, `image`, `category_idx`, `sale_count`) VALUES 
(4, '伯牙绝弦(大杯)', 20.00, '/images/1.jpg', 0, 15000),
(4, '花田乌龙(中杯)', 16.00, '/images/1.jpg', 0, 8000),
(4, '寻香山茶(大杯)', 22.00, '/images/1.jpg', 1, 5000),
(4, '青沫观音', 18.00, '/images/1.jpg', 1, 4000),
(4, '桂馥兰香', 18.00, '/images/1.jpg', 2, 3500);

-- 为 [商家5: 张亮麻辣烫] 插入菜品
INSERT INTO `product` (`merchant_id`, `name`, `price`, `image`, `category_idx`, `sale_count`) VALUES 
(5, '经典骨汤麻辣烫套餐(荤素搭配)', 25.80, '/images/1.jpg', 0, 3200),
(5, '番茄浓汤麻辣烫(不辣)', 28.00, '/images/1.jpg', 0, 1800),
(5, '手工撒尿牛丸(3个)', 6.00, '/images/1.jpg', 2, 4100),
(5, '鲜嫩福袋(2个)', 5.00, '/images/1.jpg', 2, 2900),
(5, '冰镇酸梅汤', 5.00, '/images/1.jpg', 3, 2000);


USE waimai_db;


TRUNCATE TABLE `flash_sale_product`;

INSERT INTO `flash_sale_product` (`product_id`, `flash_price`, `stock`, `start_time`, `end_time`) 
VALUES 
(1, 9.90, 100, NOW(), DATE_ADD(NOW(), INTERVAL 24 HOUR)),
(2, 9.90, 100, NOW(), DATE_ADD(NOW(), INTERVAL 24 HOUR)),
(3, 19.90, 0, NOW(), DATE_ADD(NOW(), INTERVAL 24 HOUR)),
(4, 88.00, 500, NOW(), DATE_ADD(NOW(), INTERVAL 24 HOUR));



-- 确保秒杀活动表存在，且关联到菜品
-- 1. 告诉 MySQL 使用 waimai_db 数据库
USE waimai_db;

-- 2. 执行建表语句
CREATE TABLE IF NOT EXISTS `flash_sale_product` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT NOT NULL COMMENT '菜品ID',
  `flash_price` DECIMAL(10,2) NOT NULL COMMENT '秒杀特价',
  `stock` INT NOT NULL COMMENT '秒杀限量库存',
  `start_time` DATETIME NOT NULL COMMENT '秒杀开始时间',
  `end_time` DATETIME NOT NULL COMMENT '秒杀结束时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

ALTER TABLE `merchant` ADD COLUMN `username` VARCHAR(50) DEFAULT NULL COMMENT '商家端登录账号';
ALTER TABLE `merchant` ADD COLUMN `password` VARCHAR(100) DEFAULT NULL COMMENT '商家端登录密码';

-- 更新已有商家的测试账号密码
UPDATE `merchant` SET `username` = 'sao_kao_boss', `password` = '123456' WHERE `id` = 1;
SELECT product_id FROM flash_sale_product WHERE id = 11;
SELECT stock FROM flash_sale_product WHERE product_id = 15;