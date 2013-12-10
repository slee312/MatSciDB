CREATE TABLE Material
(MaterialID VARCHAR(30) NOT NULL,
ChemicalFormula VARCHAR(30),
SpaceGroup VARCHAR(10),
FormulationEnergy FLOAT(15),
EAboveHull FLOAT(15),
BandGap FLOAT(15),
GenInfoID VARCHAR(30),
SpaceGroupInfoID VARCHAR(30),
StructInfoID VARCHAR(30),
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
)
