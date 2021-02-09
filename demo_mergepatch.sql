col inventory_amt for a15
set lines 210
set pages 50
col title for a30
select json_value(book_data,'$.title') as title, json_value(book_data,'$.inventoryamount') as inventory_amt
from books_j where json_value(book_data,'$.inventoryamount' returning number) > 100;
update books_j
set book_data = json_mergepatch(book_data,'{"inventoryamount":100}')
where json_value(book_data,'$.inventoryamount' returning number) > 100;
select json_value(book_data,'$.title') as title, json_value(book_data,'$.inventoryamount') as inventory_amt
from books_j where json_value(book_data,'$.inventoryamount' returning number) > 100;
select books.book_data.inventoryamount from books_j books where books.book_data.title = 'Vwlab sb Deuqg';
