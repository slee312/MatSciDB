#DDL specs, second half

#Has_Auth
create table Has_Auth
  (Diag_ID     char(9) not null,
   Auth_ID     char(9) not null,
   

#Diagram_Authors
create table Diagram_Authors
  (AuthID      char(9) not null,
   Author      varchar(30),
   Affiliation varchar(40),
   primary key(AuthorID));

