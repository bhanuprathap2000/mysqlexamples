-- In order to select the database USE keyword along with database name is used
-- It is recomennded to use uppercase for sql syntax and lowercase for others
USE sql_store;
-- SELECT STATEMENT IS USED TO RETRIVE THE DATA FROM THE TABLE.Line break,white spaces and tabs are ignored by the dbms(mysql)

SELECT first_name FROM customers;
-- HERE we are doing an arithmetic operation and applying the alias for column we can use new name without qoutes if no space if space then use the "" 
SELECT name,unit_price, unit_price*1.1 AS "new price" FROM products;
-- WHERE CLAUSE IS USED FOR FILTERING THE DATA FROM THE TABLES.So when we specify the condition the query engine will evaluate the condition with all the rows and return only matched data rows.

-- select all orders which are placed beignning from  2018
SELECT * from orders WHERE order_date>= "2018-01-01";

-- IN order to combine multiple conditions we can use the AND OR  NOT OPERATORS AND COMES FIRST IN PREFERENCE AND NEXT OR NOT WILL NEGATE THE RESULT SET.WE CAN USE THE () IN ORDER TO GIVE MORE PREFERENCE
-- From the orders table get the items for order_id=6 and total price is greater than 30 
SELECT * FROM order_items WHERE order_id=6 AND unit_price*quantity>30;

-- WHEN WE HAVE TO WRITE MULTIPLE OR CONDTIONS INSTEAD WE CAN USE THE IN OPERATOR
SELECT * FROM customers WHERE state="VA" OR state="FL" OR state="GA";
-- INSTEAD OF THAT LONG SYMTAX OF OR BELOW SYNTAX WE CAN USE 
-- BOTH RETURN THE SAME RESULT SET
SELECT * FROM customers WHERE state IN ("VA","FL","GA");

-- return products wit quantity in stock with 49,38,72
SELECT * FROM  products WHERE quantity_in_stock IN (49,38,72);

-- RETURN CUSTOMERS BORN BETWEEN "1990-01-01" AND "2000-01-01" we can use the between operator to give the range of values
SELECT * FROM customers WHERE birth_date BETWEEN "1990-01-01" AND "2000-01-01";

-- WE CAN USE THE LIKE OPERATOR IN ORDER TO PERFORM THE PATTERN SEARCHING % MEANS ANY NUMBER OF CHARCTERS _ MEANS ONLY ONE CHARCTER (CHARCTER(S) CAN BE ANYTHING)
SELECT * FROM customers WHERE address LIKE "%trail%" OR address LIKE "%avenue%";
SELECT * FROM customers WHERE phone LIKE "%9";

-- There is a new operator much powerful than the like operator called the regexp
-- ^ beginning
-- $ ending
-- | logical or
-- [abcd] or [a-d]

/*
get the customers whose 
first names are elka or ambur
last names end with ey or on
last names start with my or contain se
last names contain b follwed by r or u

*/
SELECT * FROM customers WHERE first_name REGEXP "elka|ambur";
SELECT * FROM customers WHERE last_name REGEXP "ey$|on$";
SELECT * FROM customers WHERE last_name REGEXP "^my|se";
SELECT * FROM customers WHERE last_name REGEXP "b[ru]";

-- IS NULL. NULL INDICATES THE ABSENCE OF THE VALUE
-- GET ORDERS THAT ARE NOT SHIPPED.
SELECT * FROM orders WHERE shipped_date IS NULL;

-- ORDER BY CLAUSE WE CAN USE IT SORT THE RESULT IN ASCENDING OR descENDING ORDER BY COLUMNNAME DEFAULT IT IS ASCENDING ORDER 
SELECT * FROM order_items WHERE order_id="2" ORDER BY quantity*unit_price DESC;

-- LIMIT CLAUSE IN ORDER TO LIMIT THE NUMBER OF SEARCH RESULTS WE CAN USE THE LIMIT 
-- LIMIT skip,number of rows skip is the offset that skip those many rows and number is the number of rows to get
-- GET THE TOP 3 LOYAL CUSTOMERS(customers with highest points)

SELECT * FROM customers ORDER BY points DESC LIMIT 3;

-- JOINS 
-- A JOIN clause is used to combine rows from two or more tables, based on a related column between them.
-- the syntax is first we need to select the first table then join the second table on a particular column condition match
-- This way data is divided into tables and not duplicated and easy to update when needed.
-- In one table the column is foreign key and in another table it can be the primary key
-- so the primary key uniquely indentifies the rows of the table and foreign key is used to create a relation ship between two tables
-- basically the primary key in onetable is stored as foreign key in other table(this can be duplicated in other table as it not primary key in that table)
SELECT * FROM orders JOIN customers ON  orders.customer_id=customers.customer_id; 
-- 	HERE THE JOIN USED IS THE INNER JOIN WE NEED TO SPECIFY AS INNER AND ALSO FOR TABLE WE USED THE ALIAS AND WHEN WE USE THE ALIAS THEN WE NEED TO USE IT EVERYWHERE
SELECT * FROM order_items oi JOIN products p ON oi.product_id=p.product_id;

-- in order to select tables from the database other than the selected one we need to use the database name as the prefix here in the below example we use the alias for table so that it remains short
SELECT * FROM order_items oi JOIN sql_inventory.products p ON oi.product_id=p.product_id;

-- self join A self join is a regular join, but the table is joined with itself. here we need to use the different aliases for same table
USE sql_hr;

SELECT e.first_name,m.first_name FROM employees e JOIN employees m ON e.reports_to=m.employee_id;

-- Combining the data from multiple tables
-- In real world we end up combining the data from multiple tables.
SELECT o.order_id,o.order_date,c.first_name,c.last_name,os.name AS status FROM orders o JOIN customers c ON o.customer_id=c.customer_id
 JOIN order_statuses os ON o.status=os.order_status_id;

USE sql_invoicing;

SELECT p.date,p.invoice_id,p.amount,c.name,pm.name FROM payments p JOIN clients c ON p.client_id=c.client_id 
JOIN payment_methods pm ON p.payment_method=pm.payment_method_id;

-- Compound joins are useful where multiple columns generate a unique key to join to another table. Sometimes a relational database has a unique key, which is a combination of two or more columns
-- There is another syntax called implicit join where we need not to use the JOIN keyword but it is better to know and never use it.
-- not recoomended syntax to use better to use the explicit join
SELECT * FROM customers,orders WHERE customers.customer_id=orders.customer_id;

/*
(INNER) JOIN: Returns records that have matching values in both tables
LEFT (OUTER) JOIN: Returns all records from the left table, and the matched records from the right table
RIGHT (OUTER) JOIN: Returns all records from the right table, and the matched records from the left table
FULL (OUTER) JOIN: Returns all records when there is a match in either left or right table

We just need to add the left or right keyword infront of join
*/
-- when we use the left join in that customers who didnot place the orders are also shown.
SELECT c.customer_id,c.first_name,o.order_id FROM customers c LEFT JOIN orders o ON c.customer_id=o.customer_id;
-- IN order to see the products and the number of times they we were ordered and also the products which are not ordered we need to use the LEFT JOIN  
SELECT p.product_id,p.name,o.quantity FROM products p LEFT JOIN order_items o ON p.product_id=o.product_id;
-- like how the inner joins can be used to combine the multiple tables we can use the outer joins as well
-- we can also do the self outer join

-- WHILE WRITING THE JOIN ON the we need to write the column name for both the tables but we can avoid that using the USING Clause if both tables have the same column name
-- SELECT * from customers JOIN orders ON customers.customer_id=orders.customer_id;
-- the below syntax and above will yield the same result and the below one is shorter and works only if same column name for both tables
SELECT * from customers JOIN orders USING (customer_id);
-- natural join is where the database engine will figure out the which column to copare in both tables (not recomennded to use) we just need to add the NATURAL keyword infront of join.
-- In SQL, the CROSS JOIN is used to combine each row of the first table with each row of the second table. It is also known as the Cartesian join since it returns the Cartesian product of the sets of rows from the joined tables.
SELECT * FROM shippers s CROSS JOIN products p ON s.shipper_id=p.product_id;