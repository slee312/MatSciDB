#Material							
#MaterialID	ChemicalFormula	SpaceGroup	BandGap (eV)	GenInfoID	SpaceGroupInfoID	LatticeID	PhaseDiagID
#mp-609465	Fe2O3		P3		0		mp-609465	mp-609465		mp-609465	mp-609465

CREATE TABLE Material
(MaterialID VARCHAR(30) NOT NULL,
ChemicalFormula VARCHAR(30),
SpaceGroup VARCHAR(10),
BandGap FLOAT(15),
GenInfoID VARCHAR(30),
SpaceGr=oupInfoID VARCHAR(30),
LatticeID VARCHAR(30),
PhaseDiagID VARCHAR(30),
PRIMARY KEY (MaterialID),
FOREIGN KEY (GenInfoID)
	REFERENCES General_Info
	ON DELETE CASCADE,
FOREIGN KEY (SpaceGroupInfoID)
	REFERENCES Space_Grooup_Info
	ON DELETE CASCADE,
FOREIGN KEY (StructInfoID)
	REFERENCES Structure_Info
	ON DELETE CASCADE,
FOREIGN KEY (PhaseDiagID)
	REFERENCES Phase_Diagram
	ON DELETE CASCADE
);

#General_Info								
#MaterialID	UnitCellFormula	FormationEnergyPAtom (eV)	Energy above hull (eV)	Decomposes to	FinalMagneticMoment (μ_B)	CellVolume (Å^3)	Density (g/cm^3)	RunType
#mp-609465	Fe12O18		-1.2948				0.5366			Fe2O3		38				378.94			4.2	 		GGA+U

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

CREATE TABLE Has_Struct_Info
(MaterialID VARCHAR(30) NOT NULL,
StructID INTEGER NOT NULL,
PRIMARY KEY (MaterialID, StructID)
);

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

