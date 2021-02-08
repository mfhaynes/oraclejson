create table authors_j
(author_id          varchar2(32) not null primary key, 
 author_data        varchar2(4000) 
 constraint authors_j_check_json CHECK (author_data IS JSON));
 
insert into authors_j 
select sys_guid(), '{"name":"'||books.book_data.author||'", "birthdate":"'||to_char(trunc(sysdate)-7300-(rownum*23),'YYYY.MM.DD')||'"}' 
from books_j books;
