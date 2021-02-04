create table books_j
(book_id     varchar2(32) not null primary key,
 book_data   blob
 constraint books_j_check CHECK (book_data IS JSON));
