#General_Info								
#MaterialID	UnitCellFormula	FormationEnergyPAtom (eV)	Energy above hull (eV)	Decomposes to	FinalMagneticMoment (μ_B)	CellVolume (Å^3)	Density (g/cm^3)	RunType
#mp-609465	Fe12O18		-1.2948				0.5366			Fe2O3		38				378.94			4.2	 		GGA+U

DROP TABLE IF EXISTS General_Info;
CREATE TABLE General_Info
(MaterialID VARCHAR(30) NOT NULL,
UnitCellFormula VARCHAR(20),
FormationEnergyPAtom FLOAT(20),
EnergyAboveHull FLOAT(20),
DecomposesTo VARCHAR(20),
FinalMagneticMoment FLOAT(20),
CellVolume FLOAT(20),
Density FLOAT(20),
RunType VARCHAR(30),
PRIMARY KEY (MaterialID)
);

#Space_Group_Info					
#MaterialID	CrystalSystem	Num		Hall	PointGroup
#mp-609465	trigonal	143		P3	3

DROP TABLE IF EXISTS Space_Group_Info;
CREATE TABLE Space_Group_Info
(MaterialID VARCHAR(30) NOT NULL,
CrystalSystem VARCHAR(30),
Num INTEGER,
Hall VARCHAR(20),
PointGroup INTEGER,
PRIMARY KEY (MaterialID)
);

#Structure_Info						
#StructID	Element	BondValenceOxidationState	FracCoordsA	FracCoordsB	FracCoordsC	Coordination
#2032		Fe	3				0.6575		0.624		0.2272		4

DROP TABLE IF EXISTS Structure_Info;
CREATE TABLE Structure_Info
(StructID INTEGER NOT NULL,
Element VARCHAR(20),
BondValenceOxidationState INTEGER,
FracCoordsA FLOAT(20),
FracCoordsB FLOAT(20),
FracCoordsC FLOAT(20),
Coordination INTEGER,
PRIMARY KEY (StructID)
);

#Has_Struct_Info	
#MaterialID	StructID
#mp-609465	2032

DROP TABLE IF EXISTS Has_Struct_Info;
CREATE TABLE Has_Struct_Info
(MaterialID VARCHAR(30) NOT NULL,
StructID INTEGER NOT NULL,
PRIMARY KEY (MaterialID, StructID)
);

#Lattice_Parameters						
#MaterialID	a(Å)	b(Å)	c(Å)	α(°)	β(°)	γ(°)
#mp-609465	5.379	5.379	15.125	90	90	120

drop table if exists Lattice_Parameters;
create table Lattice_Parameters
  (MaterialID char(9) not null,
   a       float(20),
   b       float(20),
   c       float(20),
   α       integer,
   β       integer,
   γ       integer,
   primary key(MaterialID));

#Phase_Diagram							
#MaterialID	PhaseDiagram	PublicationYear	DiagramType		ConcentrationRange			Temperature	NatureOfInvestigation	DetailsID
#mp-609465	aHR0cDovL3d3dy5	1991		binary phase diagram	full decomposition; 0-100 at. % Au	950 to 1070 °C	calculated		mp-609465

drop table if exists Phase_Diagram;
create table Phase_Diagram
  (MaterialID            varchar(30) not null,
   PhaseDiagram          blob not null,
   PublicationYear       integer,
   DiagramType           varchar(30),
   ConcentrationRange    varchar(30),
   Temperature           varchar(30),
   NatureOfInvestigation varchar(30),
   DetailsID             varchar(30),
   primary key(MaterialID),
   foreign key(DetailsID)
      references Diagram_Details
      on delete cascade);

#Diagram_Details									
#MaterialID	APDICDiagram	UniqueID	Title		Publication	Language	OriginalDiagram	OriginalScope				OriginalSize	Remarks
#mp-609465	No		904518		Au-Cu alloy	Kexue Tongbao	Engl. Transl.	English		T[947-1067 °C] vs. Au conc.[0-100 at.%]	36/59	

drop table if exists Diagram_Details;
create table Diagram_Details
  (MaterialID      varchar(30) not null,
   APDICDiagram    tinyint(1),
   UniqueID        varchar(30) not null,
   Title           varchar(30),
   Publication     varchar(30),
   Language        varchar(30),
   OriginalDiagram varchar(30),
   OriginalScope   varchar(30),
   OriginalSize    varchar(30),
   Remarks         varchar(30),
   primary key(MaterialID));

#Has_Auth	
#DiagID		AuthID
#mp-609465	609203

drop table if exists Has_Auth;
create table Has_Auth
  (DiagID     varchar(30) not null,
   AuthID     varchar(30) not null,
   primary key(DiagID, AuthID));

#Diagram_Authors		
#AuthID	Author		Affiliation
#609203	Zheng W.T.	Jilin University, Department of Materials Science

drop table if exists Diagram_Authors;
create table Diagram_Authors
  (AuthID      varchar(30) not null,
   Author      varchar(30),
   Affiliation varchar(30),
   primary key(AuthID));

#Material							
#MaterialID	ChemicalFormula	SpaceGroup	BandGap (eV)	GenInfoID	SpaceGroupInfoID	LatticeID	PhaseDiagID
#mp-609465	Fe2O3		P3		0		mp-609465	mp-609465		mp-609465	mp-609465

DROP TABLE IF EXISTS Material;
CREATE TABLE Material
(MaterialID VARCHAR(30) NOT NULL,
ChemicalFormula VARCHAR(30),
SpaceGroup VARCHAR(10),
BandGap FLOAT(15),
GenInfoID VARCHAR(30),
SpaceGroupInfoID VARCHAR(30),
StructInfoID VARCHAR(30),
LatticeID VARCHAR(30),
PhaseDiagID VARCHAR(30),
PRIMARY KEY (MaterialID),
FOREIGN KEY (GenInfoID)
	REFERENCES General_Info
	ON DELETE CASCADE,
FOREIGN KEY (SpaceGroupInfoID)
	REFERENCES Space_Group_Info
	ON DELETE CASCADE,
FOREIGN KEY (StructInfoID)
	REFERENCES Structure_Info
	ON DELETE CASCADE,
FOREIGN KEY (PhaseDiagID)
	REFERENCES Phase_Diagram
	ON DELETE CASCADE
);
