# SQL_Server

## Microsoft SQL Server is a relational database management system developed by Microsoft. As a database server, it is a software product with the primary function of storing and retrieving data as requested by other software applications—which may run either on the same computer or on another computer across a network.

### [Stored Procedures](https://github.com/Burakkylmz/SQL_Server/tree/master/Stored_Procedures)

Most of the popular relational database systems, SQL Server, Oracle, MySQL and the like, support stored procedures. A stored procedure is nothing more than a piece of code that performs some repetitive set of actions. It performs a particular task by executing a set of actions or queries against the database. The code for the stored procedure is stored in the database and can be executed at any time. Stored procedures are typically used to insert your records into one of more tables, update or delete data from tables, and to generate reports via the SELECT statement. It's actually possible for a stored procedure to do more than one thing. 

> If you want to try the stored procedure examples, first run the contactdb.sql scripts under the src folder in SQL Server to create the sample database. 

### [Trigers & Functions](https://github.com/Burakkylmz/Programming_SQL_Server_Database/tree/master/Triger_Functions)

##### What is a DML Trigger?

DML stands for data manipulation language, and it's that vocabulary of standard T-SQL commands that you already know that attempt to retrieve data, modify data, or manipulate it, things like SELECT and INSERT and UPDATE and DELETE.  Data in a relational database is stored within tables, a concept we're used to, and DML triggers watch for data manipulation events.  So inserting, updating, and deleted. 

##### After & Instead of Triggers

Within SQL Server, there are two kinds of triggers, INSTEAD OF and AFTER triggers. In almost every way, they really are the same. The only difference is where and when they do their work, but they're working on the same data. So first, let's review the similarities and then look at their differences.


