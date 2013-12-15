import java.io.*;

public class GetData {

	public static void main(String args[]) {
		
		try {
		
		System.out.printf("Using API Key: %s\n", args[0]);
		File file = new File("output.sql");
		
		if (file.exists()) {
			throw new Exception("Delete old file first.");
		} else {
			try {
				file.createNewFile();
			} catch (Exception e) {
				throw new Exception ("Couldn't create file");
			}
		}
		
		FileWriter fwriter;
		BufferedWriter bwriter;
		
		try {
			fwriter = new FileWriter(file.getAbsoluteFile());
			bwriter= new BufferedWriter(fwriter);
		} catch (Exception e) {
			throw new Exception("Couldn't get file.");
		}
		
		MatProjectAPI getInfo;
		for (int i = 0; i < 1000; i++) {
			getInfo = new MatProjectAPI(args[0], i);
			JSONObject data = getInfo.getInfo();
			
			String materialID = "mp-" + i;
			
			// General_Info
			String input = String.format("INSERT INTO General_Info (MaterialID, UnitCellFormula, FormationEnergyPAtom, EnergyAboveHull, DecomposesTo, FinalMagneticMoment, " +
					"CellVolume, Density, RunType) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", materialID, "","","","","","","","");
			
			bwriter.write(input);
			
			int numStructInfos = ???????????????????;
			
			// Note: there are multiple Structure_Info and Has_Struct_Info insertions
			for (int j = 0; j < numStructInfos; j++) {
			
				String structID = materialID + "-" + j;
				
				// Structure_Info
				input = String.format("INSERT INTO Has_Struct_Info (MaterialID, StructID) VALUES('%s', '%s');\n\n", materialID, structID);
							
				bwriter.write(input);						
				
				// Has_Struct_Info
				input = String.format("INSERT INTO General_Info (StructID, Element, BondValenceOxidationState, FracCoordsA, FracCoordsB, FracCoordsC, " +
						"Coordination) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", structID, "","","","","","");
				
				bwriter.write(input);
				
			}
			
			// Lattice_Paramters
			input = String.format("INSERT INTO Lattice_Paramters (MaterialID, a, b, c, α, β, γ) " +
					"VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", materialID, "","","","","","");
			
			bwriter.write(input);
						
			// Space_Group_Info
			input = String.format("INSERT INTO Space_Group_Info (MaterialID, CrystalSystem, Num, Hall, PointGroup) " +
					"VALUES('%s', '%s', '%s', '%s', '%s');\n\n", materialID, "","","","");
			
			
			bwriter.write(input);
			
			// Material
			input = String.format("INSERT INTO Material (MaterialID, ChemicalFormula, SpaceGroup, BandGap, GenInfoID, SpaceGroupInfoID, " +
					"StructInfoID, LatticeID, PhaseDiagID) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", materialID, "","","","","","","","");
			
			bwriter.write(input);
			
			
		}
		
		bwriter.close();
		
		System.out.println("Done.");
		
		} catch (Exception e) {
			System.err.println("Error occcured: " + e.getMessage());
		}
	}
	
}
