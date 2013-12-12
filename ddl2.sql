#Lattice_Parameters						
#MaterialID	a(Å)	b(Å)	c(Å)	α(°)	β(°)	γ(°)
#mp-609465	5.379	5.379	15.125	90	90	120

create table Lattice_Parameters
  (MaterialID char(9) not null,
   a(Å)       float(20),
   b(Å)       float(20),
   c(Å)       float(20),
   α(°)       integer,
   β(°)       integer,
   γ(°)       integer);

#Phase_Diagram							
#MaterialID	PhaseDiagram	PublicationYear	DiagramType		ConcentrationRange			Temperature	NatureOfInvestigation	DetailsID
#mp-609465	aHR0cDovL3d3dy5	1991		binary phase diagram	full decomposition; 0-100 at. % Au	950 to 1070 °C	calculated		mp-609465

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

#Diagram_Details									
#MaterialID	APDICDiagram	UniqueID	Title		Publication	Language	OriginalDiagram	OriginalScope				OriginalSize	Remarks
#mp-609465	No		904518		Au-Cu alloy	Kexue Tongbao	Engl. Transl.	English		T[947-1067 °C] vs. Au conc.[0-100 at.%]	36/59	

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

#Has_Auth	
#DiagID		AuthID
#mp-609465	609203

create table Has_Auth
  (DiagID     char(9) not null,
   AuthID     char(9) not null);

#Diagram_Authors		
#AuthID	Author		Affiliation
#609203	Zheng W.T.	Jilin University, Department of Materials Science

create table Diagram_Authors
  (AuthID      char(9) not null,
   Author      varchar(30),
   Affiliation varchar(40),
   primary key(AuthorID));

