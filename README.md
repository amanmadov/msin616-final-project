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

Titles table have been altered and prequel_id column have been added to store the prequel of a book.
<br/>
Using prequel books recursive queries can be written and executed on the Titles table.
<br/>
Some famous book series like "A Game of Thrones", "Harry Potter" and "The Lord of The Rings" are added to the Titles table.
<br/>
Some famous author and publisher records are added to related tables.
<br/>
Some of the columns types are alse modified.
<br/>
Stored procedures are created for the demo Book CRUD app.
<br/>
Stored procedures for creating/modifying records are created based on the front-end validations.


<br/>
<br/>

## Created Custom Stored Procedures

1. For adding an Employee to the Employee table

<br/>

```sql
/*
    Created by Nury Amanmadov
    Date created: 11.04.2022
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

