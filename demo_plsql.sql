col total_cost for 999,999,999,999.99
select sum(books.book_data.cost) total_cost from books_j books where books.book_data.cost >= 70;
select sum(books.book_data.cost) total_cost from books_j books;

DECLARE
    book_json            json_object_t;
    book_json_string     varchar2(4000);
BEGIN
    FOR book_record IN (SELECT books.book_id, books.book_data FROM books_j books WHERE books.book_data.cost >= 70)
    LOOP
        book_json := json_object_t(book_record.book_data);
        book_json.put('cost', round(book_json.get_Number('cost')*.9,2));    
        book_json_string := book_json.stringify;
        UPDATE books_j SET book_data = book_json_string WHERE book_id = book_record.book_id;
    END LOOP;
END;
/

select sum(books.book_data.cost) total_cost from books_j books where books.book_data.cost >= 63;
