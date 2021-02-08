create table artists_j 
(artist_id          varchar2(32) not null primary key, 
 artist_data        blob
 constraint artists_j_check_json CHECK (artist_data IS JSON WITH UNIQUE KEYS))
 LOB (artist_data) STORE AS (CACHE);

insert into artists_j 
select sys_guid(), '{"Name":"'||books.book_data.artist||'", "BirthDate":"'||to_char(trunc(sysdate)-7300-(rownum*23),'YYYY.MM.DD')||'"}' 
from books_j books
where books.book_data.artist is NOT NULL;
