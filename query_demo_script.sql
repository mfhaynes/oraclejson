set pause on
set echo on
set lines 200
set pages 50
col title for a30
col pagecount for a10
col topics for a30
REM Multiple Query Techniques
select books.book_data.title, books.book_data.pagecount,
       json_query(book_data,'$.topics[*]' returning varchar2 pretty with wrapper) topics
from books_j books where json_value(book_data,'$.pagecount' returning number) > 1250
order by books.book_data.pagecount;

REM Joining with a Relational Table
select books.book_data.title, books.book_data.author,
       json_query(book_data,'$.topics[*]' returning varchar2 pretty with wrapper) topics,
       topic_experts.expert, topic_experts.topic
from books_j books join topic_experts on books.book_data.author = topic_experts.expert;

col artist_name for a30
col birthdate for a9
col degreedata for a80 wrap
REM Using Conditionals in JSON_EXISTS similar to JSON_QUERY
select json_value(artist_data,'$.Name') as artist_name, 
       to_date(json_value(artist_data,'$.BirthDate'),'YYYY.MM.DD') as birthdate, 
       json_query(artist_data,'$.Education[*]' PRETTY WITH ARRAY WRAPPER) as degreedata
from artists_j
where json_exists(artist_data,'$.Education[*]?(@.DegreeDate > "2020.07.06")');
