# DDL specs, second half

# has struct info
create table Has_Struct_Info
  (MaterialID char(9) not null,
   StructID   char(9) not null);

# phase diagram
create table Phase_Diagram
  (MaterialID            char(9) not null,
   PhaseDiagram          blob not null,
   PublicationYear       integer,
   DiagramType           varchar(30),
   ConcentrationRange    varchar(50),
   Temperature           varchar(20),
   NatureOfInvestigation varchar(20),
   DetailsID             char(9),
   primary key(MaterialID));

# diagram details
create table Diagram_Details
  (MaterialID      char(9) not null,
   APDICDiagram    tinyint(1),
   UniqueID        char(9) not null,
   Title           varchar(50),
   Publication     varchar(50),
   Language        varchar(20),
   OriginalDiagram varchar(50),
   OriginalScope   varchar(50),
   OriginalSize    varchar(10),
   Remarks         varchar(50),
   primary key(MaterialID));

# Has_Auth
create table Has_Auth
  (DiagID     char(9) not null,
   AuthID     char(9) not null);

# Diagram_Authors
create table Diagram_Authors
  (AuthID      char(9) not null,
   Author      varchar(30),
   Affiliation varchar(40),
   primary key(AuthorID));

