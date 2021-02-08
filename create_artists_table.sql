create table artists_j 
(artist_id          varchar2(32) not null primary key, 
 artist_data        blob
 constraint artists_j_check_json CHECK (artist_data IS JSON WITH UNIQUE KEYS))
 LOB (artist_data) STORE AS (CACHE);

insert into artists_j 
select sys_guid(), '{"Name":"'||books.book_data.author||'", "BirthDate":"'||to_char(trunc(sysdate)-10030-(rownum*2),'YYYY.MM.DD')||'", '||'"Education":['||
				   decode(mod(rownum,11),2,'{"Institution": "Columbus College of Art and Design", "Degree":"Bachelor of Fine Arts", "DegreeDate":"'||
				   to_char(trunc(sysdate)-1800-(rownum*2),'YYYY.MM.DD')||
				   '"}, ',3,'{"Institution": "Yale University", "Degree":"Bachelor of Fine Arts", "DegreeDate":"'||
				   to_char(trunc(sysdate)-1800-(rownum*2),'YYYY.MM.DD')||
				   '"}, ',7,'{"Institution": "New Mexico State University", "Degree":"Bachelor of Fine Arts", "DegreeDate":"'||
				   to_char(trunc(sysdate)-1800-(rownum*2),'YYYY.MM.DD')||
				   '"}, ',NULL)||
				   decode(mod(rownum,10),0,NULL,1,NULL,'{"Institution": "'||
				       decode(mod(rownum,3),0,'Columbus College of Art and Design',1,'Northern Arizona University',2,'Carleton College')||'", "Degree": "'||
					   decode(mod(rownum,11),2,'Master of Fine Arts',3,'Master of Fine Arts',7,'Master of Education','Bachelor of Fine Arts')||'", "DegreeDate":"'||
				   to_char(trunc(sysdate)-210-(rownum*2),'YYYY.MM.DD')||'"}, ')||
				   '{"Institution": "'||
				   decode(mod(rownum,20),0,'Defiance',1,'Hillsdale',2,'Prairie West',3,'Elm Creek',4,'St. Peter',5,'Independence',6,'Shay Valley Local',
				   7,'Tokyo Metropolitan Fuchu Nishi',8,'Western International',9,'Cass Technical',10,'East Mountain',11,'Sandia',12,'Grossmont Union',
				   13,'FDR',14,'Big Walnut',15,'Columbus South',16,'Bowling Green',17,'Notre-Dame International',18,'Fashman Yeshiva',19,'Chillicothe')||
				   ' High School", "Degree": "High School Diploma", "DegreeDate":"'||to_char(trunc(sysdate)-
				   decode(mod(rownum,11),2,3020,3,3350,7,4170,1680)-(rownum*2),'YYYY.MM.DD')||'"}'||
                   ']}' 
from books_j books where books.book_data.artist is NOT NULL;
