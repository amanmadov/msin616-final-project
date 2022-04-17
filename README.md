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


## Modifications on the Database

Some columns like prequel_id on the Titles table have been added to store the prequel of a book.
<br/>
Using prequel books recursive queries can be written and executed on the Titles table.
<br/>
Some famous book series like "A Game of Thrones", "Harry Potter" and "The Lord of The Rings" are added to the Titles table.
<br/>
Some famous author and publisher records are added to related tables.
<br/>
Stored procedures are created for the demo Book CRM CRUD app.


  
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

