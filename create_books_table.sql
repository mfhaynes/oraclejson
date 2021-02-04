CREATE TABLE books_j
(book_id     varchar2(32) NOT NULL PRIMARY KEY,
 book_data   blob
 CONSTRAINT books_j_ck CHECK (book_data IS JSON))
 LOB (book_data) STORE AS (CACHE);
