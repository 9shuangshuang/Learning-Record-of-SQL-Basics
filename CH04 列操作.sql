
-- ======================
-- 第四章：SQL列操作
-- ======================

-- 我们将学习如何插入，更新和删除数据

-- 1.列属性
-- 先看customers表字段的类型，NAVICAT在双击表看到数据之后ctrl+D就能看到表字段的类型。MySQL直接双击表边上的维修工具图案。
-- 区分varchar(50)和char(50)，前者是可变字符串，如果字符串只有5个，只存储5个。后者会再插入45个填满。因此一般用varchar来存储字符串或者文本值

-- 2.插入单行
-- 用DEFAULT默认关键字，让MySQL生成一个顾客id的唯一值
INSERT INTO customers
VALUES (
  DEFAULT,
  'John',
  'Smith',
  '1990-01-01',
  NULL,
  'address',
  'city',
  'CA',
  DEFAULT);
  
  -- 另一种做法，我们可以选择提供想要插入值的列
USE store;
INSERT INTO customers (
    first_name,
    last_name,
    birth_date,
    address,
    city,
    state
    )
VALUES (
  'John',
  'Smith',
  '1990-01-01',
  'address',
  'city',
  'CA'
  );
  
  
-- 3.插入多行
  
  INSERT INTO shippers (name)
  VALUES ('shipper1'),
         ('shipper2'),
         ('shipper3');         
  
 -- 练习：写一段语句，在products中插入三行 
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('烧烤', 100, 10 ),
       ('鸡肉卷', 20, 20 ),
       ('麻辣王子', 10000, 1);
  

-- 4.插入分层行
-- 如何往多表插入数据
-- orders中的一行可以在order_items里有1子或多子
-- 怎么插入一笔订单以及它所对应的所有项目

 INSERT INTO orders (customer_id, order_date, status)
 VALUES (1, '2019-01-02', 1) ;

-- 但是在orders中新插入的一行SQL会自动给order_id，需要完全对应order_items中的order_id
-- 用一个函数LAST_INSERT_ID()就能返还出上一次新插入的行系统给的order_id，在order_items中直接用就可以

SELECT LAST_INSERT_ID();

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 3.4),
       (LAST_INSERT_ID(), 2, 1, 3.3);

  
-- 5.创建表复制

-- 第二行被称为子查询
CREATE TABLE order_archived AS
SELECT * FROM orders;

-- 下面的命令可以用来查询表是否存在
SHOW TABLES LIKE 'order_archived';

-- 打开复制后的order_archived表，会发现没有order_id不是主键也不是自动递增列等属性，所以用这个方法创建表时SQL会忽略这些属性

-- 删除掉order_archived表中的内容

-- 用INSERT INTO不需要写列名称，因为我们会给这段查询的每一列都赋值
-- 使用选择语句作为插入语句的子查询
INSERT INTO order_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01';

-- 练习：创造一张新表，invoices_archived，基于invoices表，但是不需要客户id列，但是需要客户名。另外只需要复制支付过的发票（即有付款日期）
-- 我写的这个完全错误，UNION需要合并一样列数的查询
USE sql_invoicing;
CREATE TABLE invoices_archived AS 
SELECT *
FROM invoices i
WHERE i.payment_date != NULL
UNION
SELECT c.name 
FROM invoices i
JOIN clients c 
  ON c.client_id = i.client_id;
-- DEEPSEEK的答案
CREATE TABLE invoices_archived AS 
SELECT i.*, c.name as client_name
FROM invoices i
JOIN clients c ON c.client_id = i.client_id
WHERE i.payment_date IS NOT NULL;

-- 答案：
USE sql_invoicing;
CREATE TABLE invoices_archived AS
SELECT 
  i.invoice_id,
  i.number,
  c.name AS client,
  i.invoice_total,
  i.invoice_date,
  i.payment_date,
  i.due_date
FROM invoices i
JOIN clients c 
    USING (client_id)
WHERE payment_date IS NOT NULL;

-- 6.更新单行

USE sql_invoicing;
UPDATE invoices
SET payment_total = 10,payment_date = '2019-03-01'
WHERE invoice_id = 1;


USE sql_invoicing;
UPDATE invoices
SET 
    payment_total = invoice_total*0.5,
    payment_date = due_date
WHERE invoice_id = 3;


-- 7.更新多行

USE sql_invoicing;
UPDATE invoices
SET 
    payment_total = invoice_total*0.5,
    payment_date = due_date
WHERE client_id = 3;

-- 练习：写一段查询获取所有在1990年之前出生的客户增加50点积分

USE store;
UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';


-- 8.在updates中使用子查询

-- 假设我们获得了需要更新信息的客户的名字，需要先找到他的id在根据id更新信息
-- 可以用选择语句作为UPDATE语句里的子查询

USE sql_invoicing;
SELECT client_id
FROM clients
WHERE name='myworks';

USE sql_invoicing;
UPDATE invoices
SET 
    payment_total = invoice_total*0.5,
    payment_date = due_date
WHERE client_id = (
      SELECT client_id
      FROM clients
      WHERE name='myworks');

-- 当子查询返回多条结果时，不能使用等号，使用IN

UPDATE invoices
SET 
    payment_total = invoice_total*0.5,
    payment_date = due_date
WHERE client_id IN (
      SELECT client_id
      FROM clients
      WHERE state IN ('CA', 'NY'));

-- 在执行整个语句前，先执行子查询语句，这样避免更新不该更新的记录

-- 练习：写一段SQL语句，为超过3000积分的顾客更新订单注释，改为gold customer

USE store;

UPDATE orders 
SET comments = 'gold customer'
WHERE customer_id IN(
        SELECT customer_id 
        FROM customers c
        WHERE points > 3000);

-- 9.删除行

USE sql_invoicing;
DELETE FROM invoices
WHERE client_id = (
        SELECT client_id
        FROM clients
        WHERE name = 'myworks'
)
  

-- 10.恢复数据库

-- 运行生成原始数据的sql脚本就能恢复数据库
  
  
  
  
  
  
  
  
  
  
  
  