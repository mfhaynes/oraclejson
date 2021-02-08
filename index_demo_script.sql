set pause on
set autotrace on
REM Query based on location
select books.book_data.title from books_j books where books.book_data.location = 'CB4';

REM Create Location INDEX
create index books_location_idx 
on books_j (json_value(book_data, '$.location' ERROR ON ERROR NULL ON EMPTY));

REM Re-Query Based on location
REM Note still hitting table
select books.book_data.title from books_j books where books.book_data.location = 'CB4';

REM Build new index with location and title
REM Note needing to specify VARCHAR2 length to avoid key being too long.
create index books_location_title_idx 
on books_j (json_value(book_data, '$.location' RETURNING VARCHAR2(3) ERROR ON ERROR NULL ON EMPTY),
            json_value(book_data, '$.title' ERROR ON ERROR NULL ON EMPTY));

REM New Index Gets Used	
REM Note STILL hitting table...
select books.book_data.title from books_j books where books.book_data.location = 'CB4';

REM Use syntax from Index DDL in Query
REM No longer hits table.	
select json_value(book_data, '$.title' ERROR ON ERROR NULL ON EMPTY) from books_j books where books.book_data.location = 'CB4'			

REM Search Indexes allow full-text word searching (also supports Dataguide)
CREATE SEARCH INDEX books_search_idx ON books_j (book_data) FOR JSON PARAMETERS ('DATAGUIDE ON');   

REM Query with Search Index
select json_query(book_data,'$') as book_info from books_j where json_textcontains(book_data, '$', 'Jan');
