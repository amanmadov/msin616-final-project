<div id="top"></div>

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

This is the simple database designed using Microsoft's Pubs Database.
The Pubs database provides a set of fictional pieces of information about publishers, authors, titles and sales of books.
It is now considered obsolete; it is no longer provided with SQL Server since the 2008 version.
The tables and fields are quite obvious. 
They have names such as Authors, Titles, etc., which reflect their content. 
And the fields also have obvious names explaining what they contain.

<p>
  You can find the details about original Pubs DB in the link:
  <a href="https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs" target="_blank">Microsoft Pubs DB</a>
</p>

Below you can see the altered database diagram of the Pubs database

<br/>

![Database Schema Screen Shot](https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/db-schema.png)

<br/>

<p>
  Link for the database schema:<a href="https://drawsql.app/softttt/diagrams/msin616-pubs-db" target="_blank"> DB Schema</a>
</p>

<br/>


## Modifications on the Database

- [x] `[dbo].[TITLES]` table have been altered and prequel_id column have been added to store the prequel of a book.
- [x] Using prequel books recursive queries can be written and executed on the `[dbo].[TITLES]` table.
- [x] Some famous book series like "A Game of Thrones" or "The Lord of The Rings" are added to the `[dbo].[TITLES]` table.
- [x] Some famous author and publisher records are added to related tables.
- [x] Some of the column types are also modified.
- [x] Stored procedures are created for the demo Book CRUD app.
- [x] Front-end UI has custom validations to prevent data inconsistency.
- [x] All stored procedures for creating/modifying records are created based on the front-end validations.
- [x] Created `[Audit].[Book]` table to keep audit history of the created books.
- [x] Used `[Adventureworks].[Person].[Person]` and `[AdventureWorks].[HumanResources].[Employee]` tables to generated dummy data.


<br/>
<br/>

## Created Custom Stored Procedures and the Front-End UI of the Demo App

1. Inserting a Book into the `TITLES` table
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/create-book-ui.png">
<br/>

<p>Link for the front-end ui module:<a href="https://drawsql.app/softttt/diagrams/msin616-pubs-db" target="_blank"> VIEW</a></p>

<br/>

Stored Procedure for adding a Book into the `TITLES` table

<br/>

```sql

/*
    Created by Nury Amanmadov
    Date created: 10.04.2022
*/

ALTER PROCEDURE [dbo].[USP_InsertBook] 
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





1. Creating an Employee on the `Employee` table
<br/>
<img src="https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/create-employee-ui.png">
<br/>

SP for adding an Employee to the `Employee` table

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
    ,@emp_job_id AS INT = NULL
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
                
                -- Using jobs table we can get random job id if given @emp_job_id is null
                IF (@emp_job_id IS NULL)
                    SET @emp_job_id = (SELECT TOP 1 job_id FROM [pubs].[dbo].[jobs] j ORDER BY NEWID())
                
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
Front-end logic of the created stored procedure
<br/>

![Frontend UI](https://github.com/amanmadov/msin616-final-project/blob/main/custom-images/create-employee-ui.png)

<br/>





<br/>
<br/>
  <p align="center">
    Simple Front End UI App for the Pubs Database
    <br/> <br/>
    <a href="https://amanmadov.github.io/msin617-final-project/index.html">View Demo</a>
  </p>
</div>

















<!-- CONTACT -->
## Contact

Nury Amanmadov - [@amanmadov](https://twitter.com/amanmadov) - amanmadov@gmail.com

Project Link: [https://github.com/amanmadov/msin616-final-project](https://github.com/amanmadov/msin616-final-project)

<p align="right">(<a href="#top">back to top</a>)</p>

