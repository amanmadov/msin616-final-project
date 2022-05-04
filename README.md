<p align="right"><img src="https://img.shields.io/badge/License-MIT-yellow.svg"></p>

<!-- PROJECT LOGO -->
<br/>
<div align="center">
  <a href="https://github.com/amanmadov/msin617-final-project">
    <img src="https://github.com/amanmadov/msin617-final-project/blob/main/images/touro-logo.png" alt="Logo">
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

This is a simple database that can be used to maintain the data stored and processed by a **lending library**. 
The database has been designed by modifying Microsoft's `Pubs` database.
The `Pubs` database provides a set of fictional pieces of information about **publishers**, **authors**, **titles** and **sales** of books.
It is now considered **obsolete**; it is no longer provided with `SQL Server` since the **2008 version**.
The tables and fields are quite obvious. 
They have names such as `Authors`, `Titles`, etc., which reflect their content. 
And the fields also have obvious names explaining what they contain.

<p>
  You can find the details about original Pubs DB in the link:
  <a href="https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs" target="_blank">Microsoft Pubs DB</a>
</p>

Below you can see the altered database diagram of the `Pubs` database

<br/>

![Database Schema Screen Shot](https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/erd.png)

<br/>

<p>
  Link for the database schema:<a href="https://drawsql.app/softttt/diagrams/copy-of-msin616-pubs-db"> DB Schema</a>
</p>

<br/>


## Technologies Used
 - Microsoft SQL Server 2019 - 15.0.4198.2 Developer Edition (64-bit) on Linux (Ubuntu 20.04.3 LTS)
 - Azure Data Studio version 1.35.1
 - Docker version 4.4.2 (73305)

<br/>

## Modifications on the Database

- [x] To simulate a real world full stack app, a demo CRUD app with front-end UI has been developed.
- [x] `Gentellela`, an open source admin panel, has been used to create front-end UI.
- [x] Stored procedures are created for the demo CRUD app.
- [x] Some custom validations has been developed on the Front-end UI to prevent data inconsistency.
- [x] Almost all stored procedures for creating/modifying records are created based on the front-end validations.
- [x] `[TITLES]` table have been altered and **prequel_id** column have been added to store the prequel of a book.
- [x] Using prequel books, recursive queries can be written and executed on the `[TITLES]` table.
- [x] `[TITLES]` table have been altered and **ISBN** column have been added.
- [x] Some famous book series like **"A Game of Thrones"** or **"The Lord of The Rings"** are added to the `[TITLES]` table.
- [x] Some famous author and publisher records are added to related tables.
- [x] Some of the **column types** are also modified.
- [x] Created `[Audit].[Book]` table to keep audit history of the created books.
- [x] Used `[Adventureworks].[Person].[Person]` and `[AdventureWorks].[HumanResources].[Employee]` tables to generate dummy data.
- [x] `Jobs` table has been dropped 
- [X] `Roysched` table has been dropped 
- [x] `Employees` table has been altered
- [x] `Employee_type` table has been created
- [x] `Category` table has been created 
- [x] `TitleCategory` table has been created 
- [x] `Degrees` table has been created
- [x] `Schools` table has been created
- [x] `Branchs` table has been created
- [x] `Shift_logs` table has been created
- [x] `Paychecks` table has been created
- [x] `Borrowers` table has been created
- [x] `Bookcopies` table has been created
- [x] `Bookcopy_history` table has been created
- [x] `Books_borrowed` table has been created
- [x] Created user defined functions and views to generate and insert **dummy data** to database.
- [x] Created triggers to **prevent data inconsistency**. 


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
    Date created: 10.04.2022
*/

CREATE PROCEDURE [dbo].[USP_InsertBook] 
     @book_title AS VARCHAR(100)
    ,@prequel_id AS VARCHAR(6) = NULL
    ,@book_price AS MONEY
    ,@book_advance AS MONEY
    ,@book_royalty INT
    ,@book_ytd_sales INT
    ,@book_notes VARCHAR(800)
    ,@book_pubdate DATETIME
    ,@book_isbn VARCHAR(17)
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
                        SET @pub_id = (SELECT CAST(MAX(CAST(pub_id AS INT) + 1) AS VARCHAR) FROM publishers AS VARCHAR)
                        
                        INSERT INTO [pubs].[dbo].[publishers] 
                        VALUES  (
                                     ISNULL(@pub_id,1)
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
                                        ISNULL(@pub_id,1)
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
                                ;THROW 50001, 'Publisher with selected ID does not exist', 1
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
                    DECLARE @random_title_id [dbo].[tid] = [dbo].[fn_GenerateRandomTitleId](RAND())

                INSERT INTO titles
                VALUES
                (
                     @random_title_id
                    ,@book_title
                    ,ISNULL(@pub_id,1)
                    ,@book_price
                    ,@book_advance
                    ,@book_royalty
                    ,@book_ytd_sales
                    ,@book_notes
                    ,@book_pubdate
                    ,@prequel_id
                    ,@book_isbn
                )

            --#endregion

            --#region Insert into Authors Table

                DECLARE @au_zip CHAR(5)
                DECLARE @au_contract BIT
                DECLARE @au_address VARCHAR(40)

                IF(@author_id IS NULL)
                    BEGIN 
                        -- Generate Random AuthorID
                        SET @author_id = dbo.fn_GenerateRandomAuthorId(RAND())
                        
                        -- Setting Random Zip in the 99xyz format
                        SET @au_zip = '99'+ (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))

                        -- Setting @au_contract as random 
                        SET @au_contract = (SELECT(CAST((FLOOR(RAND()*(1-0+1)+0)) AS BIT)))

                        -- Setting Random Address from AdventureWorks DB Person.Address table
                        SET @au_address = (SELECT TOP 1 LEFT(AddressLine1,40) FROM AdventureWorks.Person.Address WHERE AddressLine1 IS NOT NULL ORDER BY NEWID())
                    
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
                                ;THROW 50002, 'Author with selected ID does not exist', 1 
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
                     ISNULL(@pub_id,1) 
                    ,@pub_name 
                    ,@pub_city   
                    ,@pub_state  
                    ,@pub_country
                    ,@random_title_id 
                    ,@prequel_id
                    ,@book_title 
                    ,NULL 
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

These Test Cases are:
<br/>

```diff

+ Create Book for Existing Author and Existing Publisher
+ Create Book for Existing Author and Non-Existent Publisher
+ Create Book for Non-Existent Author and Existing Publisher
+ Create Book for Non-Existent Author and Non-Existent Publisher

```

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
/*
    Created by Nury Amanmadov
    Date created: 17.04.2022
*/

CREATE PROCEDURE [dbo].[USP_CreateAuthor]
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
        -- Generate Random AuthorID 
        DECLARE @au_id dbo.tid 
        SET @au_id = dbo.fn_GenerateRandomAuthorId(RAND())

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

Since creating an `author_id` is used in multiple stored procedures, I created a function that creates `author_id`.
<br/>

```sql
CREATE FUNCTION [dbo].[fn_GenerateRandomAuthorId](
    @RAND FLOAT 
)
RETURNS VARCHAR(11) AS
BEGIN
    DECLARE @author_id VARCHAR(11)
    DECLARE @isFound BIT = 0
    WHILE (@isFound = 0)
        BEGIN
            DECLARE @a1 AS CHAR(3) = (SELECT(CAST((FLOOR(@RAND*(999-100+1)+100)) AS CHAR)))
            DECLARE @a2 AS CHAR(2) = (SELECT(CAST((FLOOR(@RAND*(99-10+1)+10)) AS CHAR)))
            DECLARE @a3 AS CHAR(4) = (SELECT(CAST((FLOOR(@RAND*(9999-1000+1)+1000)) AS CHAR)))
            SET @author_id = (SELECT @a1 + '-' + @a2 + '-' + @a3)
            IF EXISTS(SELECT TOP 1 1 FROM [authors] WHERE au_id = @author_id)
                BEGIN
                    CONTINUE
                END
            ELSE 
                BEGIN
                    SET @isFound = 1
                END
        END
    RETURN @author_id
END;
```
<br/>

### III. Adding a CoAuthor into a Book on the Demo App

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/add-coauthor2.gif">
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
    ,@au_phone CHAR(12) = '000-000-0000'
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
                    ;THROW 50001, 'Book with provided ID does not exist', 1
                END

            IF(@au_id IS NULL)
                BEGIN
                    DECLARE @au_zip CHAR(5)
                    DECLARE @au_contract BIT
                    DECLARE @au_address VARCHAR(40)

                    -- Generate Random AuthorID
                    SET @au_address = dbo.fn_GenerateRandomAuthorId(RAND())

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
                            ;THROW 50002, 'Author with provided ID does not exist', 1
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
    Date created: 11.04.2022
*/

CREATE PROCEDURE [dbo].[USP_CreateEmployee]
(
     @firstname AS VARCHAR(100)
    ,@lastname AS VARCHAR(100)
    ,@address AS VARCHAR(200)
    ,@homephone AS CHAR(12)
    ,@cellphone AS CHAR(12)
    ,@salary_type AS CHAR(1)
    ,@salary AS DECIMAL(6,0)
    ,@birthdate DATE
    ,@degee_id INT
    ,@school_id INT
    ,@branch_id INT
    ,@ishead_librarin BIT
    ,@emp_type_id INT
    ,@degreedate DATE
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY 
        BEGIN TRANSACTION
            DECLARE @id INT = (SELECT MAX(employee_id) + 1 FROM employees)
                INSERT INTO [pubs].[dbo].[employees] 
                VALUES (
                             @id
                            ,@firstname 
                            ,@lastname 
                            ,@address 
                            ,@homephone 
                            ,@cellphone  
                            ,@salary_type 
                            ,@salary  
                            ,@birthdate 
                            ,GETDATE() 
                            ,114 
                            ,@degee_id 
                            ,@school_id 
                            ,@branch_id 
                            ,@ishead_librarin 
                            ,@emp_type_id 
                            ,@degreedate
                            ,1
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

### VIII. Listing Books with Prequel

<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/list-prequel.gif">
<br/>
<p>Link for the front-end ui module:<a href="https://amanmadov.github.io/msin616-final-project/production/get_prequel.html" target="_blank"> View Demo</a></p>
<br/>

Here at the front-end side, I developed some logic with javascript to simulate the stored procedure functionality. 
This is a `Recursive` stored procedure for getting prequel book or books for a specific book in a series. Used `CTE` inside the query.

<br/>

```sql
/*
    Created by Nury Amanmadov
    Date created: 17.04.2022 ddMMyyyy

    Selects all the prequel book series of a given book

*/

CREATE PROCEDURE [dbo].[USP_GetAllPrequelBooksByTitleId]
    @title_id dbo.tid
AS 
BEGIN
    IF NOT EXISTS(SELECT TOP 1 1 FROM titles WHERE title_id = @title_id)
        BEGIN 
            ;THROW 50001, 'Book with provided ID does not exist', 1
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

Now if we execute this stored procedure with a `title_id` of a continuing book in a series we will get the **prequel books** of that book.

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

### IX. Listing Continuing Books in s Book Series

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
	    ;THROW 50001, 'Book with provided ID does not exist', 1
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

Now if we execute this stored procedure with an `title_id` of a book in a series we will get the **continuing books** of that series.

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


### X. Delete a Book from Titles table
<br/>

Stored procedure for **deleting** a book

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

### XI. Selecting Records from Audit.Book table

<br/>

```sql
SELECT * 
FROM [pubs].[Audit].[Book]
```
<br/>
<p>Link for the [Audit].[Book] records file:<a href="https://github.com/amanmadov/msin616-final-project/blob/main/files/audit-book-records.csv" target="_blank"> View Records</a></p>


<br/>

<div> <h2 align="center">Custom Stored Procedures, Functions and Triggers for the Lending Library</h2></div>

<br/>

### I. Creating a Borrower on the database

<br/>

The library issues library cards to people who wish to borrow books from the library. The library keeps a list of each borrower by storing the `card id` , `borrower name` , `address` , `phone number` , `birthdate` , `date the card was issued` and `balance due` . A card expires **ten years** from the time it is issued.
If a person is **less than 18 years old**, then the library will also keep information about the Borrower’s parent or legal guardian such as `name` , `address` and `phone number` .
A person can have only **one valid library card** at a given time.
A person **can’t be issued a new library card**, if he **owes money on an expired card**.

<br/>

```sql
/*

    Rules for borrowing a book:
    - Any reading item that is categorized as reference may not be borrowed.
    - Copies that are in POOR condition may not be borrowed.
    - When a book copy is borrowed, the copy is marked as BORROWED. BORROWED copies may not be borrowed.
    - A borrower can not use a card to borrow books, if he owes more than 10 dollars on that card.

*/

CREATE PROCEDURE [dbo].[USP_BorrowBook] 
    @copy_id AS INT,
    @card_id AS INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            --#region Check if copy is of type Reference
                IF EXISTS(
                    SELECT TOP 1 1 
                    FROM titlecategory tc
                    JOIN bookcopies bc ON bc.title_id = tc.title_id
                    WHERE bc.copy_id = @copy_id AND tc.title_type_id = (SELECT type_id FROM category c WHERE c.[type] = 'Reference')
                )
                    BEGIN
                        ;THROW 50001, 'Copy of type Reference can not be borrowed', 1 
                    END
            --#endregion
            --#region Check if copy is in POOR 
                IF EXISTS (
                    SELECT copy_id
                    FROM bookcopies 
                    WHERE condition = 'POOR' AND copy_id = @copy_id
                )
                    BEGIN
                        ;THROW 50002, 'Copies in POOR condition can not be borrowed', 1  
                    END
            --#endregion
            --#region Check if copy is BORROWED or Discarded
                IF EXISTS (
                    SELECT copy_id
                    FROM bookcopies 
                    WHERE (isactive = 0 OR isavailable = 0) AND copy_id = @copy_id
                )
                    BEGIN
                        ;THROW 50003, 'Copies that are Discarded or already Borrowed can not be borrowed.', 1  
                    END
            --#endregion
            --#region Check if borrower is available to borrow a book
                IF EXISTS (
                    SELECT * 
                    FROM borrowers 
                    WHERE card_id = @card_id AND (isexpired = 1 OR balancedue >= 10)
                )
                    BEGIN
                        ;THROW 50004, 'Either borrowers card expired or borrower owes over 10 dollars.', 1
                    END
            --#endregion
            UPDATE bookcopies SET isavailable = 0 WHERE copy_id = @copy_id
            DECLARE @id INT = (SELECT MAX(id) + 1 FROM books_borrowed)
            INSERT INTO books_borrowed 
            VALUES 
            (
                ISNULL(@id,1),
                @copy_id,
                @card_id,
                GETDATE(),
                GETDATE() + 14,
                0,
                NULL
            )
            PRINT('Book Has Been Sucessfully Borrowed')
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END
```

Stored procedure for **expiring cards after 10 years**

```sql
CREATE PROCEDURE [dbo].[USP_ExpireLibraryCards]
AS 
BEGIN 
    UPDATE borrowers SET isexpired = 1
    WHERE DATEDIFF(YY,card_issuedate,GETDATE()) >= 10
END
```

Created **dummy borrower data** using the stored procedure below. 

```sql
CREATE PROCEDURE [dbo].[USP_InsertRandomBorrower]
AS
BEGIN
    DECLARE @id INT 
    DECLARE @ssn VARCHAR(11) 
    DECLARE @fname VARCHAR(100) 
    DECLARE @lname VARCHAR(100) 
    DECLARE @address VARCHAR(200) 
    DECLARE @phone CHAR(12) 
    DECLARE @birthdate DATE
    DECLARE @cardissuedate DATE
    DECLARE @balancedue DECIMAL(6,2)
    DECLARE @lgname VARCHAR(200) = NULL 
    DECLARE @lgaddress VARCHAR(200) = NULL 
    DECLARE @lgphone VARCHAR(200) = NULL 

    SET @id = (SELECT MAX(id) + 1 FROM borrowers )
    SET @fname = dbo.fn_GenerateFirstName()
    SET @lname = dbo.fn_GenerateLastName()
    SET @ssn = dbo.fn_GenerateRandomSsn(RAND())
    SET @address = dbo.fn_GenerateRandomAddress()
    SET @phone = dbo.fn_GenerateRandomPhone(RAND())

    SET @birthdate = dbo.fn_GenerateRandomDate('1999-01-01','2010-01-01',RAND())
    DECLARE @age INT = DATEDIFF(YY,@birthdate,GETDATE())
    SET @cardissuedate = DATEADD(year, dbo.fn_GetRandomNumber(5,@age,RAND()), @birthdate)
    
    SET @balancedue = 0
    
    IF(@age < 17)
        BEGIN
            SET @lgname = dbo.fn_GenerateFirstName()
            --Set randomly address of borrower same as guardians
            DECLARE @isSameAddress BIT = CAST(ROUND(RAND(),0) AS BIT)
            IF(@isSameAddress = 0) 
                BEGIN 
                    SET @lgaddress = @address 
                END  
            ELSE 
                BEGIN 
                    SET @lgaddress = dbo.fn_GenerateRandomAddress()
                END 
            SET @lgphone = dbo.fn_GenerateRandomPhone(RAND())
        END 

    INSERT INTO borrowers
    VALUES 
    (
         ISNULL(@id,1) -- if first time 
        ,ISNULL(@id,1) -- if first time 
        ,@ssn  
        ,@fname 
        ,@lname 
        ,@address 
        ,@phone   
        ,@birthdate 
        ,@cardissuedate 
        ,@balancedue 
        ,0 -- default value
        ,@lgaddress 
        ,@lgname
        ,@lgphone  
    )

    PRINT('Borrower sucessfully created.')
END
```

User defined functions to create necessary dummy data


```sql
-- Since inside user defined functions we cant use NEWID() or RAND()
CREATE View [dbo].[view_NewID] AS SELECT NEWID() AS id
```

```sql
CREATE FUNCTION [dbo].[fn_GenerateFirstName]()
RETURNS VARCHAR(100) AS
BEGIN
    DECLARE @fname VARCHAR(100)
    SET @fname = 
                    (
                        SELECT TOP 1 p.FirstName 
                        FROM AdventureWorks.Person.Person p  
                        ORDER BY (SELECT id FROM dbo.view_NewID)
                    )
    RETURN @fname
END;
```
<br/>

```sql
CREATE FUNCTION [dbo].[fn_GenerateLastName]()
RETURNS VARCHAR(100) AS
BEGIN
    DECLARE @lname VARCHAR(100)
    SET @lname = 
                    (
                        SELECT TOP 1 p.LastName 
                        FROM AdventureWorks.Person.Person p  
                        ORDER BY (SELECT id FROM dbo.view_NewID)
                    )
    RETURN @lname
END;
```
<br/>

```sql
CREATE FUNCTION [dbo].[fn_GenerateRandomAddress]()
RETURNS VARCHAR(200) AS
BEGIN
    DECLARE @address VARCHAR(200)
    SET @address = 
                    (
                        SELECT TOP 1 ad.AddressLine1
                        FROM AdventureWorks.Person.Address ad
                        WHERE AddressLine1 IS NOT NULL
                        ORDER BY (SELECT id FROM dbo.view_NewID)
                    )
    RETURN @address
END;
```
<br/>

```sql
CREATE FUNCTION [dbo].[fn_GenerateRandomDate]
(
	 @DateStart DATE
	,@DateEnd DATE
        ,@RAND FLOAT
)
RETURNS DATE AS
BEGIN
    DECLARE @randomDate DATE
    SET	@randomDate = DateAdd(Day, @RAND * DateDiff(Day, @DateStart, @DateEnd), @DateStart)
    RETURN @randomDate
END;
```
<br/>

```sql
CREATE FUNCTION [dbo].[fn_GenerateRandomPhone]
(
    @RAND FLOAT 
)
RETURNS VARCHAR(12) AS
BEGIN
    DECLARE @phone VARCHAR(12)
    DECLARE @p1 AS CHAR(3) = (SELECT(CAST((FLOOR(@RAND*(999-100+1)+100)) AS CHAR)))
    DECLARE @p2 AS CHAR(3) = (SELECT(CAST((FLOOR(@RAND*(999-100+1)+100)) AS CHAR)))
    DECLARE @p3 AS CHAR(4) = (SELECT(CAST((FLOOR(@RAND*(9999-1000+1)+1000)) AS CHAR)))
    SET @phone = (SELECT @p1 + '-' + @p2 + '-' + @p3)
    RETURN @phone
END;
```
<br/>

```sql
CREATE FUNCTION [dbo].[fn_GenerateRandomSsn]
(
    @RAND FLOAT 
)
RETURNS VARCHAR(11) AS
BEGIN
    DECLARE @ssn VARCHAR(11)
    SET @ssn = (
                    CAST(CAST(100 + (898 * @RAND) AS INT) AS VARCHAR(3)) + 
                    '-' + 
                    CAST(CAST(10 + (88 * @RAND) AS INT) AS VARCHAR(2)) + 
                    '-' + 
                    CAST(CAST(1000 + (8998 * @RAND) AS INT) AS VARCHAR(4))
                  )
    RETURN @ssn
END;
```

<br/>

```sql
CREATE FUNCTION [dbo].[fn_GenerateRandomTitleId](
    @RAND FLOAT 
)
RETURNS [dbo].[tid] AS
BEGIN
    DECLARE @random_title_id [dbo].[tid]
    DECLARE @isFound BIT = 0
    WHILE (@isFound = 0)
        BEGIN
            DECLARE @randomid1 UNIQUEIDENTIFIER = (SELECT id FROM dbo.view_NewID)
            DECLARE @randomid2 UNIQUEIDENTIFIER = (SELECT id FROM dbo.view_NewID)
            DECLARE @t1 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(@randomid1)) % 26) + 1, 1))
            DECLARE @t2 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(@randomid2)) % 26) + 1, 1))
            DECLARE @t3 AS CHAR(1) = (SELECT(CAST((FLOOR(@RAND*(9-1+1)+1)) AS CHAR)))
            DECLARE @t4 AS CHAR(1) = (SELECT(CAST((FLOOR(@RAND*(9-1+1)+1)) AS CHAR)))
            DECLARE @t5 AS CHAR(1) = (SELECT(CAST((FLOOR(@RAND*(9-1+1)+1)) AS CHAR)))
            DECLARE @t6 AS CHAR(1) = (SELECT(CAST((FLOOR(@RAND*(9-1+1)+1)) AS CHAR)))
            SET @random_title_id = (SELECT @t1 + @t2 + @t3 + @t4 + @t5 + @t6)
            
            IF EXISTS(SELECT TOP 1 1 FROM [titles] WHERE title_id = @random_title_id)
                BEGIN
                    CONTINUE
                END
            ELSE 
                BEGIN
                    SET @isFound = 1
                END
        END
    RETURN @random_title_id
END;
```

<br/>



### II. Borrowing and returning a book operation on the database

<br/>

For each borrowed book copy, the library keeps track of the `copy id` and the `card number` of the person who borrowed it. The library keeps track of the `date on which it was borrowed` and records the due date which is **two weeks** after the borrow date. When the copy is returned this record is **updated** with the `return date` .
When a book copy is borrowed, the copy is marked as `BORROWED` . When the book copy is returned the copy is marked as `AVAILABLE` or `NOT BORROWED` .
A borrower can’t borrow a book from a particular branch unless that branch has a copy of that book and it is **currently in stock** (e.g. not being borrowed by someone else)
When a borrower returns a book copy **after the due date** the system calculates the `amount owed` and any overdue charge incurred is added to the `card balance` .
A borrower can not use a card to borrow books, if he owes **more than 10 dollars** on that card.
The library has a list of overdue charges. The charges are currently **.05** each day for **juvenile** books and **.10** per day for adult books. When a book is returned **late** the borrower pays charges that are in effect at the time the book is returned.
Any reading item that is categorized as `reference` may **not** be borrowed.

Stored procedure for **borrowing** operation

```sql
/*

    Rules for borrowing a book:
    - Any reading item that is categorized as reference may not be borrowed.
    - Copies that are in POOR condition may not be borrowed.
    - When a book copy is borrowed, the copy is marked as BORROWED. BORROWED copies may not be borrowed.
    - A borrower can not use a card to borrow books, if he owes more than 10 dollars on that card.

*/

CREATE PROCEDURE [dbo].[USP_BorrowBook] 
    @copy_id AS INT,
    @card_id AS INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            --#region Check if copy is of type Reference
                IF EXISTS(
                    SELECT TOP 1 1 
                    FROM titlecategory tc
                    JOIN bookcopies bc ON bc.title_id = tc.title_id
                    WHERE bc.copy_id = @copy_id AND tc.title_type_id = (SELECT type_id FROM category c WHERE c.[type] = 'Reference')
                )
                    BEGIN
                        ;THROW 50001, 'Copy of type Reference can not be borrowed', 1 
                    END
            --#endregion
            --#region Check if copy is in POOR 
                IF EXISTS (
                    SELECT copy_id
                    FROM bookcopies 
                    WHERE condition = 'POOR' AND copy_id = @copy_id
                )
                    BEGIN
                        ;THROW 50002, 'Copies in POOR condition can not be borrowed', 1  
                    END
            --#endregion
            --#region Check if copy is BORROWED or Discarded
                IF EXISTS (
                    SELECT copy_id
                    FROM bookcopies 
                    WHERE (isactive = 0 OR isavailable = 0) AND copy_id = @copy_id
                )
                    BEGIN
                        ;THROW 50003, 'Copies that are Discarded or already Borrowed can not be borrowed.', 1  
                    END
            --#endregion
            --#region Check if borrower is available to borrow a book
                IF EXISTS (
                    SELECT * 
                    FROM borrowers 
                    WHERE card_id = @card_id AND (isexpired = 1 OR balancedue >= 10)
                )
                    BEGIN
                        ;THROW 50004, 'Either borrowers card expired or borrower owes over 10 dollars.', 1
                    END
            --#endregion
            UPDATE bookcopies SET isavailable = 0 WHERE copy_id = @copy_id
            DECLARE @id INT = (SELECT MAX(id) + 1 FROM books_borrowed)
            INSERT INTO books_borrowed 
            VALUES 
            (
                ISNULL(@id,1),
                @copy_id,
                @card_id,
                GETDATE(),
                GETDATE() + 14,
                0,
                NULL
            )
            PRINT('Book Has Been Sucessfully Borrowed')
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END
```

Stored procedure for **returning** operation
<br/> 

```sql
CREATE PROCEDURE [dbo].[USP_ReturnBook]
    @card_id INT,
    @copy_id INT
AS 
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            --#region Check borrowed book exists
            IF NOT EXISTS(SELECT TOP 1 1 FROM books_borrowed WHERE card_id = @card_id AND copy_id = @copy_id AND isReturned = 0)
            BEGIN
		;THROW 50001, 'There is no borrowed book with the given details.', 1 
            END
            --#endregion
            DECLARE @id INT = (SELECT id FROM books_borrowed WHERE card_id = @card_id AND copy_id = @copy_id AND isReturned = 0)
            DECLARE @daysElapsed INT = (SELECT DATEDIFF(DD,borroweddate,GETDATE()) FROM books_borrowed WHERE id = @id)
            --PRINT(CAST(@daysElapsed as varchar))

            -- Set book available to borrow
            UPDATE bookcopies SET isavailable = 1 WHERE copy_id = @copy_id
            -- Set isReturned to true
            UPDATE books_borrowed SET isReturned = 1, returndate = GETDATE() WHERE id = @id
            
            DECLARE @pr DECIMAL(6,2)
            IF(@daysElapsed > 14)
                BEGIN 
                    DECLARE @typeId INT = (SELECT tc.title_type_id FROM bookcopies bc JOIN titlecategory tc ON tc.title_id = bc.title_id WHERE copy_id = @copy_id)
                    -- Check if Juvenile
                    IF(@typeId = 4)
                        BEGIN 
                            SET @pr = .05
                        END 
                    ELSE 
                        BEGIN
                            SET @pr = .10 
                        END
                    --Update card balancedue 
                    UPDATE borrowers SET balancedue = balancedue + (@pr * @daysElapsed) WHERE card_id = @card_id
                END
            
            PRINT('Book Has Been Sucessfully Returned')
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END
```

Stored procedure for listing all **available books** to borrow
<br/> 

```sql
CREATE PROCEDURE [dbo].[USP_GetAllAvailableBooks]
AS 
BEGIN 
    SELECT *
    FROM bookcopies bc
    JOIN titles t ON t.title_id = bc.title_id
    JOIN titlecategory tc ON tc.title_id = bc.title_id
    JOIN category c ON c.type_id = tc.title_type_id
    WHERE bc.isactive = 1 AND isavailable = 1 AND c.type <> 'Reference'  
END
```
<br/>

### III. Discarding books on the database

<br/>

The Library assigns a `Condition` to each book copy. Sample condition values could be `NEW` , `EXCELLENT` , `GOOD` , `WORN` and `POOR`. Eventually copies that are in `POOR` condition will be discarded and replaced with new copies.
A borrower can acknowledge that he has lost a copy of a book. If so, the copy is marked `LOST` and the book’s cost is added to the card balance. Eventually the copy may be removed from the current inventory of branch copies and stored in a history file.

Added CHECK CONSTRAINT on `Bookcopies` table for the condition column

```sql
ALTER TABLE [dbo].[bookcopies]  WITH CHECK ADD  CONSTRAINT [CK__bookcopie__condi__09746778] 
CHECK(([condition]='NEW' OR [condition]='EXCELLENT' OR [condition]='GOOD' OR [condition]='WORN' OR [condition]='POOR' OR [condition]='LOST'))
```

Stored procedure for discarding book in `POOR` condition 

```sql
CREATE PROCEDURE [dbo].[USP_DiscardBook]
    @copy_id INT
AS 
BEGIN 
    -- Check if copy_id is valid
    IF NOT EXISTS(SELECT TOP 1 1 FROM bookcopies WHERE copy_id = @copy_id)
        BEGIN 
	    ;THROW 50001, 'Book copy with provided ID does not exist.', 1 
        END 

    -- Check if book is returned
    IF EXISTS(SELECT TOP 1 1 FROM bookcopies WHERE copy_id = @copy_id AND isavailable = 0)
        BEGIN 
	    ;THROW 50002, 'Book copy with provided ID has not been returned.', 1 
        END 

    -- Check if book has not been discarded
    IF EXISTS(SELECT TOP 1 1 FROM bookcopies WHERE copy_id = @copy_id AND isactive = 0)
        BEGIN 
	    ;THROW 50003, 'Book copy with provided ID has been already discarded.', 1 
	    
        END  

    UPDATE bookcopies SET isavailable = 0, isactive = 0, condition = 'POOR' WHERE copy_id = @copy_id  
END
```

Stored procedure for discarding a `LOST` book

```sql
CREATE PROCEDURE [dbo].[USP_DiscardLostBook] 
    @copy_id AS INT,
    @card_id AS INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            --#region Check borrowed book exists
            IF NOT EXISTS(SELECT TOP 1 1 FROM books_borrowed WHERE card_id = @card_id AND copy_id = @copy_id AND isReturned = 0)
            BEGIN
		;THROW 50001, 'There is no borrowed book with the given details.', 1 
		
            END
            --#endregion
            DECLARE @id INT = (SELECT id FROM books_borrowed WHERE card_id = @card_id AND copy_id = @copy_id AND isReturned = 0)
            DECLARE @daysElapsed INT = (SELECT DATEDIFF(DD,borroweddate,GETDATE()) FROM books_borrowed WHERE id = @id)
            
            -- Set isReturned to true
            UPDATE books_borrowed SET isReturned = 1, returndate = GETDATE() WHERE id = @id
            -- Set condition to LOST
            UPDATE bookcopies SET condition = 'LOST',isavailable = 0, isactive = 0 WHERE copy_id = @copy_id
            DECLARE @i INT = (SELECT MAX(id) + 1 FROM bookcopy_history)
            --Insert note to book history table
            INSERT INTO bookcopy_history 
            VALUES
            (
                ISNULL(@i,1),
                @copy_id,
                'Book with id:' + @copy_id + ' has been lost by user with cardid: ' + @card_id,
                GETDATE()
            )
            
            DECLARE @pr DECIMAL(6,2)
            IF(@daysElapsed > 14)
                BEGIN 
                    DECLARE @typeId INT = (SELECT tc.title_type_id FROM bookcopies bc JOIN titlecategory tc ON tc.title_id = bc.title_id WHERE copy_id = @copy_id)
                    -- Check if Juvenile
                    IF(@typeId = 4)
                        BEGIN 
                            SET @pr = .05
                        END 
                    ELSE 
                        BEGIN
                            SET @pr = .10 
                        END
                    --Update card balancedue 
                    UPDATE borrowers SET balancedue = balancedue + (@pr * @daysElapsed) WHERE card_id = @card_id
                END
        
            PRINT('Book Has Been Sucessfully discarded as LOST.')
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

### IV. Employee restrictions on the database

<br/>

There are several branches within this lending library system. For each branch store the `branch id` , `name` , `address` , `telephone number` , `fax number` , `head librarian` . A branch might employ several librarians, but **only one head librarian**. For each librarian, store the `employee id` , `name` , `address` , `telephone number` , `salary` and `cell phone number` . A librarian may be assigned to **only one** branch. Branches have different types of employees. Some types are : `Librarian` , `Network Administrator` , `Computer Programmer` , `IT Manager` , `Floor Manager` , `Custodian` , `Accountant` , `Data Analyst` . 
Librarians **must have earned** a degree in library science. 
For each employee, the library maintains `name` , `address` , `phone number` , `birthdate` , `hire date` and `type of employee` . 
For librarians, the library also maintains **when the librarian earned his/her degree** and **the school at which the librarian earned the degree**
The Library supports two types of PayTypes: `salaried` and `hourly` . Employees that are salaried earn a yearly salary that is paid in **12 payments on the first of each month**. Employees that are clerical, earn **an hourly wage**. 
All employees get `vacation time` depending on their **length of service**. The minimum amount of vacation time is **two weeks**.
The library maintains a **log of how many hours each clerical type of employee logged during each week that he worked**. This log is used to produce `paychecks` for **clerical staff** at the end of each week.
Librarians earn between **20000 and 70000** per year. Pay rate for hourly workers must be at least **15.00**. A librarian can’t be hired before he has earned a **MS in Library Science** degree.

Trigger for ensuring restrictions on `Employees` table

```sql
CREATE TRIGGER [dbo].[CheckEmployees] 
ON [dbo].[employees]
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @branchId INT = (SELECT branch_id FROM inserted)
    DECLARE @isHead BIT = (SELECT ishead_librarian FROM inserted)
    DECLARE @empTypeId INT = (SELECT employee_type_id FROM inserted)
    DECLARE @salaryType CHAR(1) = (SELECT salary_type FROM inserted)
    DECLARE @salary DECIMAL(6,0) = (SELECT salary FROM inserted)
    DECLARE @degreeid INT = (SELECT degree_id FROM inserted)
    -- phone can be used as unique identifier
    DECLARE @phone VARCHAR(12) = (SELECT cellphone FROM inserted)

    
    IF(@isHead = 1)
    BEGIN 
        -- Check if head librarian exists for the branch
        IF EXISTS(SELECT TOP 1 1 FROM employees WHERE branch_id = @branchId AND ishead_librarian = 1)
        BEGIN
            RAISERROR('There is already a head librarian on this branch', 10, 1)
            ROLLBACK
        END

        -- Check if employee is of type librarian
        IF(@empTypeId <> 1)
            BEGIN
                RAISERROR('Only librarians can be head librarian', 10, 1)
                ROLLBACK
            END
    END
    
    -- Check if librarian exists
    IF EXISTS(SELECT TOP 1 1 FROM employees WHERE cellphone = @phone AND isActive = 1)
        BEGIN
            RAISERROR('Employee is already assigned to', 10, 1)
            ROLLBACK
        END

    -- Check if librarian exists
    IF(@salaryType = 'C' AND @salary < 15)
        BEGIN
            RAISERROR('Minimum hourly pay for clerical employees must be greater than 15 dollars.', 10, 1)
            ROLLBACK
        END
    
    IF(@empTypeId = 1 AND (@salary < 20000 OR @salary > 70000))
        BEGIN
            RAISERROR('Salary for librarians must be between 20000 and 70000', 10, 1)
            ROLLBACK
        END
    
    IF(@empTypeId = 1 AND @degreeid <> 2)
        BEGIN
            RAISERROR('Librarian must have earned MS degree in Library Sciences.', 10, 1)
            ROLLBACK
        END

    PRINT('Employee has been sucessfully added.')
END

GO
ALTER TABLE [dbo].[employees] ENABLE TRIGGER [CheckEmployees]

```
<br/>

Stored procedure for updating yearly employee `Vacation Hours`

```sql
CREATE PROCEDURE [dbo].[USP_UpdateEmployeeVacationHours]
AS 
BEGIN 
    UPDATE employees 
    SET vacation_hours = CASE 
                            WHEN DATEDIFF(YY,hiredate,GETDATE()) BETWEEN 0 AND 5 THEN 114
                            WHEN DATEDIFF(YY,hiredate,GETDATE()) BETWEEN 5 AND 10 THEN 154
                            ELSE 200
                         END
    FROM employees
END
```

<br/>


<div> <h2 align="center">Library Queries</h2></div>

<br/>

### Query 1

List the title of the book that is the most popular book to be borrowed. (Namely, it has been borrowed most often number of times )

<br/>

```sql
SELECT   t.title
        ,COUNT(id) AS [Borrowed Count]
FROM books_borrowed bb 
JOIN bookcopies bc ON bc.copy_id = bb.copy_id
JOIN titles t ON t.title_id = bc.title_id
GROUP BY t.title
HAVING COUNT(id) >= ALL
(
    SELECT COUNT(id) AS [Borrowed Count]
    FROM books_borrowed bb 
    JOIN bookcopies bc ON bc.copy_id = bb.copy_id
    JOIN titles t ON t.title_id = bc.title_id
    GROUP BY t.title
)
```

Borrowed books with total count 

```sql
SELECT   t.title
        ,COUNT(id) AS [Borrowed Count]
FROM books_borrowed bb 
JOIN bookcopies bc ON bc.copy_id = bb.copy_id
JOIN titles t ON t.title_id = bc.title_id
GROUP BY t.title
ORDER BY [Borrowed Count] DESC
```

<br/>

### Query 2

Which librarian has the third highest salary at the current time?

<br/>

```sql
SELECT * 
FROM
( 
    SELECT   e.employee_id
            ,first_name + ' ' + last_name AS [Full Name]
            ,salary
            ,ROW_NUMBER() OVER(ORDER BY salary DESC) AS RowNo
    FROM employees e 
    WHERE isActive = 1 AND e.employee_type_id = 
                                                (
                                                    SELECT et.id 
                                                    FROM employee_type  et
                                                    WHERE [type] = 'Librarian'
                                                )
) subQ
WHERE subQ.RowNo = 3
```

<br/>

### Query 3

For each employee, list his/her name and the name of the branch for which he/she is currently working and how many employees are working for that branch.

<br/>

```sql
SELECT   e.employee_id
        ,e.first_name + ' ' + e.last_name AS [Fullname]
        ,b.name
        ,COUNT(e.employee_id) OVER (PARTITION BY b.branch_id) AS [Branch Employee Count]
FROM employees e 
JOIN branchs b ON e.branch_id = b.branch_id
ORDER BY [Branch Employee Count] DESC
```

<br/>

### Query 4

For each book, list the title and publisher of the book and the number of copies currently stocked for this title in each branch, regardless of whether it is currently on loan.

<br/>

```sql
SELECT   t.title
        ,t.title_id
        ,p.pub_name
        ,bc.branch_id
        ,COUNT(bc.title_id) AS [Copy Count]
FROM titles t 
JOIN publishers p ON t.pub_id = p.pub_id
JOIN bookcopies bc ON bc.title_id = t.title_id
GROUP BY t.title
        ,t.title_id
        ,p.pub_name
        ,bc.branch_id
```

<br/>


### Query 5

For each quarter of the current year, for each branch list the total amount of books that have been borrowed in that quarter. 
The first quarter is months Jan, Feb, Mar. The second quarter is months Apr, May, June etc. 
List the amounts for each of these quarters, on the same row.

<br/>

```sql
SELECT  b.name
        ,(
            SELECT COUNT(bb.copy_id) AS [Total]
            FROM bookcopies bc 
            JOIN books_borrowed bb ON bb.copy_id = bc.copy_id
            WHERE MONTH(bb.borroweddate) IN (1,2,3) AND b.branch_id = bc.branch_id
        ) AS [Count Of First Quarter]
        ,(
            SELECT COUNT(bb.copy_id) AS [Total]
            FROM bookcopies bc 
            JOIN books_borrowed bb ON bb.copy_id = bc.copy_id
            WHERE MONTH(bb.borroweddate) IN (4,5,6) AND b.branch_id = bc.branch_id
        ) AS [Count Of Second Quarter]
        ,(
            SELECT COUNT(bb.copy_id) AS [Total]
            FROM bookcopies bc 
            JOIN books_borrowed bb ON bb.copy_id = bc.copy_id
            WHERE MONTH(bb.borroweddate) IN (7,8,9) AND b.branch_id = bc.branch_id
        ) AS [Count Of Third Quarter]
        ,(
            SELECT COUNT(bb.copy_id) AS [Total]
            FROM bookcopies bc 
            JOIN books_borrowed bb ON bb.copy_id = bc.copy_id
            WHERE MONTH(bb.borroweddate) IN (10,11,12) AND b.branch_id = bc.branch_id
        ) AS [Count Of Fourth Quarter]
FROM branchs b
```

<br/>


### Query 6

For each card, list the name of the borrower and the name of the books he currently has borrowed on the card, that have not yet been returned

<br/>

```sql
SELECT   b.first_name + ' ' + b.last_name AS [Borrower Fullname]
        ,t.title
FROM borrowers b 
JOIN books_borrowed bb ON b.card_id = bb.card_id
JOIN bookcopies bc ON bc.copy_id = bb.copy_id
JOIN titles t ON t.title_id = bc.title_id
WHERE bb.isReturned = 0
ORDER BY [Borrower Fullname]
```

<br/>


### Query 7

For each card, list the name of the borrower and on the same row the quantity of books that have been borrowed in 2020 and the quantity of books that have been borrowed in 2021 with that card.

<br/>

```sql
SELECT   b.first_name + ' ' + b.last_name AS [Borrower Fullname]
        ,(
            SELECT COUNT(bb.id)
            FROM books_borrowed bb 
            WHERE YEAR(bb.borroweddate) = 2020 AND b.card_id = bb.card_id
        ) AS [Borrowed2020]
        ,(
            SELECT COUNT(bb.id)
            FROM books_borrowed bb 
            WHERE YEAR(bb.borroweddate) = 2021 AND b.card_id = bb.card_id
        ) AS [Borrowed2021]
        ,(
            SELECT COUNT(bb.id)
            FROM books_borrowed bb 
            WHERE YEAR(bb.borroweddate) = 2022 AND b.card_id = bb.card_id
        ) AS [Borrowed2022]
FROM borrowers b 
```

<br/>


### Query 8

For a specific card, list which other cards borrowed ALL the same books as was borrowed using this card. (divide query). 
You choose the card you will be matching.

<br/>

```sql
SELECT AllBooks.card_id
FROM 
(
    SELECT DISTINCT  bb.card_id
                    ,title
    FROM books_borrowed bb 
    JOIN bookcopies bc ON bc.copy_id = bb.copy_id
    JOIN titles t ON t.title_id = bc.title_id
) AS AllBooks
JOIN 
(
    SELECT DISTINCT  bb.card_id
                    ,title
    FROM books_borrowed bb 
    JOIN bookcopies bc ON bc.copy_id = bb.copy_id
    JOIN titles t ON t.title_id = bc.title_id
    WHERE bb.card_id = 2
) AS Card1Books ON Card1Books.title = AllBooks.title
GROUP BY AllBooks.card_id
HAVING COUNT(AllBooks.title) =  (
                                    SELECT COUNT(title)
                                    FROM books_borrowed bb 
                                    JOIN bookcopies bc ON bc.copy_id = bb.copy_id
                                    JOIN titles t ON t.title_id = bc.title_id
                                    WHERE bb.card_id = 2
                                )
```

<br/>


### Query 9

List the name of the employee that has been working for the library the longest amount of time

<br/>

```sql
SELECT   e.first_name + ' ' + e.last_name AS [Employee Fullname]
        ,e.hiredate
        ,DATEDIFF(YY,e.hiredate,GETDATE()) AS [Years of Employment]
FROM employees e
WHERE e.hiredate = (SELECT MIN(hiredate) FROM employees)
```

<br/>


### Query 10

For each book, list the title and branch that it is in, if it isn’t currently on loan

<br/>

```sql
SELECT   t.title
        ,b.name
FROM titles t 
JOIN bookcopies bc ON t.title_id = bc.title_id
LEFT JOIN books_borrowed bb ON bb.copy_id = bc.copy_id
JOIN branchs b ON b.branch_id = bc.branch_id
WHERE bc.isactive = 1 AND isavailable = 1
```

<br/>


### Query 11

List the names of borrowers and the card id that they have if it hasn’t expired.

<br/>

```sql
SELECT   b.first_name + ' ' + b.last_name AS [Borrower]
        ,b.card_id
FROM borrowers b 
WHERE isexpired = 0
```

<br/>


### Query 12

For each author, list his name and the titles of the books he has written

<br/>

```sql
SELECT DISTINCT  a.au_fname + ' ' + a.au_lname AS [Author]
                ,t.title
FROM authors a 
JOIN titleauthor ta On ta.au_id = a.au_id
JOIN titles t ON t.title_id = ta.title_id
```

<br/>


### Query 13

For each author, list his name and the name of categories of books he has written

<br/>

```sql
SELECT DISTINCT  a.au_fname + ' ' + a.au_lname AS [Author]
                ,c.[type]
FROM authors a 
JOIN titleauthor ta On ta.au_id = a.au_id
JOIN titles t ON t.title_id = ta.title_id
JOIN titlecategory tc ON tc.title_id = t.title_id
JOIN category c ON c.type_id = tc.title_type_id
```

<br/>


### Query 14

For each employee, calculate the amount of money he should have earned this year based on his logged hours.

<br/>

```sql
SELECT  subQ.employee_id
       ,subQ.[Hours Total] * e.salary
FROM 
(
    SELECT  e.employee_id
           ,SUM(sl.[hours]) AS [Hours Total]
    FROM employees e 
    JOIN shift_logs sl ON e.employee_id = sl.employee_id
    WHERE YEAR(sl.shiftdate) = YEAR(GETDATE()) AND e.salary_type = 'C'
    GROUP BY e.employee_id
) subQ
JOIN employees e ON e.employee_id = subQ.employee_id
```

<br/>


### Query 15

List the title of books that have never been borrowed.

<br/>

```sql
SELECT t.title
FROM titles t
WHERE t.title_id NOT IN 
(
    SELECT DISTINCT t.title_id
    FROM borrowers b 
    JOIN books_borrowed bb ON b.card_id = bb.card_id
    JOIN bookcopies bc ON bc.copy_id = bb.copy_id
    JOIN titles t ON t.title_id = bc.title_id
)
```

<br/>


### Query 16

For each branch, list the total quantity of books, total quantity by category, total quantity by author

<br/>

```sql
SELECT b.name
,(
    SELECT COUNT(bc.copy_id)
    FROM bookcopies bc 
    WHERE bc.branch_id = b.branch_id
) AS [Book Count]
,(
    SELECT COUNT(DISTINCT tc.title_type_id)
    FROM bookcopies bc 
    JOIN titles t ON t.title_id = bc.title_id
    JOIN titlecategory tc ON tc.title_id = t.title_id
    WHERE bc.branch_id = b.branch_id
) AS [Category Count]
,(
    SELECT COUNT(DISTINCT ta.au_id)
    FROM bookcopies bc 
    JOIN titles t ON t.title_id = bc.title_id
    JOIN titleauthor ta On t.title_id = ta.title_id
    WHERE bc.branch_id = b.branch_id
) AS [Category Count]
FROM branchs b 
```

<br/>

### Query 17

For each card, list the name of the cardholder, list the category of books and each book that was borrowed on this card. 
In the same query list to the how many books have been borrowed for each category, and how many books have been borrowed in total with this card.

<br/>

```sql
WITH CTE 
AS
(
    SELECT   b.first_name + ' ' + b.last_name AS [Borrower]
            ,t.title
            ,c.[type]
    FROM borrowers b 
    JOIN books_borrowed bb ON b.card_id = bb.card_id
    JOIN bookcopies bc ON bc.copy_id = bb.copy_id
    JOIN titles t ON t.title_id = bc.title_id
    JOIN titlecategory tc ON tc.title_id = t.title_id
    JOIN category c ON c.type_id = tc.title_type_id
)
SELECT   Borrower
        ,title
        ,[type]
        ,COUNT(c.title) OVER (PARTITION BY Borrower,TYPE) AS [Category Count]
        ,COUNT(c.title) [Total Books Borrowed]
FROM CTE c
GROUP BY Borrower
        ,title
        ,[type]
ORDER BY [Borrower]
```

<br/>


### Query 18

On one row, list the how many employees are currently employed for each type of employee.

<br/>

```sql
SELECT   et.[type]
        ,COUNT(e.employee_id) AS [Employee Count]
FROM employees e 
JOIN employee_type et ON e.employee_type_id = et.id
WHERE e.isActive = 1
GROUP BY et.[type]
ORDER BY [Employee Count] DESC 
```

<br/>

### Query 19

What is the name of the borrower, who has currently borrowed the most books.

<br/>

```sql
SELECT b.first_name + ' ' + b.last_name AS [Borrower]
FROM borrowers b  
JOIN books_borrowed bb ON bb.card_id = b.card_id
GROUP BY b.first_name + ' ' + b.last_name
HAVING COUNT(bb.copy_id) >= ALL
(
    SELECT COUNT(copy_id)
    FROM books_borrowed
    GROUP BY card_id
) 
```

<br/>


### Query 20

List the names of borrowers who have borrowed both book A and book B (you can choose the specific book titles).

<br/>

```sql
SELECT DISTINCT b.first_name + ' ' + b.last_name AS [Borrower]
FROM titles t 
JOIN bookcopies bc ON t.title_id = bc.title_id
JOIN books_borrowed bb ON bb.copy_id = bc.copy_id
JOIN borrowers b ON b.card_id = bb.card_id
WHERE t.title_id = 'UX2157'
INTERSECT
SELECT DISTINCT b.first_name + ' ' + b.last_name AS [Borrower]
FROM titles t 
JOIN bookcopies bc ON t.title_id = bc.title_id
JOIN books_borrowed bb ON bb.copy_id = bc.copy_id
JOIN borrowers b ON b.card_id = bb.card_id
WHERE t.title_id = 'BR5671'
```

<br/>



<!-- Resources -->
## Resources

<p>Link for the entire Pubs DB scripts file:<a href="https://github.com/amanmadov/msin616-final-project/blob/main/db-scripts/pubs-db-script-20220425.sql.sql" target="_blank"> View File</a></p>
<p>Link for the entire Pubs DB bak file:<a href="https://github.com/amanmadov/msin616-final-project/blob/main/db-scripts/pubs-2022425.bak" target="_blank"> View File</a></p>
<p>Simple Front End UI App for the Pubs Database <a href="https://amanmadov.github.io/msin616-final-project/">View App</a></p>
<br/>




<!-- CONTACT -->
## Contact

Nury Amanmadov - [@amanmadov](https://twitter.com/amanmadov) - amanmadov@gmail.com

Project Link: [https://github.com/amanmadov/msin616-final-project](https://github.com/amanmadov/msin616-final-project)

<p align="right">(<a href="#top">back to top</a>)</p>

