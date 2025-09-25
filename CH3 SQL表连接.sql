-- ======================
-- 第三章：SQL表连接
-- ======================

-- 本节介绍内连接(INNER JOIN)的使用方法。
-- 内连接用于从两个或多个表中返回满足连接条件的记录，是SQL中最常用的连接方式。
-- =============================================

-- 1. 内连接基础
-- 功能：学习基本的INNER JOIN语法，实现从多个关联表中提取数据
-- 说明：INNER JOIN可简写为JOIN，返回两个表中匹配的记录
USE store;

-- 基本内连接示例：连接orders和customers表
SELECT *
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id;

-- 指定列的内连接：只选择需要的列
SELECT order_id, first_name, last_name
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id;

-- 列名冲突处理：当两个表有相同列名时需要指定表名
SELECT order_id, first_name, last_name, orders.customer_id
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id;

-- 使用表别名简化代码
SELECT order_id, first_name, last_name, o.customer_id
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

-- 练习：连接products和order_items表
SELECT p.product_id, name, oi.quantity, oi.unit_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id;


-- 2. 跨数据库连接
-- 功能：实现不同数据库之间的表连接
-- 说明：通过数据库名前缀访问其他数据库中的表
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
    ON oi.product_id = p.product_id;


-- 3. 自连接
-- 功能：实现表与自身的连接，常用于层次结构数据（如员工-经理关系）
-- 说明：通过给同一张表使用不同的别名来实现自连接
USE sql_hr;

-- 基本的自连接：员工与经理的关系查询
SELECT 
    e.employee_id, 
    e.first_name,
    m.first_name AS manager
FROM employees e
JOIN employees m
    ON e.reports_to = m.employee_id;


-- 4. 多表连接
-- 功能：实现三个及以上表的连接操作
-- 说明：通过多个JOIN语句连接多个表，构建复杂查询
USE store;

-- 连接orders、customers和order_statuses三个表
SELECT 
    o.order_id, 
    o.order_date, 
    c.first_name,
    c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_statuses os
    ON o.status = os.order_status_id;

-- 练习：连接clients、payments和payment_methods表
USE sql_invoicing;
SELECT 
    pay.date,
    pay.invoice_id,
    pay.amount,
    c.name,
    pm.name AS payment_method
FROM clients c
JOIN payments pay
    ON c.client_id = pay.client_id
JOIN payment_methods pm
    ON pay.payment_method = pm.payment_method_id;


-- 5. 复合连接条件
-- 功能：处理需要多个条件才能唯一标识记录的情况
-- 说明：用于具有复合主键的表，通过AND连接多个条件
USE store;

-- 使用复合条件连接order_items和order_item_notes表
SELECT *
FROM order_items oi
JOIN order_item_notes oin
    ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;


-- 6. 隐式连接语法
-- 功能：了解隐式连接语法（不推荐在生产环境使用）
-- 说明：使用WHERE子句实现连接，但推荐使用显式JOIN语法
USE store;

-- 显式连接语法（推荐）
SELECT *
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

-- 隐式连接语法（不推荐）
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;


-- 7. 外连接
-- 功能：返回不满足连接条件的记录，包括左外连接和右外连接
-- 说明：左连接返回左表所有记录，右连接返回右表所有记录
USE store;

-- 内连接：只返回有订单的客户
SELECT 
    c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id;

-- 左外连接：返回所有客户，包括没有订单的
SELECT 
    c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id;

-- 右外连接：效果同左连接，但表顺序相反
SELECT 
    c.customer_id,
    c.first_name,
    o.order_id
FROM orders o
RIGHT JOIN customers c
    ON o.customer_id = c.customer_id;

-- 练习：左连接products和order_items表
SELECT 
    p.product_id,
    p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id 
ORDER BY p.product_id;


-- 8. 多表外连接
-- 功能：在多个表上使用外连接
-- 说明：可以混合使用内外连接，构建复杂的查询逻辑
USE store;

-- 多表左连接示例
SELECT 
    c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id 
LEFT JOIN shippers sh
    ON sh.shipper_id = o.shipper_id
ORDER BY c.customer_id;

-- 练习：复杂的多表左连接查询
SELECT 
    o.order_date,
    o.order_id,
    c.first_name,
    sh.name AS shipper, 
    os.name AS status
FROM orders o
LEFT JOIN customers c
    ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
    ON sh.shipper_id = o.shipper_id
LEFT JOIN order_statuses os 
    ON os.order_status_id = o.status
ORDER BY os.name;


-- 9. 自外连接
-- 功能：在自连接中使用外连接，处理可能存在空值的情况
-- 说明：常用于查询层次结构数据，如包含顶级经理的员工列表
USE sql_hr;

-- 自左外连接：包含所有员工，即使他们没有经理
SELECT 
    e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
    ON e.reports_to = m.employee_id;


-- 10. USING子句
-- 功能：简化连接条件，当连接列名相同时使用
-- 说明：USING子句可替代ON子句，使代码更简洁
USE store;

-- 使用USING子句简化连接条件
SELECT 
    o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
    USING (customer_id)
LEFT JOIN shippers sh
    USING (shipper_id);

-- 复合USING子句：处理多列连接条件
SELECT *
FROM order_items oi
JOIN order_item_notes oin
    USING (order_id, product_id);

-- 练习：使用USING子句连接多个表
USE sql_invoicing;
SELECT 
    p.date,
    c.name AS client,
    p.amount,
    pm.name AS payment_method
FROM payments p 
JOIN clients c
    USING (client_id)
JOIN payment_methods pm
    ON pm.payment_method_id = p.payment_method;


-- 11. 自然连接
-- 功能：自动基于相同列名进行连接（不推荐使用）
-- 说明：数据库自动匹配相同列名，但可能产生意外结果
SELECT 
    o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;


-- 12. 交叉连接
-- 功能：生成两个表的笛卡尔积
-- 说明：返回所有可能的行组合，常用于生成测试数据或组合列表
USE store;

-- 显式交叉连接语法（推荐）
SELECT 
    c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;

-- 隐式交叉连接语法
SELECT 
    c.first_name AS customer,
    p.name AS product
FROM customers c, products p
ORDER BY c.first_name;

-- 练习：shippers和products的交叉连接
SELECT 
    sh.name AS shipper,
    p.name AS product
FROM shippers sh
CROSS JOIN products p 
ORDER BY sh.name;


-- 13. 联合查询
-- 功能：合并多个SELECT语句的结果集
-- 说明：UNION会自动去重，UNION ALL会保留所有记录
USE store;

-- 使用UNION合并不同条件的查询结果
SELECT 
    order_id,
    order_date,
    'Active' AS status
FROM orders 
WHERE order_date >= '2019-01-01'
UNION
SELECT 
    order_id,
    order_date,
    'Archived' AS status
FROM orders 
WHERE order_date < '2019-01-01'
ORDER BY order_date;

-- 练习：根据客户积分进行分类
SELECT 
    customer_id,
    first_name,
    points,
    'Bronze' AS type
FROM customers 
WHERE points < 2000
UNION
SELECT 
    customer_id,
    first_name,
    points,
    'Silver' AS type
FROM customers 
WHERE points BETWEEN 2000 AND 2999
UNION
SELECT 
    customer_id,
    first_name,
    points,
    'Gold' AS type
FROM customers 
WHERE points >= 3000 
ORDER BY first_name;