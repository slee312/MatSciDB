package project.kpoints;

import java.io.*;

import matsci.io.structure.CIF;
import matsci.location.Vector;

public class GetData {

	public static void main(String args[]) {
		
		int idGetter = 1000;
		String runtype;
		
		try {
		
		System.out.printf("Using API Key: %s\n", args[0]);
		File file = new File("output.sql");
		File cif = new File("struct.cif");
		
		if (file.exists()) {
			throw new Exception("Delete old file first.");
		} else {
			try {
				file.createNewFile();
			} catch (Exception e) {
				throw new Exception ("Couldn't create file");
			}
		}
		
		FileWriter fwriter, cifwriter;
		BufferedWriter bwriter, bcif;
		
		try {
			fwriter = new FileWriter(file.getAbsoluteFile());
			cifwriter = new FileWriter(cif.getAbsoluteFile());
			bwriter= new BufferedWriter(fwriter);
			bcif = new BufferedWriter(cifwriter);
		} catch (Exception e) {
			throw new Exception("Couldn't get file.");
		}
		
		MatProjectAPI getInfo;
		for (int i = 0; i < idGetter; i++) {
			
			getInfo = new MatProjectAPI(args[0], i);
			JSONObject data = getInfo.getInfo();
			if (data.getBoolean("valid_response") == false) {
				idGetter++;
				continue;
			}
			
			JSONObject material = data.getJSONArray("response").getJSONObject(0);
			
			String materialID = "mp-" + i;
			if (material.getBoolean("is_compatible"))
				runtype = "GGA";
			else
				runtype = "LDA";
			
			// General_Info
			String input = String.format("INSERT INTO General_Info (MaterialID, UnitCellFormula, FormationEnergyPAtom, EnergyAboveHull, FinalMagneticMoment, " +
					"CellVolume, Density, RunType) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", materialID, material.getJSONObject("unit_cell_formula").keys().next(),
					material.getDouble("energy"), material.getDouble("e_above_hull"),material.getDouble("total_magnetization"),material.getDouble("volume"),
					material.getDouble("density"), runtype);
			
			bwriter.write(input);
			
			int numStructInfos = material.getInt("nSites");
			//writes out CIF file for structural info
			bcif.write(material.getString("cif"));
			bcif.close();
			
			CIF struct = new CIF("struct.cif");
			// Note: there are multiple Structure_Info and Has_Struct_Info insertions
			for (int j = 0; j < numStructInfos; j++) {
			
				String structID = materialID + "-" + j;
				
				// Structure_Info
				input = String.format("INSERT INTO Has_Struct_Info (MaterialID, StructID) VALUES('%s', '%s');\n\n", materialID, structID);
							
				bwriter.write(input);						
				
				double[] coords = struct.getSiteCoords(j).getArrayCopy();
				// Has_Struct_Info
				input = String.format("INSERT INTO General_Info (StructID, Element, FracCoordsA, FracCoordsB, FracCoordsC, " +
						"Coordination) VALUES('%s', '%s', '%s', '%s', '%s', '%s');\n\n", structID, struct.getSiteSpecies(i,0),
						coords[0],coords[1],coords[2],struct.getSiteOccupancy(j,0));
				
				bwriter.write(input);
				
			}
			Vector a = struct.getConventionalVectors()[0];
			Vector b = struct.getConventionalVectors()[1];
			Vector c = struct.getConventionalVectors()[2];
			// Lattice_Paramters, replace with greek letters once outside eclipse
			input = String.format("INSERT INTO Lattice_Paramters (MaterialID, a, b, c, α, β, γ) " +
					"VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", materialID, a.length(),b.length(),c.length(),
					a.angleDegrees(b),b.angleDegrees(c),c.angleDegrees(a));
			
			bwriter.write(input);
			
			JSONObject symmetry = data.getJSONObject("spacegroup");
			
			// Space_Group_Info
			input = String.format("INSERT INTO Space_Group_Info (MaterialID, CrystalSystem, Num, Hall, PointGroup) " +
					"VALUES('%s', '%s', '%s', '%s', '%s');\n\n", materialID, symmetry.getString("crystal_system"),
					symmetry.getInt("number"),symmetry.getString("hall"),symmetry.getString("point_group"));
			
			
			bwriter.write(input);
			
			// Material
			input = String.format("INSERT INTO Material (MaterialID, ChemicalFormula, SpaceGroup, BandGap, GenInfoID, SpaceGroupInfoID, " +
					"StructInfoID, LatticeID, PhaseDiagID) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", materialID,
					material.getString("pretty_formula"),symmetry.getString("Symbol"),material.getDouble("band_gap"),
					materialID,materialID,materialID,materialID,materialID);
			
			bwriter.write(input);
			//this gets thermo data; however I can't find some of the necessary info in the response...
			data = getInfo.getThermo(material.getString("pretty_formula"));
			if (data.getBoolean("valid_response") == false) {
				continue;
			}
			material = data.getJSONArray("response").getJSONObject(0);
			
			// Diagram_Details
			input = String.format("INSERT INTO Diagram_Details (MaterialID, PhaseDiagram, PublicationYear, DiagramType, ConcentrationRange, Temperature,"
					+ "NatureOfInvestigation, DetailsID) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", "","","","",
					"","","","");
			// Phase_Diagram
			input = String.format("INSERT INTO Diagram_Details (MaterialID, Title, Publication, Language, OriginalDiagram, " +
					"OriginalScope, OriginalSize, Remarks) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", "","","","",
					"","","","");
		}
		
		bwriter.close();
		
		System.out.println("Done.");
		
		} catch (Exception e) {
			System.err.println("Error occcured: " + e.getMessage());
		}
	}
	
}
