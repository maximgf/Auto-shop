# Документация для базы данных "auto_shop"  
## 1. Структура базы данных  

### Таблицы и их описание  

#### **Таблица `clients` (Клиенты)**  
- **Назначение**: Хранение информации о клиентах магазина.  
- **Поля**:  
  - `id` (уникальный ID клиента, автоинкремент)  
  - `first_name` (имя)  
  - `last_name` (фамилия)  
  - `phone`, `email`, `address` (контактные данные).  

#### **Таблица `employees` (Сотрудники)**  
- **Назначение**: Данные о сотрудниках магазина.  
- **Поля**:  
  - `id` (уникальный ID сотрудника, автоинкремент)  
  - `first_name`, `last_name`  
  - `position` (должность)  
  - `hire_date` (дата приема на работу)  
  - `phone`, `email`.  

#### **Таблица `categories` (Категории товаров)**  
- **Назначение**: Список категорий товаров.  
- **Поля**:  
  - `id` (уникальный ID категории)  
  - `name` (название категории, уникальное).  

#### **Таблица `suppliers` (Поставщики)**  
- **Назначение**: Информация о поставщиках товаров.  
- **Поля**:  
  - `id` (уникальный ID поставщика)  
  - `company_name` (название компании)  
  - `contact_name` (контактное лицо)  
  - `phone`, `email`, `address`.  

#### **Таблица `products` (Товары)**  
- **Назначение**: Данные о товарах в магазине.  
- **Поля**:  
  - `id` (уникальный ID товара)  
  - `name`, `description` (описание)  
  - `price` (цена)  
  - `stock_quantity` (количество на складе)  
  - `category_id` (ID категории, внешний ключ → `categories.id`)  
  - `supplier_id` (ID поставщика, внешний ключ → `suppliers.id`).  

#### **Таблица `orders` (Заказы)**  
- **Назначение**: Информация о заказах клиентов.  
- **Поля**:  
  - `id` (уникальный ID заказа)  
  - `client_id` (ID клиента, внешний ключ → `clients.id`)  
  - `employee_id` (ID сотрудника, внешний ключ → `employees.id`)  
  - `order_date` (дата заказа, по умолчанию текущая)  
  - `status` (статус: `pending`, `completed`, `cancelled`).  

#### **Таблица `order_items` (Позиции заказа)**  
- **Назначение**: Состав заказов (товары и их количество).  
- **Поля**:  
  - `id` (уникальный ID позиции)  
  - `order_id` (ID заказа, внешний ключ → `orders.id`)  
  - `product_id` (ID товара, внешний ключ → `products.id`)  
  - `quantity` (количество)  
  - `price` (цена на момент заказа).  

---

### Связи между таблицами  
1. **`products` → `categories` и `suppliers`**:  
   - Каждый товар принадлежит к категории (`category_id`) и поставляется поставщиком (`supplier_id`).  

2. **`orders` → `clients` и `employees`**:  
   - Заказ привязан к клиенту (`client_id`) и сотруднику, который его оформил (`employee_id`).  

3. **`order_items` → `orders` и `products`**:  
   - Позиции заказа связаны с заказом (`order_id`) и товаром (`product_id`).  

---

## 2. Типовые операции  

### Создание объектов  
**Добавление клиента**:  
```sql
INSERT INTO clients (first_name, last_name, phone, email, address)
VALUES ('Иван', 'Смирнов', '+79160000003', 'ivan@mail.ru', 'Новосибирск');
```

**Добавление товара**:  
```sql
INSERT INTO products (name, description, price, stock_quantity, category_id, supplier_id)
VALUES ('Моторное масло', '5W-30 синтетическое', 3000.00, 80, 3, 2);
```

---

### Правка объектов  
**Обновление статуса заказа**:  
```sql
UPDATE orders SET status = 'completed' WHERE id = 2;
```

**Изменение цены товара**:  
```sql
UPDATE products SET price = 2800.00 WHERE id = 1;
```

---

### Удаление объектов  
**Удаление клиента**:  
```sql
DELETE FROM clients WHERE id = 3;
```

**Удаление позиции заказа**:  
```sql
DELETE FROM order_items WHERE order_id = 1 AND product_id = 3;
```

---

### Работа с заказами  
**Создание заказа**:  
```sql
INSERT INTO orders (client_id, employee_id, status)
VALUES (1, 2, 'pending');
```

**Добавление позиции в заказ**:  
```sql
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (3, 2, 2, (SELECT price FROM products WHERE id = 2));
```

---

### Дополнительные операции  
**Просмотр деталей заказа через представление**:  
```sql
SELECT * FROM view_order_details;
```

**Заполнение тестовых данных**:  
```sql
CALL populate_test_data(); -- Использование хранимой процедуры
```
