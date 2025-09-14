-- ======================
-- 第二章：SQL查询基础
-- ======================

-- 1. 选择语句
USE store;
SELECT *
FROM customers
-- WHERE customer_id = 1  （注意：原注释中的字段名错误，应为customer_id而非customers_id）
ORDER BY first_name;

/*
注释说明：
1. 单行注释使用 '-- '（两个短划线加空格）
2. 语句结束必须使用英文分号 ;
3. 执行当前命令：Ctrl + Enter
4. 执行整篇脚本：Ctrl + Shift + Enter
*/

-- 2. 选择子句
USE store;

-- 提取所有列
SELECT * FROM customers;

-- 指定列提取（可改变列顺序）
SELECT 
    first_name,
    last_name
FROM customers;

SELECT 
    last_name,
    first_name,
    points
FROM customers;

-- 包含计算列
SELECT 
    last_name,
    first_name,
    points,
    points + 10 AS points_plus_10
FROM customers;

-- 使用缩进增强可读性
SELECT 
    last_name,
    first_name,
    points,
    (points + 10) * 100 AS discount_factor
FROM customers;

-- 别名使用示例
SELECT 
    last_name,
    first_name,
    points,
    (points + 10) * 100 AS 'discount factor',  -- 包含空格的别名
    (points + 10) * 100 AS '折扣因子'          -- 中文别名
FROM customers;

-- 去重查询
SELECT DISTINCT state
FROM customers;

-- 练习：查询产品价格信息
SELECT 
    name, 
    unit_price,
    unit_price * 1.1 AS 'new price'
FROM products;

-- 3. WHERE子句
SELECT *
FROM customers
WHERE points > 3000;

-- 字符串和日期比较
SELECT *
FROM customers
WHERE state = 'VA';

SELECT *
FROM customers
WHERE birth_date > '1990-01-01';

-- 练习：查询2019年订单
SELECT *
FROM orders
WHERE order_date >= '2019-01-01';

-- 4. 逻辑运算符（AND/OR/NOT）
SELECT *
FROM customers
WHERE birth_date > '1990-01-01' 
    AND points > 1000;

-- 使用括号明确优先级
SELECT *
FROM customers
WHERE birth_date > '1990-01-01' 
    OR (points > 1000 AND state = 'VA');

-- NOT运算符使用
SELECT *
FROM customers
WHERE NOT (
    birth_date > '1990-01-01' 
    OR (points > 1000 AND state = 'VA')
);

-- 等效写法
SELECT *
FROM customers
WHERE birth_date <= '1990-01-01' 
    AND (points <= 1000 OR state != 'VA');

-- 练习：查询订单详情
SELECT *
FROM order_items
WHERE order_id = 6 
    AND (unit_price * quantity) > 30;

-- 5. IN运算符
SELECT *
FROM customers
WHERE state IN ('VA', 'GA', 'FL');

-- NOT IN 示例
SELECT *
FROM customers
WHERE state NOT IN ('VA', 'GA', 'FL');

-- 练习：查询特定库存产品
SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

-- 6. BETWEEN运算符
SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000;

-- 练习：查询出生日期范围
SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

-- 7. LIKE运算符
SELECT *
FROM customers
WHERE last_name LIKE 'B%';      -- B开头
SELECT *
FROM customers
WHERE last_name LIKE '%B%';     -- 包含B
SELECT *
FROM customers
WHERE last_name LIKE '%y';      -- y结尾
SELECT *
FROM customers
WHERE last_name LIKE '_____y';  -- 6字符且y结尾
SELECT *
FROM customers
WHERE last_name LIKE 'b____y';  -- b开头y结尾的6字符

-- 练习1：地址查询（修正错误）
SELECT *
FROM customers  
WHERE address LIKE '%trail%' 
    OR address LIKE '%avenue%';

-- 练习2：手机号查询
SELECT *
FROM customers  
WHERE phone LIKE '%9';

-- 8. REGEXP运算符
SELECT *
FROM customers
WHERE last_name REGEXP 'field';        -- 包含field
SELECT *
FROM customers
WHERE last_name REGEXP '^field';       -- field开头
SELECT *
FROM customers
WHERE last_name REGEXP 'field$';       -- field结尾
SELECT *
FROM customers
WHERE last_name REGEXP 'field|mac';    -- 包含field或mac
SELECT *
FROM customers
WHERE last_name REGEXP '[ig]e';        -- 包含ge或ie
SELECT *
FROM customers
WHERE last_name REGEXP 'e[fmq]';       -- 包含ef/em/eq
SELECT *
FROM customers
WHERE last_name REGEXP 'e[a-h]';       -- 包含ea到eh

-- 练习1：名字包含ELKA或AMBUR
SELECT *
FROM customers
WHERE first_name REGEXP 'elka|ambur';

-- 练习2：姓氏以EY或ON结尾
SELECT *
FROM customers
WHERE last_name REGEXP 'ey$|on$';

-- 练习3：名字以MY开头或包含SE
SELECT *
FROM customers
WHERE last_name REGEXP '^my|se';

-- 练习4：名字包含B后接R或U
SELECT *
FROM customers
WHERE last_name REGEXP 'b[ru]';

-- 9. IS NULL运算符
SELECT *
FROM customers
WHERE phone IS NULL;
SELECT *
FROM customers
WHERE phone IS NOT NULL;

-- 练习：查询未发货订单
SELECT *
FROM orders
WHERE shipped_date IS NULL;

-- 10. ORDER BY子句
SELECT *
FROM customers
ORDER BY first_name;                    -- 升序
SELECT *
FROM customers
ORDER BY first_name DESC;               -- 降序

-- 多列排序
SELECT *
FROM customers
ORDER BY state, first_name;             -- 先州后名
SELECT *
FROM customers
ORDER BY state DESC, first_name;        -- 州降序，名升序

-- 使用不在SELECT中的列排序
SELECT first_name, last_name
FROM customers
ORDER BY state DESC, first_name;

-- 练习：订单价格排序（修正错误）
SELECT 
    *, 
    quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;              -- 移除引号以正确引用别名

-- 11. LIMIT子句
SELECT *
FROM customers
LIMIT 3;                                -- 前3条记录
SELECT *
FROM customers
LIMIT 6, 3;                             -- 跳过6条取3条

-- 练习：积分最高前三名顾客
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

/*
子句顺序总结：
SELECT → FROM → WHERE → ORDER BY → LIMIT
错误顺序会导致语法错误
*/