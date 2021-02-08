set autotrace on
pause Query based on location
select books.book_data.title from books_j books where books.book_data.location = 'CB4';

pause Create Location INDEX
create index books_location_idx 
on books_j (json_value(book_data, '$.location' ERROR ON ERROR NULL ON EMPTY));

pause Re-Query Based on location
select books.book_data.title from books_j books where books.book_data.location = 'CB4';

pause Note still hitting table
pause Build new index with location and title
create index books_location_title_idx 
on books_j (json_value(book_data, '$.location' RETURNING VARCHAR2(3) ERROR ON ERROR NULL ON EMPTY),
            json_value(book_data, '$.title' ERROR ON ERROR NULL ON EMPTY));
pause Note needing to specify VARCHAR2 length to avoid key being too long.

select books.book_data.title from books_j books where books.book_data.location = 'CB4';
pause New Index Gets Use but STILL hitting table...

pause Use syntax from Index DDL in Query	
select json_value(book_data, '$.title' ERROR ON ERROR NULL ON EMPTY) from books_j books where books.book_data.location = 'CB4'			
pause No longer hits table.

pause Search Indexes allow full-text word searching (also supports Dataguide)
CREATE SEARCH INDEX books_search_idx ON books_j (book_data) FOR JSON PARAMETERS ('DATAGUIDE ON');   

pause Query with Search Index
select json_query(book_data,'$') as book_info from books_j where json_textcontains(book_data, '$', 'Jan');
