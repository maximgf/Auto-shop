-- Создание базы данных для автомагазина
CREATE DATABASE IF NOT EXISTS auto_shop;
USE auto_shop;

-- 1. Таблица "Клиенты"
CREATE TABLE IF NOT EXISTS clients (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Уникальный ID клиента',
    first_name VARCHAR(50) NOT NULL COMMENT 'Имя',
    last_name VARCHAR(50) NOT NULL COMMENT 'Фамилия',
    phone VARCHAR(20) COMMENT 'Телефон',
    email VARCHAR(100) COMMENT 'Email',
    address VARCHAR(255) COMMENT 'Адрес'
) COMMENT='Клиенты магазина';

-- 2. Таблица "Сотрудники"
CREATE TABLE IF NOT EXISTS employees (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Уникальный ID сотрудника',
    first_name VARCHAR(50) NOT NULL COMMENT 'Имя',
    last_name VARCHAR(50) NOT NULL COMMENT 'Фамилия',
    position VARCHAR(50) NOT NULL COMMENT 'Должность',
    hire_date DATE NOT NULL COMMENT 'Дата приема',
    phone VARCHAR(20) COMMENT 'Телефон',
    email VARCHAR(100) COMMENT 'Email'
) COMMENT='Сотрудники магазина';

-- 3. Таблица "Категории товаров"
CREATE TABLE IF NOT EXISTS categories (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Уникальный ID категории',
    name VARCHAR(100) NOT NULL UNIQUE COMMENT 'Название категории'
) COMMENT='Категории товаров';

-- 4. Таблица "Поставщики"
CREATE TABLE IF NOT EXISTS suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Уникальный ID поставщика',
    company_name VARCHAR(100) NOT NULL COMMENT 'Название компании',
    contact_name VARCHAR(100) COMMENT 'Контактное лицо',
    phone VARCHAR(20) NOT NULL COMMENT 'Телефон',
    email VARCHAR(100) COMMENT 'Email',
    address VARCHAR(255) NOT NULL COMMENT 'Адрес'
) COMMENT='Поставщики товаров';

-- 5. Таблица "Товары"
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Уникальный ID товара',
    name VARCHAR(255) NOT NULL COMMENT 'Название',
    description TEXT COMMENT 'Описание',
    price DECIMAL(10,2) NOT NULL COMMENT 'Цена',
    stock_quantity INT NOT NULL DEFAULT 0 COMMENT 'Количество на складе',
    category_id INT NOT NULL COMMENT 'ID категории',
    supplier_id INT NOT NULL COMMENT 'ID поставщика',
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
) COMMENT='Товары магазина';

-- 6. Таблица "Заказы"
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Уникальный ID заказа',
    client_id INT NOT NULL COMMENT 'ID клиента',
    employee_id INT NOT NULL COMMENT 'ID сотрудника',
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата заказа',
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending' COMMENT 'Статус',
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
) COMMENT='Заказы клиентов';

-- 7. Таблица "Позиции заказа"
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Уникальный ID позиции',
    order_id INT NOT NULL COMMENT 'ID заказа',
    product_id INT NOT NULL COMMENT 'ID товара',
    quantity INT NOT NULL COMMENT 'Количество',
    price DECIMAL(10,2) NOT NULL COMMENT 'Цена на момент заказа',
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
) COMMENT='Состав заказов';

-- 8. Представление "Детали заказов"
CREATE VIEW view_order_details AS
SELECT 
    o.id AS order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS client,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.price) AS total
FROM orders o
JOIN clients c ON o.client_id = c.id
JOIN employees e ON o.employee_id = e.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;

-- 9. Процедура для заполнения тестовыми данными
DELIMITER $$

CREATE PROCEDURE populate_test_data()
BEGIN
    -- Категории
    INSERT INTO categories (name) VALUES
    ('Автозапчасти'),
    ('Шины и диски'),
    ('Автохимия');

    -- Поставщики
    INSERT INTO suppliers (company_name, contact_name, phone, email, address) VALUES
    ('ООО "Автодеталь"', 'Иван Петров', '+79150000001', 'info@autodetal.ru', 'Москва'),
    ('ТД "Колесо"', 'Алексей Сидоров', '+79150000002', 'info@koleso.ru', 'Санкт-Петербург');

    -- Товары
    INSERT INTO products (name, description, price, stock_quantity, category_id, supplier_id) VALUES
    ('Тормозные колодки', 'Для легковых авто', 2500.00, 50, 1, 1),
    ('Летние шины', 'R16 205/55', 5000.00, 100, 2, 2),
    ('Антифриз', 'Красный -40°C', 1200.00, 200, 3, 1);

    -- Клиенты
    INSERT INTO clients (first_name, last_name, phone, email, address) VALUES
    ('Андрей', 'Иванов', '+79160000001', 'andrey@mail.ru', 'Москва'),
    ('Сергей', 'Петров', '+79160000002', 'sergey@mail.ru', 'Казань');

    -- Сотрудники
    INSERT INTO employees (first_name, last_name, position, hire_date, phone, email) VALUES
    ('Ольга', 'Сидорова', 'Менеджер', '2022-01-15', '+79170000001', 'olga@shop.ru'),
    ('Мария', 'Иванова', 'Кассир', '2023-05-20', '+79170000002', 'maria@shop.ru');

    -- Заказы
    INSERT INTO orders (client_id, employee_id, status) VALUES
    (1, 1, 'completed'),
    (2, 2, 'pending');

    -- Позиции заказов
    INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
    (1, 1, 2, 2500.00),
    (1, 3, 1, 1200.00),
    (2, 2, 4, 5000.00);
END$$

DELIMITER ;

-- Вызов процедуры для заполнения данных
CALL populate_test_data();