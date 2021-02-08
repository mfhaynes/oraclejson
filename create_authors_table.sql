create table authors_j 
(author_id          varchar2(32) not null primary key, 
 author_data        blob
 constraint authors_j_check_json CHECK (author_data IS JSON WITH UNIQUE KEYS))
 LOB (author_data) STORE AS (CACHE);

insert into authors_j 
select sys_guid(), '{"Name":"'||books.book_data.author||'", "BirthDate":"'||to_char(trunc(sysdate)-7300-(rownum*23),'YYYY.MM.DD')||'"}' 
from books_j books;
