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

-- NUMERIC FUNCTIONS IN SQL ROUND(VALUE,precision) CEIL(),FLOOR() ABS() etc..
-- There functions are very much self explanatory if needed we can do a quick search
SELECT ROUND(15.455,1);

SELECT ROUND(13.2);

SELECT ROUND(15.6);

SELECT FLOOR(15.8);

SELECT CEIL(15.3);

-- String functions are used to deal with the strings
-- returns the length of the string
SELECT LENGTH("BHANU");
SELECT UPPER('god');
SELECT LOWER('CAT');
SELECT TRIM("   how are you ?   ");
-- first argument is the serach string and next is the string
-- if string not found the return value is 0 if found then it returns the beignning position of the string
SELECT LOCATE('p',"i like pizza");
-- To the substring function we can pass the string,position to begin and length of the substring (optional) if not specified returns till the end.
SELECT SUBSTRING('I am bhanu prathap',6);
-- this function is used to replace the string first argument is string then string to be replaced and next string that will be replaced
SELECT REPLACE('k bhanu prathap','k','katikala');
-- used to combine the multiple strings
SELECT CONCAT('K',' ','BHANU');

/*
MySQL comes with the following data types for storing a date or a date/time value in the database:

DATE - format YYYY-MM-DD
DATETIME - format: YYYY-MM-DD HH:MI:SS
TIMESTAMP - format: YYYY-MM-DD HH:MI:SS
YEAR - format YYYY or YY
*/
-- These are functions to work with dates in mysql 
-- we can use the extract which is standard in sql
SELECT NOW();
SELECT CURDATE();
SELECT CURTIME();
SELECT YEAR(CURDATE());
SELECT MONTH(CURDATE());
SELECT DAY(CURDATE());
SELECT HOUR(CURTIME());
SELECT MINUTE(CURTIME());
SELECT MONTHNAME(CURDATE());
SELECT DAYNAME(CURDATE());

-- IN order to format date and time we have DATE_FORMAT AND TIME FORMAT
-- we can look into the documentation for further about the format.
SELECT DATE_FORMAT(NOW(),"%M %Y");

-- in order to perform the calcu;lations on the date and time we have few functions like DATE_ADD(),DATE_SUB(),DATEDIFF() etc..,

-- if null function is used to substitute the null values with the specified values
-- if a value in a column is null then it returns the specified value else the same value which is not null.
-- COALESCE will return the first non negative value if all null then the specified value
USE sql_store;
SELECT order_id,
IFNULL(shipper_id,"Not assigned")
FROM orders;

-- get the customer name,
-- so the main use of if and case is that for a column if we want to add the values based on a condition we can use the if for simple cases or use the CASE
-- WE can use the if function like  this IF(test_expression,value returned when true,value returned when false)
-- instead of using the multiple union and add the rows we can use the if and return the values based on expression
SELECT order_id,IF(order_date>"2019-01-01","Active","Archived") FROM orders;

-- if we have multiple conditions to check then we can use the case statement
-- in the if statement we can specify only one test condition but using the CASE we can specify multiple test cases and value to be returned

-- THE sample example of dividing the customers based on points
-- using the WHEN WE CAN SPECIFY THE TEST CASES AND VALUE IS RETURNED WHEN IT IS TRUE
-- IF no match occurs then VALUE FOR ELSE IS RETURNED AND FINALLY WE NEED TO END IT BY END KEYWORD 
SELECT first_name,points,
CASE 
WHEN points BETWEEN 0 AND 1999 THEN "Bronze"
WHEN points BETWEEN 2000 AND 2999 THEN "Silver"
WHEN points>3000 THEN "Gold"
ELSE "No Label"
END AS "lABEL"
FROM customers;
-- Database Administrator and Database Users will face two challenges: writing complex SQL queries and securing database access.
-- Sometimes SQL queries become more complicated due to the use of multiple joins, subqueries, and GROUP BY in a single query.
-- To simplify such queries, you can use some proxy over the original table.
-- Also, Sometimes from the security side, the database administrator wants to restrict direct access to the database.
-- For example, if a table contains various columns but the user only needs 3 columns of data in such case DBA will create a virtual table of 3 columns. 
-- For both purposes, you can use the view. Views can act as a proxy or virtual table. Views reduce the complexity of SQL queries and provide secure access to underlying tables.
-- create view <name of view> as (query)
-- now we can access the view as the normal table 
USE sql_invoicing;
CREATE OR REPLACE VIEW sales_by_client AS 
SELECT c.client_id,c.name,SUM(invoice_total) AS total_sales FROM clients c JOIN invoices i USING (client_id) GROUP BY client_id,name;
-- this is a view and we are acessing it normally like other tables it is a virtual table i.e is only query will be stored but not the table and we get data we try to access the data.
SELECT * FROM sales_by_client;

-- IN order to alter or chnage the view there are two ways which is DROP VIEW <viewname> and then again run the CREATE VIEW 
-- or instead use the create or replace using this we can run as many times.

-- DISTINCT
-- Aggregate
-- Group by and having by
-- Union

-- if the view doesn't contain these keywords then that view is updatable that means we can update the data in table with the help of this table.
-- Sometimes when we update the view this may remove the rows in that case we can include WITH OPTION CHECK to prevent this.

-- Benefits of views are they simplify the queries and subquries
-- they reduce the impact of the changes i.e if we chnage the table then queriess which are based on that table needs to be updated but if we use the view and then 
-- only plcae to update the code is view and our queries canbe same with view as abstarction
-- provide the data security for table.allow only certain columsn to be updated (be careful or else it will be mess.) 

/*
A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.

So if you have an SQL query that you write over and over again, save it as a stored procedure, and then just call it to execute it.

You can also pass parameters to a stored procedure, so that the stored procedure can act based on the parameter value(s) that is passed.
*/
-- WE CAN USE THE STORED PROCEDURES TO GET,CREATE,UPDATE AND DELETE DATA
USE sql_invoicing;

-- first we need to change the delimiter so that mysql sees the below code as one unit we follow $$ connvention whereever this $$ appears then that is the end
-- then we need to create procedure <name of stored procedure>()
-- begin
-- write the sql statements
-- end$$
-- delimietr ; change back the delimiter to ;
DELIMITER $$
CREATE PROCEDURE get_clients()

BEGIN

SELECT * FROM clients;

END$$

DELIMITER ;

-- in order to use the stored procedure then we need cal it we can call nameofprocedure()  but mostly write these so that they can be used in our applications rather than in mysql or sql

call get_clients();

-- instead of memorizing the syntax for stored procedures we can use the stored procedures setting in the databses;create store procedures which takes care of everything we just need to write the sql quries inside them that's it.

-- we can drop a stored procedure if we want
-- sometimes if stored if deleted and we are trying to delete them again the we need to use the if exists to keep the error silent
DROP PROCEDURE IF EXISTS get_clients;

-- we can add the parameters in the stored procedure with their data type.
-- and pass these paarmeters while calling. if we don't pass the parameter the error will occur.
DELIMITER $$

CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN
SELECT * FROM clients c WHERE c.state=state;
END$$

DELIMITER ;

-- IN ORDER TO EXECUTE WE CALL AND PASS THE parameters
call sql_invoicing.get_clients_by_state('NY');


-- DEFAULT VALUES
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$

CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN
-- if null then c.state=c.state true for all columns that means all the columns 
SELECT * FROM clients c WHERE c.state=IFNULL(state,c.state);
END$$

DELIMITER ;
-- INCASE OF NULL THE DEFAULT VALUES CANN BE GIVEN BUT WE NEED TO PASS ATLEAST NULL TO INDICATE THE DEFAULT VALUES
call sql_invoicing.get_clients_by_state(NULL);

-- In order validate the parameters passed to stored procedures there is a syntax which we can follow and refer internet.
-- output parameters read about these more on the internet

-- VARIABLES
-- In MY SQL, variables are the object which acts as a placeholder to a memory location. Variable hold single data value.
/*
Local variable:
A user declares the local variable.
By default, a local variable starts with @.
Every local variable scope has the restriction to the current batch or procedure within any given session.

DECLARE  { @LOCAL_VARIABLE[AS] data_type  [ = value ] }

*/

/*
We can create the functions which are simillar to stored procedures 
but the difference is that function returns a single value unlike result set in stored procedure.
we have a specific syntax for creating the functions we can follow internet to write a function.
*/


-- Triggers
/*
A SQL trigger is a database object which fires when an event occurs in a database.
 We can execute a SQL query or a stored procedure  that will "do something" in a database when a change occurs on a database table such as a record is inserted or updated or deleted.
 For example, a trigger can be set on a record insert in a database table. 
*/

-- NEW keyword will give us the access to the new record that is inserted and we can access them values using the .

/*
Description for this trigger

payments_after_insert this means this trigger will execute after a record is inserted in payments table
this is for each row new row or existing row

then between the begin and end we can write a sql query or call  a stored procedure
*/

USE sql_invoicing;
DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_insert;
CREATE TRIGGER payments_after_insert

AFTER INSERT ON payments 

FOR EACH ROW
BEGIN

UPDATE invoices

SET payment_total=payment_total+ NEW.amount WHERE invoice_id=NEW.invoice_id;

END$$

DELIMITER ;

-- lets make a payment for client id 2 in payment table and after the payment the invoice table is updated becasue of trigger.

INSERT INTO payments
VALUES(DEFAULT,5,3,"2021-12-15",1000,1);

-- the naming convention for a trigger is table_name_afterorbefore_event
-- event can be insert,update,delete
-- in order to see the triggers 
-- In order to filter we can use LIKE "pattern"
SHOW TRIGGERS;
SHOW TRIGGERS LIKE "payments%";

-- In order to drop a trigger 

DROP TRIGGER IF EXISTS payments_after_insert;
-- the ideal for this trigger is before creating a new trigger

-- we can also use the triggers for auditing
-- one more thing to remember for trigger is that the sql inside the trigger for that table should not effect that table it can effect other tables.
-- if it effects the table for which we write the tigger on then it will cause an infinite loop so be careful.

-- Events 
-- event is task or block of sql code which gets executed accoring to a schedule i.e on hourly,daily,monthly,yearly etc..,
-- suntax for events
/*
CREATE
    [DEFINER = user]
    EVENT
    [IF NOT EXISTS]
    event_name
    ON SCHEDULE schedule
    [ON COMPLETION [NOT] PRESERVE]
    [ENABLE | DISABLE | DISABLE ON SLAVE]
    [COMMENT 'string']
    DO event_body;

schedule: {
    AT timestamp [+ INTERVAL interval] ...
  | EVERY interval
    [STARTS timestamp [+ INTERVAL interval] ...]
    [ENDS timestamp [+ INTERVAL interval] ...]
}

interval:
    quantity {YEAR | QUARTER | MONTH | DAY | HOUR | MINUTE |
              WEEK | SECOND | YEAR_MONTH | DAY_HOUR | DAY_MINUTE |
              DAY_SECOND | HOUR_MINUTE | HOUR_SECOND | MINUTE_SECOND}
*/

-- This statement creates and schedules a new event. The event does not run unless the Event Scheduler is enabled. 

-- The events are very useful for cleaning the stale data which can be run on schedule basis.

SHOW EVENTS;
-- IN order to drop an event DROP EVENT NAME 
-- IN ORDER TO CHNAGE AN EVENT USE ALTER

-- A group of sql statements that represent a single unit of work.
-- Transactions has ACID properties

/*
A transaction is a unit of work that is performed against a database. Transactions are units or sequences of work accomplished in a logical order, whether in a manual fashion by a user or automatically by some sort of a database program.

A transaction is the propagation of one or more changes to the database. For example, if you are creating a record or updating a record or deleting a record from the table, then you are performing a transaction on that table. It is important to control these transactions to ensure the data integrity and to handle database errors.

Practically, you will club many SQL queries into a group and you will execute all of them together as a part of a transaction.

Properties of Transactions
Transactions have the following four standard properties, usually referred to by the acronym ACID.

Atomicity − ensures that all operations within the work unit are completed successfully. Otherwise, the transaction is aborted at the point of failure and all the previous operations are rolled back to their former state.

Consistency − ensures that the database properly changes states upon a successfully committed transaction.

Isolation − enables transactions to operate independently of and transparent to each other.

Durability − ensures that the result or effect of a committed transaction persists in case of a system failure.

Transaction Control
The following commands are used to control transactions.

COMMIT − to save the changes.

ROLLBACK − to roll back the changes.

SAVEPOINT − creates points within the groups of transactions in which to ROLLBACK.

SET TRANSACTION − Places a name on a transaction.
*/

USE sql_store;

START TRANSACTION;

INSERT INTO orders(customer_id,order_date,status)
VALUES (1,"2021-12-15",1);

INSERT INTO order_items
VALUES (last_insert_id(),1,1,1);

COMMIT;

-- by default mysql wraps the sql statements inside the transaction so that if it fails then mysql could rollback them.
-- A SQL Server deadlock is a special concurrency problem in which two transactions block the progress of each other. 
-- The first transaction has a lock on some database object that the other transaction wants to access, and vice versa.

-- Data types in MYSQL
-- STRING,NUMERIC,DATE AND TIME,BLOB,SPATIAL TYPES

-- STRING
/*
CHAR(X) fixed-length
VARCHAR(X) variable length max 65535
MEDIUMTEXT max 16MB
LONGTEXT max 4GB
etc..,

*/

-- we can use the varchar for most of the use cases.
-- difference between the char and varchar is that char is fixed size that means if length is small then other spaces are empty
-- varchar means if length is small then it takes space for that only.

-- INTEGERS ARE THOSE VALUES WHICH DON'T CONTAIN THE DECIMALS
/*
TINYINT 1b [-128,127]
UNSIGNED TINYINT 1b [0,255]
SMALLINT
MEDIUMINT
INT
BIGINT

The range of these varies accroding to type of int we use 
we need to use the specific for each use case very carefully.

*/

-- Fixed point and floating point numbers
-- For fixed point we need to use the DECIMAL(p,s) p means precision (how many in total) and s means scale after decimal how many
-- For very large numbers which can be approxmated we can use the float or double.

-- For storing the boolean values we can use the BOOLEAN 
-- TRUE MEANS 1 FALSE MEANS 0 INSTEAD OF TRUE OR FALSE WE CAN USE THE 1 OR 0 BUT IT'S BETTER TO USE THE TRUE AND FALSE.

-- enum datatypes is used to restrict a column to have a list of values 
-- in  general it is better to use the look up tables rather than enum data types.

-- DATE TIME DATE TYPES
-- DATE,TIME,DATETIME,TIMESTAMP,YEAR
-- For any reason if we want to store the binary data then we can use the blob data types
-- tinyblob,blob,mediumblob,longblob
-- we should avoid the storing of binary data in database keep the binary files in the file system
-- because this can cause may problems like db size increases,slower backups etc..,

-- mysql now supports the json data type we can store the key value pairs in the db itself like we do in mongodb or firebase and we can query the data based on the key value pairs also.alter
-- please read the tutorial for more information https://www.digitalocean.com/community/tutorials/working-with-json-in-mysql

/*
Normalization is a database design technique that reduces data redundancy and eliminates undesirable characteristics like Insertion, Update and Deletion Anomalies. 
Normalization rules divides larger tables into smaller tables and links them using relationships. 
The purpose of Normalisation in SQL is to eliminate redundant (repetitive) data and ensure data is stored logically.
*/

-- first norm each cell should have a single value and we cannot have the repeated columns
-- second norm every table should describe one entity and every column inside that should describe that entity
-- a column in a table should not be derived from other columns.

-- see if there is any duplication in the data try to seperate the data and keep in different tables 
-- no need to memorize the norms but if we find the duplication just try to avoid that and seperate the data based on requirements.
-- In mysql first we can create modals which look like tables and they have the relationships and later we can forward engineer so that database will be created.

-- basically in forward engineering we take a database model and convert it to database containing the actual tables and relationships.
-- in reverse engineering we take the database and tables and will create a dtabase model for that if it doesn't exist.this way we cany visulaize our database and 
-- see the relationships among the tables.

