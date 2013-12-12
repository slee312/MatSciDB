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

CREATE TABLE Space_Group_Info
(MaterialID VARCHAR(30) NOT NULL,
CrystalSystem VARCHAR(30),
Num INTEGER,
Hall VARCHAR(20),
PointGroup INTEGER,
PRIMARY KEY (MaterialID)
);

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

CREATE TABLE Has_Struct_Info
(MaterialID VARCHAR(30) NOT NULL,
StructID INTEGER NOT NULL,
PRIMARY KEY (MaterialID, StructID)
);
