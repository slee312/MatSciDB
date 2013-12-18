import java.io.*;

import org.json.JSONObject;
import org.json.JSONTokener;

import matsci.io.structure.CIF;
import matsci.location.Vector;

public class GetData {

	public static void main(String args[]) throws Exception {
		
		int idGetter = 1000;
		String runtype;
		
		System.out.printf("Using API Key: %s\n", args[0]);
		File file = new File("output.sql");
		File cif = new File("struct.cif");
		
		FileWriter fwriter, cifwriter;
		BufferedWriter bwriter, bcif;
		
		try {
			fwriter = new FileWriter(file.getAbsoluteFile());
			bwriter= new BufferedWriter(fwriter);
		} catch (Exception e) {
			throw new Exception("Couldn't get file.");
		}
		
		MatProjectAPI getInfo;
		for (int i = 1; i < idGetter; i++) {
			
			cifwriter = new FileWriter(cif.getAbsoluteFile());
			bcif = new BufferedWriter(cifwriter);

			getInfo = new MatProjectAPI(args[0], i);
			JSONObject data;
			InputStreamReader reader;
			
			try {
				reader = getInfo.getInfo();
				JSONTokener rd = new JSONTokener(reader);
				data = new JSONObject(rd);
			} catch (IOException e) {
				  System.err.println("ID invalid, incrementing ID value and resending...");
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
			
			int numStructInfos = material.getInt("nsites");
			//writes out CIF file for structural info
			bcif.write(material.getString("cif"));
			bcif.close();
			
			CIF struct = new CIF("struct.cif");
			// Note: there are multiple Structure_Info and Has_Struct_Info insertions
			for (int j = 0; j < numStructInfos; j++) {
			
				String structID = materialID + "-" + j;
				
				// Has_Struct_Info
				input = String.format("INSERT INTO Has_Struct_Info (MaterialID, StructID) VALUES('%s', '%s');\n\n", materialID, structID);
							
				bwriter.write(input);						
				
				double[] coords = struct.getSiteCoords(j).getArrayCopy();
				// Structure_Info
				input = String.format("INSERT INTO Structure_Info (StructID, Element, FracCoordsA, FracCoordsB, FracCoordsC, " +
						"Coordination) VALUES('%s', '%s', '%s', '%s', '%s', '%s');\n\n", structID, struct.getSiteSpecies(j,0).getElementSymbol(),
						coords[0],coords[1],coords[2],struct.getSiteOccupancy(j,0));
				
				bwriter.write(input);
				
			}
			Vector a = struct.getConventionalVectors()[0];
			Vector b = struct.getConventionalVectors()[1];
			Vector c = struct.getConventionalVectors()[2];
			// Lattice_Parameters, replace with greek letters once outside eclipse
			input = String.format("INSERT INTO Lattice_Parameters (MaterialID, a, b, c, alpha, beta, gamma) " +
					"VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", materialID, a.length(),b.length(),c.length(),
					a.angleDegrees(b),b.angleDegrees(c),c.angleDegrees(a));
			
			bwriter.write(input);
			
			JSONObject symmetry = material.getJSONObject("spacegroup");
			
			// Space_Group_Info
			input = String.format("INSERT INTO Space_Group_Info (MaterialID, CrystalSystem, Num, Hall, PointGroup) " +
					"VALUES('%s', '%s', '%s', '%s', '%s');\n\n", materialID, symmetry.getString("crystal_system"),
					symmetry.getInt("number"),symmetry.getString("hall"),symmetry.getString("point_group"));
			
			
			bwriter.write(input);
			
			// Material
			input = String.format("INSERT INTO Material (MaterialID, ChemicalFormula, SpaceGroup, BandGap, GenInfoID, SpaceGroupInfoID, " +
					"StructInfoID, LatticeID, PhaseDiagID) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');\n\n", materialID,
					material.getString("pretty_formula"),symmetry.getString("symbol"),material.getDouble("band_gap"),
					materialID,materialID,materialID,materialID,materialID);
			
			bwriter.write(input);
		}
		
		bwriter.close();
		
		System.out.println("Done.");
	}
	
}
