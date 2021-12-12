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
-- When we have multiple values to specify and compare then we can use the IN operator
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

/*

using the join we can combine colums from multiple tables 
using the union we can combine rows from multiple tables
The UNION operator is used to combine the result-set of two or more SELECT statements.
Every SELECT statement within UNION must have the same number of columns
The columns must also have similar data types
The columns in every SELECT statement must also be in the same order
*/
-- Here basically using the union operator we can combine multiple select where the table can be same or different tables but number of columns and order of them matters
SELECT customer_id,first_name,points,"Bronze" AS type FROM customers WHERE points BETWEEN 0 AND 1999
UNION SELECT customer_id,first_name,points,"Silver" AS type FROM customers WHERE points BETWEEN 2000 AND 2999
UNION SELECT customer_id,first_name,points,"Gold" AS type FROM customers WHERE points>3000;

-- In order to insert the values into the table we can use the insert into
-- while using the insert into we can specify the columsn we want to insert and other columns if they have any default value they take those or if allowed null then null is inserted if required then error.
-- we can speify the multiple rows by comma sperated values like below
INSERT INTO customers (first_name,last_name,birth_date,address,city,state)
VALUES ('bhanu','prathap',"1999-07-25","telangana,secunderabad","hyderabad","TS"),
 ('bhanu','prathap',"1999-07-25","telangana,secunderabad","hyderabad","TS");
 
 -- in order to update the the row or rows we can use the UPDATE tablename
 -- after that we can use the set and set the column values and then at last we need to specify the condition for a row or rows row means single match rows means multiple matches
 UPDATE customers 
 SET first_name="bunny",last_name="kumar"
 WHERE customer_id=12;
 
 -- Write a SQL statement to give any customers who were born before 1990 50 extra points.
 -- this will try to update the multiple rows but mysql will not allow in safe mode either remove the safe mode or run it somewhere else
 -- 10:02:39	UPDATE customers  SET points=points+50  WHERE birth_date<"1990-01-01"	Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.	0.125 sec

 UPDATE customers
 SET points=points+50
 WHERE birth_date<"1990-01-01";
 
 -- In order to delete the data we can use the DELETE 
 -- error occurs because of same mode
 -- we need to be careful because if forgot to specify the where clause then entire table can be lost
 DELETE FROM customers WHERE first_name="bunny";

USE sql_invoicing;
/*
An aggregate function allows you to perform a calculation on a set of values to return a single scalar value. We often use aggregate functions with the GROUP BY and HAVING clauses of the SELECT statement.

The following are the most commonly used SQL aggregate functions:

AVG – calculates the average of a set of values.
COUNT – counts rows in a specified table or view.
MIN – gets the minimum value in a set of values.
MAX – gets the maximum value in a set of values.
SUM – calculates the sum of values.
Notice that all aggregate functions above ignore NULL values except for the COUNT function.

aggregate_function (DISTINCT | ALL expression)

*/
SELECT "First half of 2019" AS date_range,
SUM(invoice_total) AS total_sales,
SUM(payment_total) AS total_payments,
SUM(invoice_total-payment_total) AS total
FROM invoices
WHERE invoice_date BETWEEN "2019-01-01" AND "2019-06-30"

UNION

SELECT "Second half of 2019" AS date_range,
SUM(invoice_total) AS total_sales,
SUM(payment_total) AS total_payments,
SUM(invoice_total-payment_total) AS total
FROM invoices
WHERE invoice_date BETWEEN "2019-06-30" AND "2019-12-31"
UNION
SELECT "Total" AS date_range,
SUM(invoice_total) AS total_sales,
SUM(payment_total) AS total_payments,
SUM(invoice_total-payment_total) AS total
FROM invoices
WHERE invoice_date BETWEEN "2019-01-01" AND "2019-12-31";


-- The order of clauses is select,from,where,having,order by
-- Here the aggregate function will be applied to grouped records 
SELECT date,pm.name AS payment_method,SUM(amount) AS total_amount FROM payments p 
JOIN payment_methods pm ON p.payment_id=pm.payment_method_id GROUP BY date,payment_method ORDER BY total_amount DESC;


-- So the where clause is used to filter out the data before grouping and having clause is used to filter out the data after the grouping.
-- one more difference is that where clause can be used with any column whether selected or not but having clause can work with only selected columns.

USE sql_store;
-- get the customers who all live in virgina who spent more than $100
SELECT * FROM customers WHERE state="VA";

-- IN order to summarise the grouped data we can use the ROLL UP operator

/*
A Subquery or Inner query or a Nested query is a query within another SQL query and embedded within the WHERE clause.

A subquery is used to return data that will be used in the main query as a condition to further restrict the data to be retrieved.

Subqueries can be used with the SELECT,FROM,WHERE, INSERT, UPDATE, and DELETE statements along with the operators like =, <, >, >=, <=, IN, BETWEEN, etc.

There are a few rules that subqueries must follow −

Subqueries must be enclosed within parentheses.

A subquery can have only one column in the SELECT clause, unless multiple columns are in the main query for the subquery to compare its selected columns.

An ORDER BY command cannot be used in a subquery, although the main query can use an ORDER BY. The GROUP BY command can be used to perform the same function as the ORDER BY in a subquery.

Subqueries that return more than one row can only be used with multiple value operators such as the IN operator.

The SELECT list cannot include any references to values that evaluate to a BLOB, ARRAY, CLOB, or NCLOB.

A subquery cannot be immediately enclosed in a set function.

The BETWEEN operator cannot be used with a subquery. However, the BETWEEN operator can be used within the subquery.
*/

-- Find the products that are more expensive than lettuce (id=3)

SELECT * FROM products WHERE unit_price>(SELECT unit_price 	FROM products WHERE product_id=3);

-- find employees who earn more than average
USE sql_hr;
-- another solution could be we can find the avg and then hard code that but we can use the subquery which does that for us.
SELECT * FROM employees WHERE salary>(SELECT AVG(salary) FROM employees);

-- Find the products which are never ordered
-- when the subquery returns more than one value we can use IN or NOT IN opertors like below
USE sql_store;
SELECT * FROM products WHERE product_id NOT IN 
(SELECT DISTINCT product_id FROM order_items);

-- we can use the ALL ANY KEYWORDS WHEN THE subquries return more than one value for comparision


