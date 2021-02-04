import json
import random
import string
import uuid
import cx_Oracle
import os
import getpass

id = os.getenv('DBID')
pw = getpass.getpass()
db = os.getenv('DBConnectString')

con = cx_Oracle.connect(id,pw,db)
cur = con.cursor()
sql = 'insert into books_j values (sys_guid(), utl_raw.cast_to_raw(:1))'

row_count = 0

while row_count < 10000:
    row_count = row_count + 1
    location = random.choice(string.ascii_uppercase)+random.choice(string.ascii_uppercase)+str(random.randint(0,9))
    title = random.choice(string.ascii_uppercase) + ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(3,10))) + ' ' \
            + ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(2,3))) + ' ' + random.choice(string.ascii_uppercase) \
            + ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(4,8)))
    author = random.choice(string.ascii_uppercase) + ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(1,6))) + ' ' \
            + random.choice(string.ascii_uppercase) + ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(2,11)))
    cost = random.randint(99,7499)/100
    quantity_on_hand = max(0,round(random.normalvariate(15,25)))
    description = ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(75,300)))
    book = {'location': location, 'title': title, 'author': author, 'cost': cost, 'description': description, 'inventoryamount': quantity_on_hand}
    topics = []
    while random.randint(0,10) < 7:
        topics += [random.choice(string.ascii_uppercase) + ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(3,12)))]
    if len(topics) > 0:
        book['topics'] = topics
    if random.randint(0,100) < 25:
        book['artist'] = random.choice(string.ascii_uppercase) + ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(1,6))) + ' ' \
                       + random.choice(string.ascii_uppercase) + ''.join(random.choice(string.ascii_lowercase) for i in range (random.randint(2,11)))
    if random.randint(0,100) < 88:
        book['pagecount'] = max(48,round(random.normalvariate(451,212)))
    book_json = json.dumps(book)
    cur.execute(sql, [book_json])

con.commit()
con.close()
