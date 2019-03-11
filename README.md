# DatabaseAssignment6


Excercise1


    query
    select customerName, salesRepEmployeeNumber, customers.city, employees.officeCode, employees.employeeNumber 
    from customers, offices, employees where salesRepEmployeeNumber=employeeNumber and employees.officeCode=offices.officeCode
    group by customerName;



The illustrated Excecution plan is showing one red table offices that has a full scan which is costly (even it is only 7 rows) as it has to search through all the elements in the table. The employees and customers table has archived a very low costs performance as it only had to go through 3 and 7 rows. The total cost is 39.80 with 175 rows and the GROUP operations is insignificant in this situation. The main issue is the office table performing a full scan search.  

Excercise2
Changing the order did not improve the performance. The table offices is searched by primary key so it is a default index. Generally one can improve performance by creating an index to keep the cost low. The relevant columns had pre-created indexes. The columns employeeNumber, reportsTo and officeCode has indexes hence why the performance is low cost. 




The execution plan is for GROUP BY query.

 
For windowing
 
The cost for windowing is significantly higher than the group query. Group query is not very expensive and if one 


Exercise 4
With joins
 
Using joins with UserId instead of DisplayUsername has no real difference as mysql will not be affected much by use of joins. There might be one full scan table but the other joins will not cost much due to not performing full scan for the joined tables.  

Exercise 5
In natural language full text search the search is done by relevance. This method also returns no rows if the search word length is less than 4. It also will not return query answer if the words are stopwords. In the Boolean full text search the searching is done in word instead of concept as the full text search. 
The Boolean text search and the full text search in this example are very low cost and effective.

 







 




