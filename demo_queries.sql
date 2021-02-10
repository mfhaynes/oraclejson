set echo on
set lines 155
set pages 38
col title for a30
col pagecount for a10
col topics for a30
col first_topic for a30
col cost for a10
col author for a30
pause Returning single element from an array of scalars
select books.book_data.title, books.book_data.cost,
       json_value(book_data,'$.topics[0]') first_topic
from books_j books where json_value(book_data,'$.cost' returning number) = 74.50;

pause Returning single element from an array of objects with JSON_QUERY
select json_query(artist_data,'$.Education[0]') from artists_j where rownum = 1;

pause Returning single element from an array of objects as a custom data type
CREATE TYPE degree_t as OBJECT (institution varchar2(64), degree varchar2(64), degreedate varchar2(10))
/

select json_value(artist_data,'$.Education[0]' RETURNING degree_t) from artists_j where rownum = 1;

pause Multiple Query Techniques
select books.book_data.title, books.book_data.pagecount,
       json_query(book_data,'$.topics[*]' returning varchar2 pretty with wrapper) topics
from books_j books where json_value(book_data,'$.pagecount' returning number) > 1282
order by books.book_data.pagecount;

pause Joining with a Relational Table
select books.book_data.title, books.book_data.author,
       json_query(book_data,'$.topics[*]' returning varchar2 pretty with wrapper) topics,
       topic_experts.expert, topic_experts.topic
from books_j books join topic_experts on books.book_data.author = topic_experts.expert;

col artist_name for a30
col birthdate for a9
col degreedata for a80 wrap
pause Using Conditionals in JSON_EXISTS similar to JSON_QUERY
select json_value(artist_data,'$.Name') as artist_name, 
       to_date(json_value(artist_data,'$.BirthDate'),'YYYY.MM.DD') as birthdate, 
       json_query(artist_data,'$.Education[*]' PRETTY WITH ARRAY WRAPPER) as degreedata
from artists_j
where json_exists(artist_data,'$.Education[*]?(@.DegreeDate > "2020.07.06")');
