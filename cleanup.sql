drop table books_old;
alter table books_j rename to books_old;
alter table books_old drop constraint books_j_ck;
create table books_j as select book_id, book_data from books_old;
alter table books_j add constraint books_j_ck CHECK (book_data IS JSON);
drop index books_search_idx;
drop index books_location_idx;
drop index books_location_title_idx;
drop index books_location_vc_idx;