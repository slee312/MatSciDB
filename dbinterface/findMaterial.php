<?php
	ini_set('display_errors', 'On');

	$has_results = false;

	// mysqli object (different way of connecting)
	$mysqli = new mysqli("dbase.cs.jhu.edu","cs41513_slee312","abcdefg","cs41513_slee312_db");

	if(isset($_POST['material_id']) || isset($_POST['chem_formula'])) {
		$has_results = true;

		$material_id = mysql_escape_string($_POST['material_id']);
		$chem_formula = mysql_escape_string($_POST['chem_formula']);

		// define query
		$SQL = "SELECT * FROM Material";

		if (isset($_POST['gen_info'])) {
			$SQL .= " NATURAL JOIN General_Info";
		}

		if (isset($_POST['space_group_info'])) {
			$SQL .= " NATURAL JOIN Space_Group_Info";
		}

		if (isset($_POST['struct_info'])) {
			$SQL .= " NATURAL JOIN Has_Struct_Info NATURAL JOIN Structure_Info";
		}

		if (isset($_POST['lattice_params'])) {
			$SQL .= " NATURAL JOIN Lattice_Parameters";
		}

		if ($material_id != "") {
			$SQL .= " WHERE Material.MaterialID = '" . $material_id . "'";
			if ($chem_formula != "") {
				$SQL .= " AND Material.ChemicalFormula = '" . $chem_formula . "'";
			}
		} else if ($chem_formula != "") {
			$SQL .= " WHERE Material.ChemicalFormula = '" . $chem_formula . "'";
		}


		// exec query
		$result = mysqli_query($mysqli, $SQL);

	}

	
?>

<html>

<head>
	<title>
		Materials Science DB
	</title>
	<link rel="stylesheet" type="text/css" href="./foundation/css/foundation.min.css">
	<style>
		.inline-table {
			display: inline-block;
			margin: 10px 10px 10px 10px;
		}
	</style>
</head>
<body>
<form method="post">
	<fieldset>
		<div class = "row">
			<div class = "large-12 columns">
				<h1>Retrieval Interface for the MatSci DB</h1>
			</div>
		</div>

	<div class = "row">
		<div class = "large-6 columns">
			<label>By Material ID:</label>
			<input type="text" name="material_id" value ="<?php if (isset($_POST['material_id'])) { echo $_POST['material_id']; } ?>" />
		</div>
		<div class = "large-6 columns">
			<label>By Chemical Formula:</label>
			<input type="text" name="chem_formula" value ="<?php if (isset($_POST['chem_formula'])) { echo $_POST['chem_formula']; } ?>" />
		</div>
	</div>
	
	<div class = "row">
	
		<div class = "large-3 columns">
			<input type = "checkbox" name = "gen_info" id = "gen_info" <?php if (isset($_POST['gen_info'])) { echo "checked "; } ?>/>
			<label for = "gen_info" >General Info</label>
		</div>

		<div class = "large-3 columns">
			<input type = "checkbox" name = "space_group_info" id = "space_group_info" <?php if (isset($_POST['space_group_info'])) { echo "checked "; } ?>/>
			<label for = "space_group_info" >Space Group Info</label>
		</div>

		<div class = "large-3 columns">
			<input type = "checkbox" name = "struct_info" id = "struct_info" <?php if (isset($_POST['struct_info'])) { echo "checked "; } ?>/>
			<label for = "struct_info" >Structural Info</label>
		</div>

		<div class = "large-3 columns">
			<input type = "checkbox" name = "lattice_params" id = "lattice_params" <?php if (isset($_POST['lattice_params'])) { echo "checked "; } ?>/>
			<label for = "lattice_params" >Lattice Paramaters</label>
		</div>


	</div>

	<div class = "row">
		<div class = "large-12 columns">
			<input type = "submit" value = "Search" class = "button" />
		</div>
	</div>

	</form>

	</fieldset>
	
	<?php
	if ($has_results) {
	?>
	<div class = "row">
		<div class = "large-12 columns">
			<h2>Search Results</h2>
			<h3>SQL Query: (<?php echo $SQL; ?>)</h3>
		</div>
	</div>
	<br />
	<div class = "row"><div class = "large-12 columns">
	<?php

		// indicate query success
		if ($result->num_rows > 0) {
			while ($row = mysqli_fetch_assoc($result))
			{
				echo "<table class = \"inline-table\">";

				echo "<th colspan = \"2\"> Material ID: " . $row["MaterialID"] . "</th>";
				
				foreach ($row as $key => $val) {
					if (!(strpos($key,"ID") !== false)) {
						echo "<tr><td>" . $key . "</td><td>" . $val . "</td></tr>";
					}
				}
				echo "</table>";
			}
		} else {
			echo "<div class = \"row\"><div class = \"large-12 columns\"><h4>No results for the query.</h4></div></div>";
		}

	}

	// close connection
	mysqli_close($mysqli);

	?>
	</div></div>
</body>
</html>





