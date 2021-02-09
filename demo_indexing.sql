set lines 200
set autotrace on
set echo on
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
select json_value(book_data, '$.title' ERROR ON ERROR NULL ON EMPTY) from books_j books where books.book_data.location = 'CB4';			
pause No longer hits table.

pause Search Indexes allow full-text word searching (also supports Dataguide and virtual columns)
CREATE SEARCH INDEX books_search_idx ON books_j (book_data) FOR JSON PARAMETERS ('DATAGUIDE ON CHANGE add_vc');   
desc books_j

pause Query with Search Index
select json_query(book_data,'$') as book_info from books_j where json_textcontains(book_data, '$', 'Jan');

pause Create new multi-column index using Virtual COLUMNS
create index books_location_vc_idx on books_j ("BOOK_DATA$location", "BOOK_DATA$title");

pause Use new index
select "BOOK_DATA$title" from books_j where "BOOK_DATA$location" = 'CB4';

set autotrace off

pause Add new row with publisher info
insert into books_j (book_id, book_data)
values (sys_guid(),
        '{"location":"MH2","title":"Jbpfs iw Frlp","author":"Oufa Cnfel","cost":21.12,"description":"dsfhkjh","inventoryamount":3,"pagecount":129,"publisher":"Random Shed"}');
desc books_j

pause Commit and then re-describe table
commit;
desc books_j;
