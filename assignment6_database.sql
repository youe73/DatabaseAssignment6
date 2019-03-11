use classicmodels;

/*
Excercise 1
In the classicmodels database, write a query that picks out those customers 
who are in the same city as office of their sales representative.
*/

/*Windows + Shift + S*/

select customerName, salesRepEmployeeNumber, customers.city, employees.officeCode, employees.employeeNumber 
from customers, offices, employees where salesRepEmployeeNumber=employeeNumber and employees.officeCode=offices.officeCode
group by customerName;




/*
Exercise 2
Change the database schema so that the query from exercise get better performance.
*/
/*
CREATE INDEX inofficeCode
ON employees (officeCode);
*/
/*
ALTER TABLE offices
DROP INDEX idx_offices_officeCode;
*/

SHOW INDEX FROM employees;
SHOW INDEX FROM customers;
SHOW INDEX FROM offices;

select 
customerName, salesRepEmployeeNumber, customers.city, employees.officeCode, employees.employeeNumber
from offices, employees,customers
where offices.officeCode = employees.officeCode  
and salesRepEmployeeNumber=employeeNumber
group by customerName;

select reportsTo, officeCode from employees;
select officeCode from offices;

SELECT customerName, salesRepEmployeeNumber, customers.city, employees.officeCode, employees.employeeNumber
FROM employees , offices,  customers USE INDEX(salesRepEmployeeNumber)
where employees.officeCode=offices.officeCode
and salesRepEmployeeNumber=employeeNumber  
group by customerName;


/*
Exercise 3
We want to find out how much each office has sold and the max single payment for each office. 
Write two queries which give this information

a) using grouping
b) using windowing

For each of the two solutions, check its graphical execution plan.
*/

/* group by office the sale, and max single payment for each office */  
/* sale for each office and biggest payment made from customer to each office*/

/*group by*/
select (quantityOrdered * priceEach) as sale, offices.officeCode, offices.country, offices.state, amount, 
MAX(amount) as maxpayment
from orderdetails, orders, customers, employees, offices, payments
where orderdetails.orderNumber = orders.orderNumber
and orders.customerNumber = customers.customerNumber
and salesRepEmployeeNumber = employeeNumber
and payments.customerNumber = customers.customerNumber 
and employees.officeCode = offices.officeCode 
group by offices.officeCode order by sale desc;


/*windowing*/
select 
(quantityOrdered*priceEach), priceEach, SUM(priceEach)OVER (PARTITION BY offices.officeCode)total, offices.country, 
offices.state, amount, offices.officeCode,
MAX(amount) OVER (PARTITION BY offices.officeCode) maxpayment
from orderdetails, orders, customers, employees, offices, payments
where orderdetails.orderNumber = orders.orderNumber
and orders.customerNumber = customers.customerNumber
and salesRepEmployeeNumber = employeeNumber
and payments.customerNumber = customers.customerNumber 
and employees.officeCode = offices.officeCode; 




/*
Exercise 4
In the stackexchange forum for coffee (coffee.stackexchange.com), write a query which return the displayName
 and title of all posts which with the word grounds in the title.
*/

use stackoverflow;

SHOW INDEX FROM posts;
SHOW INDEX FROM comments;
SHOW INDEX FROM users;

DROP procedure IF EXISTS `textsearch`;
DELIMITER $$
CREATE PROCEDURE `textsearch` ()
BEGIN
select Title, DisplayName, OwnerUserId from posts, users, comments
where Title LIKE '%grounds%' and posts.Id = comments.PostId and users.Id = OwnerUserId;
END$$
DELIMITER ;

call textsearch();

select Title, DisplayName, OwnerUserId from posts, users, comments
where Title LIKE '%grounds%' and posts.Id = comments.PostId and users.Id = OwnerUserId;

select Title, users.Id, Text, OwnerUserId from posts, users, comments
where Title LIKE '%grounds%' and posts.Id = comments.PostId and users.Id = OwnerUserId;



/*
Exercise 5
Add a full text index to the posts table and change the query from exercise 4 so it no longer scans the entire posts table.
*/

Alter table posts ADD FULLTEXT (Title);

DROP procedure IF EXISTS `fulltextsearch`;
DELIMITER $$
CREATE PROCEDURE `fulltextsearch` (keyword varchar(100))
BEGIN
Select Title, OwnerUserId, users.Id from posts, users, comments where match(Title) AGAINST (keyword)
and posts.Id = comments.PostId and users.Id = OwnerUserId;
END$$
DELIMITER ;

call fulltextsearch('grounds');
call fulltextsearch('coffee');
call fulltextsearch('should');

Select Title, OwnerUserId, users.Id from posts, users, comments where match(Title) AGAINST ('coffee')
and posts.Id = comments.PostId and users.Id = OwnerUserId;

Select Title, OwnerUserId, users.Id from posts, users, comments where match(Title) AGAINST ('coffee' in boolean mode)
and posts.Id = comments.PostId and users.Id = OwnerUserId;

