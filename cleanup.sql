drop type degree_t;
drop table books_j;
create table books_j as select book_id, book_data from books_save;
alter table books_j add constraint books_j_ck CHECK (book_data IS JSON);
