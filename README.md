<p align="right"><img src="https://img.shields.io/badge/License-MIT-yellow.svg"></p>

<!-- PROJECT LOGO -->
<br/>
<div align="center">
  <a href="https://github.com/amanmadov/msin617-final-project">
    <img src="https://github.com/amanmadov/msin617-final-project/blob/main/images/logo1.png" alt="Logo" width="80" height="80">
  </a>

  <h2 align="center">Touro University  Graduate School of Technology</h2>
  <h3 align="center">MSIN 616 Advanced Database Management Course Final Project</h3>

```sql
SELECT Course FROM [TouroDb].[dbo].[Courses] WHERE CourseId = 'MSIN616'
```
</div>

<br/>

<!-- ABOUT THE PROJECT -->

## About The Project

This is the simple database designed using Microsoft's `Pubs` database.
The `Pubs` database provides a set of fictional pieces of information about publishers, authors, titles and sales of books.
It is now considered obsolete; it is no longer provided with `SQL Server` since the 2008 version.
The tables and fields are quite obvious. 
They have names such as `Authors`, `Titles`, etc., which reflect their content. 
And the fields also have obvious names explaining what they contain.

<p>
  You can find the details about original Pubs DB in the link:
  <a href="https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs" target="_blank">Microsoft Pubs DB</a>
</p>

Below you can see the altered database diagram of the `Pubs` database

<br/>

![Database Schema Screen Shot](https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/db-schema.png)

<br/>

<p>
  Link for the database schema:<a href="https://drawsql.app/softttt/diagrams/msin616-pubs-db" target="_blank"> DB Schema</a>
</p>

<br/>


## Technologies Used
 - Microsoft SQL Server 2019 - 15.0.4198.2 Developer Edition (64-bit) on Linux (Ubuntu 20.04.3 LTS)
 - Azure Data Studio version 1.35.1
 - Docker version 4.4.2 (73305)

<br/>

## Modifications on the Database

- [x] `[TITLES]` table have been altered and **prequel_id** column have been added to store the prequel of a book.
- [x] Using prequel books, recursive queries can be written and executed on the `[TITLES]` table.
- [x] Some famous book series like **"A Game of Thrones"** or **"The Lord of The Rings"** are added to the `[TITLES]` table.
- [x] Some famous author and publisher records are added to related tables.
- [x] Some of the column types are also modified.
- [x] To simulate a real world full stack app, a demo CRUD app with front-end UI has been developed.
- [x] `Gentellela`, an open source admin panel, has been used to create front-end UI.
- [x] Stored procedures are created for the demo CRUD app.
- [x] Some custom validations has been developed on the Front-end UI to prevent data inconsistency.
- [x] All stored procedures for creating/modifying records are created based on the front-end validations.
- [x] Created `[Audit].[Book]` table to keep audit history of the created books.
- [x] Used `[Adventureworks].[Person].[Person]` and `[AdventureWorks].[HumanResources].[Employee]` tables to generate dummy data.


<br/>
<br/>

<div> <h2 align="center">Custom Stored Procedures and the Front-End UI of the Demo App</h2></div>

<br/>

### I. Creating a Book on the Demo App
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/insert-book2.gif">
<br/>

<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/create_book.html" target="_blank"> View Demo</a></p>

<br/>

Algorithm flowchart of the creating a book operation

<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/flowchart.png">
<br/>


Stored procedure for adding a book into the `TITLES` table

<br/>

```sql

/*
    Created by Nury Amanmadov
    Date created: 10.04.2022 ddMMyyyy
*/

CREATE PROCEDURE [dbo].[USP_InsertBook] 
     @book_title AS VARCHAR(100)
    ,@prequel_id AS VARCHAR(6) = NULL
    ,@book_type AS CHAR(40)
    ,@book_price AS MONEY
    ,@book_advance AS MONEY
    ,@book_royalty INT
    ,@book_ytd_sales INT
    ,@book_notes VARCHAR(800)
    ,@book_pubdate DATETIME
    ,@pub_id AS CHAR(4) = NULL
    ,@pub_name AS VARCHAR(40) = NULL
    ,@pub_city AS VARCHAR(20) = NULL
    ,@pub_state AS CHAR(2) = NULL
    ,@pub_country AS VARCHAR(30) = NULL
    ,@author_id VARCHAR(11) = NULL
    ,@au_lname VARCHAR(40) = NULL
    ,@au_fname VARCHAR(20) = NULL
    ,@au_phone CHAR(12) = NULL
    ,@au_city VARCHAR(20) = NULL
    ,@au_state CHAR(2) = NULL
    ,@au_order TINYINT = 1
    ,@royalty_per INT = 100
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            --#region Insert into Publisher Table
                IF (@pub_id IS NULL)
                    --#region Create New Publisher
                    BEGIN 
                        -- Create pub_id as Max Id + 1
                        SET @pub_id =   (
                                            SELECT CAST(MAX(CAST(pub_id AS INT) + 1) AS VARCHAR) 
                                            FROM publishers
                                        )
                        
                        INSERT INTO [pubs].[dbo].[publishers] 
                        VALUES  (
                                     @pub_id
                                    ,@pub_name
                                    ,@pub_city
                                    ,@pub_state
                                    ,@pub_country
                                )

                        --#region Insert into Pub_Info Table 
                            DECLARE @pr_info AS VARCHAR(255)
                            SET @pr_info = (
                                                SELECT  'This is sample text data for ' 
                                                        + pub_name + ', publisher ' 
                                                        + pub_id + ' in the pubs database. ' 
                                                        + pub_name + ' is located in ' + city + ' ' + country + '.' AS pr_info
                                                FROM [pubs].[dbo].[publishers] p 
                                                WHERE p.pub_id = @pub_id
                                            )

                            INSERT INTO [pubs].[dbo].[pub_info] 
                            VALUES  (
                                        @pub_id
                                        ,NULL
                                        ,@pr_info
                                    )
                        --#endregion
                    END 
                    --#endregion
                ELSE 
                    BEGIN
                        -- Just to make sure that selected publisher exists in the database
                        IF NOT EXISTS (SELECT TOP 1 1 FROM publishers p WHERE pub_id = @pub_id)
                            BEGIN
                                RAISERROR('Publisher with selected ID does not exist', 16, 1) 
                            END  
                        ELSE 
                            BEGIN 
                                -- Setting params. Will be inserted into Audit.Book table 
                                SELECT   @pub_name = p.pub_name
                                        ,@pub_city = p.city
                                        ,@pub_state = p.[state]
                                        ,@pub_country = p.country
                                FROM publishers p
                                WHERE p.pub_id = @pub_id 
                            END    
                    END 
            --#endregion

            --#region Insert into Titles Table
                --#region Creating Random TitleId
                DECLARE @t1 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                DECLARE @t2 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                DECLARE @t3 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                DECLARE @t4 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                DECLARE @t5 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                DECLARE @t6 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                DECLARE @random_title_id [dbo].[tid] = (SELECT @t1 + @t2 + @t3 + @t4 + @t5 + @t6)
                --#endregion
                INSERT INTO titles
                VALUES
                (
                     @random_title_id
                    ,@book_title
                    ,@book_type
                    ,@pub_id
                    ,@book_price
                    ,@book_advance
                    ,@book_royalty
                    ,@book_ytd_sales
                    ,@book_notes
                    ,@book_pubdate
                    ,@prequel_id
                )

            --#endregion

            --#region Insert into Authors Table
                DECLARE @au_zip CHAR(5)
                DECLARE @au_contract BIT
                DECLARE @au_address VARCHAR(40)

                IF(@author_id IS NULL)
                    BEGIN 
                        -- Generate Random AuthorID
                        DECLARE @a1 AS CHAR(3) = (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))
                        DECLARE @a2 AS CHAR(2) = (SELECT(CAST((FLOOR(RAND()*(99-10+1)+10)) AS CHAR)))
                        DECLARE @a3 AS CHAR(4) = (SELECT(CAST((FLOOR(RAND()*(9999-1000+1)+1000)) AS CHAR)))
                        SET @author_id = (SELECT @a1 + '-' + @a2 + '-' + @a3)

                        -- Setting Random Zip in the 99xyz format
                        SET @au_zip = '99'+ (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))
                        -- SELECT @au_zip

                        -- Setting @au_contract as random 
                        SET @au_contract = (SELECT(CAST((FLOOR(RAND()*(1-0+1)+0)) AS BIT)))
                        -- SELECT @au_contract

                        -- Setting Random Address from AdventureWorks DB Person.Address table
                        SET @au_address =   (
                                                SELECT TOP 1 LEFT(AddressLine1,40) 
                                                FROM AdventureWorks.Person.Address 
                                                WHERE AddressLine1 IS NOT NULL ORDER BY NEWID()
                                            )
                    
                        INSERT INTO authors 
                        VALUES
                        (
                             @author_id
                            ,@au_lname
                            ,@au_fname
                            ,@au_phone
                            ,@au_address
                            ,@au_city
                            ,@au_state
                            ,@au_zip
                            ,@au_contract
                        )
                    END
                ELSE
                    BEGIN
                        IF NOT EXISTS (SELECT TOP 1 1 FROM authors a WHERE a.au_id = @author_id)
                            BEGIN
                                RAISERROR('Author with selected ID does not exist', 16, 1) 
                            END
                        ELSE 
                            BEGIN  
                                SELECT   @au_lname = a.au_lname
                                        ,@au_fname = a.au_fname
                                        ,@au_phone = a.phone
                                        ,@au_city = a.city
                                        ,@au_state = a.[state]
                                FROM authors a 
                                WHERE a.au_id = @author_id
                            END 
                    END
            --#endregion

            --#region Insert into TitleAuthor Table
                INSERT INTO titleauthor
                VALUES
                (
                     @author_id
                    ,@random_title_id
                    ,@au_order
                    ,@royalty_per
                )
            --#endregion

            --#region Insert into Audit Table
                INSERT INTO Audit.Book 
                VALUES
                (
                     @pub_id 
                    ,@pub_name 
                    ,@pub_city   
                    ,@pub_state  
                    ,@pub_country
                    ,@random_title_id 
                    ,@prequel_id
                    ,@book_title 
                    ,@book_type 
                    ,@book_price 
                    ,@book_advance 
                    ,@book_royalty  
                    ,@book_ytd_sales  
                    ,@book_notes  
                    ,@book_pubdate  
                    ,@author_id  
                    ,@au_lname
                    ,@au_fname 
                    ,@au_phone 
                    ,@au_address 
                    ,@au_city 
                    ,@au_state
                    ,@au_zip
                    ,@au_contract 
                    ,@royalty_per 
                    ,@au_order 
                    ,GETDATE()
                    ,SYSTEM_USER
                )
            --#endregion

            PRINT('Book Has Been Sucessfully Added')
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END

```

<br/>

`[dbo].[USP_InsertBook]` stored procedure is a bit complex because it does not create just a book. If there is no publisher or author associated with that new book, it also helps user to create them. Thats why `@pub_id` and `@author_id` parameters of `[dbo].[USP_InsertBook]` stored procedure are optional.
If user selects an existing publisher or author from the dropdown menu element on the front-end app, selected value of the selected option, as an in the form of `@pub_id` or `@author_id`, is passed to the stored procedure. If an author or publisher for the new book is not found on the dropdown menu (or database) an app makes it easy to create them. Using the **last options** `Create New Author...` and `Create New Publisher...` on the dropdown menu, a user can create a new author or a publisher. Also a book may have prequel or not. So considering all these, there a 4 possible scenarios of creating a book.

Note: Dropdown menu items are populated with the existing authors and publishers in a database.

<br/>

These Test Cases are:<br/>
 * Create Book for Existing Author and Existing Publisher
 * Create Book for Existing Author and Non-Existent Publisher 
 * Create Book for Non-Existent Author and Existing Publisher
 * Create Book for Non-Existent Author and Non-Existent Publisher

<br/> 
Now lets test each of these test cases.

<br/>
<br/>

**Test Case 1: Create Book for Existing Author and Existing Publisher**

```sql
-- Publisher Allen & Unwin with pub_id = '9910' and Author J.R.R Tolkien with author_id = '254-26-6712' already exists on the db
EXEC pubs.dbo.USP_InsertBook @author_id = '254-26-6712'
                            ,@pub_id = '9910'
                            ,@au_order = 1
                            ,@royalty_per = 100
                            ,@book_title = 'The Silmarillion'
                            ,@book_type = 'Mythopoeia Fantasy'
                            ,@book_price = 45
                            ,@book_advance = 2500000
                            ,@book_royalty = 40
                            ,@book_ytd_sales = 50000000
                            ,@book_pubdate = '1977-09-15'
                            ,@book_notes = 'The Silmarillion is a collection of mythopoeic stories by the English writer J. R. R. Tolkien.'
```

<br>

**Test Case 4: Create Book for Non-Existent Author and Non-Existent Publisher**

```sql
EXEC pubs.dbo.USP_InsertBook @pub_name = 'Crown Publishing Group'
                            ,@pub_city = 'New York City'
                            ,@pub_state = 'NY'
                            ,@pub_country = 'US' 
                            ,@au_lname = 'Acemoglu'
                            ,@au_fname = 'Daron'
                            ,@au_phone = '999 000-0000'
                            ,@au_city = 'Newton'
                            ,@au_state = 'MA' 
                            ,@au_order = 1
                            ,@royalty_per = 50
                            ,@book_title = 'Why Nations Fail'
                            ,@book_type = 'Comparative Politics, Economics'
                            ,@book_price = 70
                            ,@book_advance = 100000
                            ,@book_royalty = 30
                            ,@book_ytd_sales = 500000
                            ,@book_pubdate = '2012-03-20'
                            ,@book_notes = 'Why Nations Fail first published in 2012, is a book by economists Daron Acemoglu and James Robinson...'
```

<br/>

**Test Case 2: Create Book for Existing Author and Non-Existent Publisher**

```sql
-- A book by existing author Daron Acemoglu with author_id = '408-40-8965' but with different publisher
EXEC pubs.dbo.USP_InsertBook @pub_name = 'Cambridge University Press'
                            ,@pub_city = 'Cambridge'
                            ,@pub_country = 'UK' 
                            ,@author_id = '408-40-8965'
                            ,@au_order = 1
                            ,@royalty_per = 50
                            ,@book_title = 'Economic Origins of Dictatorship and Democracy'
                            ,@book_type = 'Economics, Macroeconomics'
                            ,@book_price = 30
                            ,@book_advance = 50000
                            ,@book_royalty = 15
                            ,@book_ytd_sales = 500000
                            ,@book_pubdate = '2012-09-01'
                            ,@book_notes = 'Book develops a framework for analyzing the creation and consolidation of democracy...'

```

<br/>

**Test Case 3: Create Book for Non-Existent Author and Existing Publisher**

```sql
-- Different book by existing 'Cambridge University Press' with pub_id = '9912'
EXEC pubs.dbo.USP_InsertBook @pub_id = '9912' 
                            ,@au_lname = 'Von Zur Gathen'
                            ,@au_fname = 'Joachim'
                            ,@au_phone = '000 000-0000'
                            ,@au_city = 'Bonn' 
                            ,@au_order = 1
                            ,@royalty_per = 50
                            ,@book_title = 'Modern Computer Algebra'
                            ,@book_type = 'Computer Science'
                            ,@book_price = 100
                            ,@book_advance = 50000
                            ,@book_royalty = 10
                            ,@book_ytd_sales = 10000
                            ,@book_pubdate = '2013-01-01'
                            ,@book_notes = 'Computer algebra systems are now ubiquitous in all areas of science and engineering...'

```

<br/>


### II. Creating an Author on the Demo App

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/create-author-ui.png">
<br/>

<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/create_author.html" target="_blank"> View Demo</a></p>

<br/>

Stored procedure for adding an author into the `Authors` table

<br/>

```sql
CREATE PROCEDURE USP_CreateAuthor
     @au_lname VARCHAR(40)
    ,@au_fname VARCHAR(20)
    ,@au_phone CHAR(12) = '000 000-0000'
    ,@au_address VARCHAR(250) = NULL
    ,@au_city VARCHAR(20) = NULL
    ,@au_state CHAR(2) = NULL
    ,@au_zip CHAR(5) = NULL
    ,@au_contract BIT = 0
AS
BEGIN
    BEGIN TRY
        DECLARE @au_id dbo.tid 
        -- Generate Random AuthorID using USP_GenerateRandomAuthorId stored procedure
        EXEC USP_GenerateRandomAuthorId @au_id OUTPUT

        INSERT INTO authors 
        VALUES
        (
             @au_id
            ,@au_lname
            ,@au_fname
            ,@au_phone
            ,@au_address
            ,@au_city
            ,@au_state
            ,@au_zip
            ,@au_contract
        ) 
    END TRY 
    BEGIN CATCH
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH 
END
```
<br/>

Since creating an `author_id` is used in multiple stored procedures, I created an extra stored procedure that creates `author_id`.
<br/>

```sql
CREATE PROCEDURE [dbo].[USP_GenerateRandomAuthorId]
    @author_id VARCHAR(11) OUTPUT
AS
BEGIN
    DECLARE @a1 AS CHAR(3) = (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))
    DECLARE @a2 AS CHAR(2) = (SELECT(CAST((FLOOR(RAND()*(99-10+1)+10)) AS CHAR)))
    DECLARE @a3 AS CHAR(4) = (SELECT(CAST((FLOOR(RAND()*(9999-1000+1)+1000)) AS CHAR)))
    SELECT @author_id = (SELECT @a1 + '-' + @a2 + '-' + @a3)
END
```
<br/>

### III. Adding a CoAuthor into a Book on the Demo App

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/add-coauthor-ui.png">
<br/>

<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/add_coauthor.html" target="_blank"> View Demo</a></p>

<br/>

Stored procedure for adding a `CoAuthor`. If coauthor does not exist on the dropdown menu we can create a new author and add it.

<br/>

```sql
-- for demonstration purposes some columns (like address) are generated with dummy data
CREATE PROCEDURE USP_InsertCoAuthorForTitle
     @title_id dbo.tid 
    ,@au_id VARCHAR(11) = NULL
    ,@au_lname VARCHAR(40) = NULL
    ,@au_fname VARCHAR(20) = NULL
    ,@au_phone CHAR(12) = '000 000-0000'
    ,@au_city VARCHAR(20) = NULL
    ,@au_state CHAR(2) = NULL
    ,@au_order TINYINT = 2
    ,@royalty_per INT = 0
AS
BEGIN
    BEGIN TRY 
        BEGIN TRANSACTION
            IF NOT EXISTS(SELECT TOP 1 1 FROM titles WHERE title_id = @title_id)
                BEGIN 
                    RAISERROR('Book with provided ID does not exist', 16, 1)
                END

            IF(@au_id IS NULL)
                BEGIN
                    DECLARE @au_zip CHAR(5)
                    DECLARE @au_contract BIT
                    DECLARE @au_address VARCHAR(40)
                    -- Generate Random AuthorID using USP_GenerateRandomAuthorId stored procedure
                    EXEC USP_GenerateRandomAuthorId @au_id OUTPUT

                    -- Setting Random Zip in the 99xyz format
                    SET @au_zip = '99'+ (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))

                    -- Setting @au_contract as random 
                    SET @au_contract = (SELECT(CAST((FLOOR(RAND()*(1-0+1)+0)) AS BIT)))

                    -- Setting Random Address from AdventureWorks DB Person.Address table
                    SET @au_address =   (
                                            SELECT TOP 1 LEFT(AddressLine1,40) 
                                            FROM AdventureWorks.Person.Address 
                                            WHERE AddressLine1 IS NOT NULL 
                                            ORDER BY NEWID()
                                        )
                
                    INSERT INTO authors 
                    VALUES
                    (
                         @au_id
                        ,@au_lname
                        ,@au_fname
                        ,@au_phone
                        ,@au_address
                        ,@au_city
                        ,@au_state
                        ,@au_zip
                        ,@au_contract
                    )     

                    INSERT INTO titleauthor
                    VALUES
                    (
                         @au_id
                        ,@title_id
                        ,@au_order
                        ,@royalty_per
                    )
                END
            ELSE 
                BEGIN 
                    IF NOT EXISTS(SELECT TOP 1 1 FROM authors WHERE au_id = @au_id)
                        BEGIN 
                            RAISERROR('Author with provided ID does not exist', 16, 1)
                        END
                    ELSE 
                        BEGIN 
                            INSERT INTO titleauthor
                            VALUES
                            (
                                 @au_id
                                ,@title_id
                                ,@au_order
                                ,@royalty_per
                            )
                        END
                END
            PRINT('CoAuthor for the Provided Book Has Been Sucessfully Added')
        COMMIT TRANSACTION
    END TRY 
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH 
END
```
<br/>



### IV. Creating an Employee on the demo App

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/create-employee-ui.png">
<br/>
<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/create_employee.html" target="_blank"> View Demo</a></p>
<br/>

Stored procedure for adding an employee to the `Employee` table

<br/>

```sql
/*
    Created by Nury Amanmadov
    Date created: 11.04.2022 ddMMyyyy
*/

CREATE PROCEDURE [dbo].[USP_CreateEmployee]
     @pub_id AS CHAR(4)
    ,@emp_firstname AS VARCHAR(255) = NULL
    ,@emp_minit AS VARCHAR(255) = NULL 
    ,@emp_lastname AS VARCHAR(255) = NULL
    ,@emp_job_id AS INT
    ,@emp_job_lvl AS INT = NULL
    ,@emp_hire_date AS DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY 
        BEGIN TRANSACTION
            --#region Insert into Employee Table

                --#region Create Random Id for Emp_id
                -- Emp Id pattern: '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]'
                DECLARE @random_emp_id AS dbo.empid
                DECLARE @l1 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                DECLARE @l2 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                DECLARE @l3 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                DECLARE @l4 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                DECLARE @l5 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-0+1)+0)) AS CHAR)))
                DECLARE @l6 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-0+1)+0)) AS CHAR)))
                DECLARE @l7 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-0+1)+0)) AS CHAR)))
                DECLARE @l8 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-0+1)+0)) AS CHAR)))
                DECLARE @l9 AS CHAR(1) = (SELECT((SUBSTRING('FM',(ABS(CHECKSUM(NEWID())) % 2) + 1, 1))))
                SET @random_emp_id = (SELECT @l1 + @l2 + @l3 + @l4 + @l5 + @l6 + @l7 + @l8 + @l9)
                -- PRINT('EmpID with value: '+ CAST(@random_emp_id AS VARCHAR) + ' is created.')
                --#endregion

                -- Using Person table on AdventureWorks DB we can generate random names for employee
                IF (@emp_firstname IS NULL) 
                    SET @emp_firstname = (
                                            SELECT TOP 1 LEFT(p.FirstName,20) 
                                            FROM AdventureWorks.Person.Person p 
                                            ORDER BY NEWID()
                                         )
                
                IF (@emp_minit IS NULL) 
                    SET @emp_minit = (
                                        SELECT TOP 1 LEFT(p.MiddleName,1) 
                                        FROM AdventureWorks.Person.Person p 
                                        WHERE p.MiddleName IS NOT NULL 
                                        ORDER BY NEWID()
                                     )
                
                IF (@emp_lastname IS NULL) 
                    SET @emp_lastname = (
                                            SELECT TOP 1 LEFT(p.LastName,30) 
                                            FROM AdventureWorks.Person.Person p 
                                            ORDER BY NEWID()
                                        )
                
                -- Using jobs table we can get random job level between max_lvl and min_lvl of the generated @emp_job_id
                IF (@emp_job_lvl IS NULL)
                    SET @emp_job_lvl =  (
                                            SELECT TOP 1 FLOOR(RAND() * (max_lvl - min_lvl + 1) + min_lvl) 
                                            FROM [pubs].[dbo].[jobs] 
                                            WHERE job_id = @emp_job_id ORDER BY NEWID()
                                        )
                
                -- Using Employee table on AdventureWorks DB we can generate random hiredate for employee
                IF (@emp_hire_date IS NULL)
                    SET @emp_hire_date = (
                                            SELECT TOP 1 CAST(e.HireDate AS DATETIME) 
                                            FROM AdventureWorks.HumanResources.Employee e 
                                            ORDER BY NEWID()
                                         )

                INSERT INTO [pubs].[dbo].[employee] 
                VALUES (
                             @random_emp_id
                            ,@emp_firstname
                            ,@emp_minit
                            ,@emp_lastname
                            ,@emp_job_id
                            ,@emp_job_lvl
                            ,@pub_id
                            ,@emp_hire_date
                        )
            --#endregion
            PRINT('Employee Has Been Sucessfully Added')
        COMMIT TRANSACTION
    END TRY  
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END 
```
<br/>




### V. Listing Books on the Demo App

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/top-books.png">
<br/>

<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/report_books.html" target="_blank"> View Demo</a></p>
<br/>

Stored procedure for getting `books` as in the form of `HTML table row`

<br/>

```sql
/*
    Created by Nury Amanmadov
    Date created: 16.04.2022 ddMMyyyy

    Selects TOP 20 Book as in the form of HTML table row records 
    These records then rendered as an HTML elements on the front-end side

*/

CREATE PROCEDURE [dbo].[USP_GetAllBooks]
AS 
BEGIN 
    SELECT TOP 20
    '<tr class="even pointer">
        <td class="a-center "><input type="checkbox" class="flat" name="table_records"></td>
        <td>'+ t.title_id +'</td>
        <td>'+ title +'</td>
        <td>'+ a.au_fname + ' ' + a.au_lname +'</td>
        <td>'+ p.pub_name +'</td>
        <td>'+ type +'</td>
        <td>'+ ISNULL(CAST(price AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(advance AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(royalty AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(ytd_sales AS VARCHAR),'NA') +'</td>
        <td class="last"><a href="#">View</a></td>
    </tr>' AS TableRow
    FROM titles t 
    JOIN publishers p ON t.pub_id = p.pub_id
    JOIN titleauthor ta ON ta.title_id = t.title_id
    JOIN authors a ON a.au_id = ta.au_id
    ORDER BY p.pub_id DESC
END
```

<br/>


### VI. Listing Top Authors on the Demo App

<br/>
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/top-authors.png">

<br/>
<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/report_authors.html" target="_blank"> View Demo</a></p>
<br/>

Stored procedure for getting `authors` as in the form of `HTML table row`

<br/>

```sql
CREATE PROCEDURE [dbo].[USP_GetAllAuthors]
AS 
BEGIN 
    SELECT TOP 20
    '<tr class="even pointer">
        <td class="a-center "><input type="checkbox" class="flat" name="table_records"></td>
        <td>'+ au_id +'</td>
        <td>'+ au_fname +'</td>
        <td>'+ au_lname +'</td>
        <td>'+ ISNULL(CAST(phone AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(address AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(city AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(state AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(zip AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(contract AS VARCHAR),'NA') +'</td>
        <td class="last"><a href="#">View</a></td>
    </tr>' AS TableRow
    FROM authors a
    ORDER BY zip DESC
END
```

<br/>

### VII. Listing Top Publishers on the Demo App

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/top-publishers.png">
<br/>
<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/report_publishers.html" target="_blank"> View Demo</a></p>
<br/>

Stored procedure for getting `publishers` as in the form of `HTML table row`

<br/>

```sql
CREATE PROCEDURE [dbo].[USP_GetAllPublishers]
AS 
BEGIN 
    SELECT TOP 20
                    '<tr class="even pointer">
                        <td class="a-center "><input type="checkbox" class="flat" name="table_records"></td>
                        <td>'+ p.pub_id +'</td>
                        <td>'+ p.pub_name +'</td>
                        <td>'+ p.city +'</td>
                        <td>'+ ISNULL(p.[state],'NA') +'</td>
                        <td>'+ p.country +'</td>
                        <td>'+ CAST(COUNT(DISTINCT t.title_id) AS VARCHAR) +'</td>
                        <td>'+ CAST(ISNULL(SUM(t.ytd_sales),0) AS VARCHAR) +'</td>
                        <td>'+ CAST(COUNT(DISTINCT e.emp_id) AS VARCHAR) +'</td>
                        <td class="last"><a href="#">View</a></td>
                    </tr>' AS TableRow
    FROM publishers p 
    LEFT JOIN titles t ON t.pub_id = p.pub_id
    LEFT JOIN employee e ON e.pub_id = p.pub_id
    GROUP BY p.pub_id
            ,p.pub_name
            ,p.city
            ,p.[state]
            ,p.country
    ORDER BY SUM(t.ytd_sales) DESC
END
```

<br/>

### VIII. Listing Employees on the Demo App

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/top-employees.png">
<br/>
<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/report_employees.html" target="_blank"> View Demo</a></p>
<br/>

Stored procedure for getting `employees` as in the form of `HTML table row`

<br/>

```sql
CREATE PROCEDURE [dbo].[USP_GetAllEmployee]
AS 
BEGIN 
    SELECT TOP 100
                    '<tr class="even pointer">
                        <td class="a-center "><input type="checkbox" class="flat" name="table_records"></td>
                        <td>'+ e.emp_id +'</td>
                        <td>'+ e.fname +'</td>
                        <td>'+ e.lname +'</td>
                        <td>'+ j.job_desc +'</td>
                        <td>'+ CAST((e.job_lvl) AS VARCHAR) +'</td>
                        <td>'+ p.pub_name +'</td>
                        <td>'+ CAST(CAST(e.hire_date AS DATE) AS VARCHAR) +'</td>
                        <td class="last"><a href="#">View</a></td>
                    </tr>' AS TableRow
    FROM employee e 
    JOIN publishers p On p.pub_id = e.pub_id 
    JOIN jobs j ON j.job_id = e.job_id
    ORDER BY hire_date 
END
```

<br/>

### IX. Listing Books with Prequel

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/book_prequel-list.png">
<br/>
<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/get_prequel.html" target="_blank"> View Demo</a></p>
<br/>

Here at the front-end side, I developed some logic with javascript to simulate the stored procedure functionality  
`Recursive` stored procedure for getting prequel books for a specific book

<br/>

```sql
/*
    Created by Nury Amanmadov
    Date created: 17.04.2022 ddMMyyyy

    Selects all the prequel book series of a given book

*/

ALTER PROCEDURE [dbo].[USP_GetAllPrequelBooksByTitleId]
    @title_id dbo.tid
AS 
BEGIN
    IF NOT EXISTS(SELECT TOP 1 1 FROM titles WHERE title_id = @title_id)
        BEGIN 
            RAISERROR('Book with provided ID does not exist', 16, 1)
        END
    ;WITH CTEBooks
    AS 
    (
        SELECT   title_id AS TitleId
                ,title AS Book
                ,prequel_id
                ,CAST(t1.pubdate AS DATE) AS [Publication Date]
                ,p.pub_name AS Publisher
        FROM titles t1
        JOIN publishers p ON p.pub_id = t1.pub_id
        WHERE title_id = @title_id

        UNION ALL

        SELECT   t2.title_id AS TitleId
                ,t2.title AS Book
                ,t2.prequel_id
                ,CAST(t2.pubdate AS DATE) AS [Publication Date]
                ,p.pub_name AS Publisher
        FROM titles t2
        JOIN publishers p ON p.pub_id = t2.pub_id
        JOIN CTEBooks ON t2.title_id = CTEBooks.prequel_id
    )
    SELECT  CTEBooks.TitleId 
            ,CTEBooks.Book
            ,ISNULL(t.title, 'No Prequel') AS PrequelBook
            ,[Publication Date]
            ,a.au_fname + ' ' + a.au_lname AS Author
            ,CTEBooks.Publisher
    FROM CTEBooks
    LEFT JOIN titles t ON CTEBooks.prequel_id = t.title_id
    LEFT JOIN titleauthor ta ON ta.title_id = CTEBooks.TitleId
    LEFT JOIN authors a ON a.au_id = ta.au_id
END
```

<br/>

Now if we execute this stored procedure with an `title_id` of a continuing book in a series we will get the prequel books of that book.

<br/>

```sql
-- For 'Harry Potter and the Deathly Hallows' in the 'Harry Potter' Series
EXEC USP_GetAllPrequelBooksByTitleId @title_id = 'GU4539'
```
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/harry-potter.png">
<br/>


```sql
-- For 'The Return of the King' in the 'Lord of the Rings' Series
EXEC USP_GetAllPrequelBooksByTitleId @title_id = 'ZJ4675' 
```

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/lotr.png">
<br/>

```sql
-- For 'A Dream of Spring' in the 'Game of the Thrones' Series
EXEC USP_GetAllPrequelBooksByTitleId @title_id = 'SA4547'
```
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/got.png">
<br/>

<br/>

### X. Listing Continuing Books in s Book Series

<br/>

```sql

/*
    Created by Nury Amanmadov
    Date created: 18.04.2022 ddMMyyyy

    Selects all the continuing books in series

*/

CREATE PROCEDURE [dbo].[USP_GetAllContinuingBooksByTitleId]
    @title_id dbo.tid
AS 
BEGIN 
    IF NOT EXISTS(SELECT TOP 1 1 FROM titles WHERE title_id = @title_id)
        BEGIN 
            RAISERROR('Book with provided ID does not exist', 16, 1)
        END

    ;WITH CTEBooks
    AS 
    (
        SELECT   title_id AS TitleId
                ,title AS Book
                ,prequel_id
                ,CAST(t1.pubdate AS DATE) AS [Publication Date]
                ,p.pub_name AS Publisher
                ,[Order In Series] = 1
        FROM titles t1
        JOIN publishers p ON p.pub_id = t1.pub_id
        WHERE title_id = @title_id

        UNION ALL

        SELECT   t2.title_id AS TitleId
                ,t2.title AS Book
                ,t2.prequel_id
                ,CAST(t2.pubdate AS DATE) AS [Publication Date]
                ,p.pub_name AS Publisher
                ,[Order In Series] + 1
        FROM titles t2
        JOIN publishers p ON p.pub_id = t2.pub_id
        JOIN CTEBooks ON t2.prequel_id = CTEBooks.TitleId
    )
    SELECT  CTEBooks.TitleId 
            ,CTEBooks.Book
            ,ISNULL(t.title, 'No Prequel') AS PrequelBook
            ,[Publication Date]
            ,a.au_fname + ' ' + a.au_lname AS Author
            ,CTEBooks.Publisher
            ,[Order In Series]
    FROM CTEBooks
    LEFT JOIN titles t ON CTEBooks.prequel_id = t.title_id
    LEFT JOIN titleauthor ta ON ta.title_id = CTEBooks.TitleId
    LEFT JOIN authors a ON a.au_id = ta.au_id
END
```
<br/>

Now if we execute this stored procedure with an `title_id` of a book in a series we will get the continuing books of that series.

<br/>

```sql
-- For 'The Lord of the Rings' Series
EXEC [dbo].[USP_GetAllContinuingBooksByTitleId] 'EX5727'
```
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/snap1.png">
<br/>


```sql
-- For 'A Game of Thrones' Series
EXEC [dbo].[USP_GetAllContinuingBooksByTitleId] 'CI5668'
```
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/snap2.png">
<br/>

```sql
-- For 'Harry Potter' Series
EXEC [dbo].[USP_GetAllContinuingBooksByTitleId] 'VC5136'
```
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/snap3.png">
<br/>


### XI. Delete a Book from Titles table
<br/>

Stored procedure for deleting a book

<br/>

```sql
/*

Created by Nury Amanmadov
Date created: 16.04.2022

Rule for deleting a book  
    - Publisher related to that title will not be deleted
    - PublisherInfo related to the Publisher of that title will not be deleted
    - Author related to that title will not be deleted 
    - Records related to that title from Titles and TitleAuthor tables will be deleted 

Because there are publishers without any title on the initial database created by Microsoft (ex: pub_id with 1622 and 1756)

SELECT DISTINCT pub_id 
FROM publishers 
WHERE pub_id NOT IN 
(
    SELECT DISTINCT pub_id FROM titles 
)

*/

CREATE PROCEDURE [dbo].[USP_DeleteBook]
    @title_id dbo.tid,
    @au_id dbo.id
AS
BEGIN
    BEGIN TRY 
        BEGIN TRANSACTION
            DELETE FROM titles WHERE title_id = @title_id
            DELETE FROM titleauthor WHERE title_id = @title_id and au_id = @au_id
            PRINT('Book Has Been Sucessfully Deleted')
        COMMIT TRANSACTION
    END TRY 
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END
```

<br/>

### XII. Selecting Records from Audit.Book table

<br/>

```sql
SELECT * 
FROM [pubs].[Audit].[Book]
```
<br/>
<p>Link for the [Audit].[Book] records file:<a href="https://github.com/amanmadov/msin616-final-project/blob/main/files/audit-book-records.csv" target="_blank"> View Records</a></p>
<p>Link for the entire Pubs DB scripts file:<a href="https://github.com/amanmadov/msin616-final-project/blob/main/db-scripts/PubsDB-Scripts.sql" target="_blank"> View File</a></p>
<p>Link for the entire Pubs DB bak file:<a href="https://github.com/amanmadov/msin616-final-project/blob/main/db-scripts/PubsDB-2022418-16-10-5.bak" target="_blank"> View File</a></p>
<p>Simple Front End UI App for the Pubs Database <a href="https://amanmadov.github.io/msin616-final-project/">View App</a></p>
<br/>






<!-- CONTACT -->
## Contact

Nury Amanmadov - [@amanmadov](https://twitter.com/amanmadov) - amanmadov@gmail.com

Project Link: [https://github.com/amanmadov/msin616-final-project](https://github.com/amanmadov/msin616-final-project)

<p align="right">(<a href="#top">back to top</a>)</p>

