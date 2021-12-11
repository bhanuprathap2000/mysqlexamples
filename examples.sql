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




