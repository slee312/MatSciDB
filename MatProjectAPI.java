/*@author Kyle McGill
 *
 *This class makes use of the open source, freely available
 *JSON interpreter from JSON.org by Douglas Crockford
 */
import java.io.*;
import java.net.*;

import javax.net.ssl.HttpsURLConnection;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

/********************NOTES*****************************
API key generation needed; look into writing a API key request method?

URI format for MatProjAPI: 

API key must be given as GET variable (GET {URI}?API_KEY=[the api key]
or a x-api-key header ('X-API-KEY': 'your key' (recommended))

https://www.materialsproject.org/rest/v1/
{request_type}[/{identifier}][/{parameters}]

For "materials" = {request_type}:

https://www.materialsproject.org/rest/v1/materials/
{material id, formula, or chemical system}/vasp/{property}

{property}-> Includes: energy(_per_atom), structure, icsd_id, band_gap.

***********************************************/


public class MatProjectAPI {

  public static void main(String args[]) throws IOException, JSONException {
	  //Sets up connection parameters
    String API_KEY = args[0];
    int param = Integer.parseInt(args[1]);
    MatProjectAPI test = null;
    System.setProperty ("jsse.enableSNIExtension", "false");
    try {    
      test = new MatProjectAPI(API_KEY, param);
    } catch (URISyntaxException e) {
      System.out.println("Incorrect syntax: " + e.getMessage());
    }
    System.out.println(test.getURL().toString());
    
    //Retrieves the JSON output and writes it to a file
        
  }
  URI requestURI;
  URL requestURL;
  String key;

  String base = "https://www.materialsproject.org/rest/v1/materials/";

  public MatProjectAPI(String key, int param) throws URISyntaxException, UnsupportedEncodingException {
	String URI = base + "mp-" + param + "/vasp?API_KEY=" + key;
    requestURI = new URI(URI);
    this.key = key;
  }
  public URL getURL() throws MalformedURLException {
    return requestURI.toURL(); 
  }
  //open the connection to the specified URL and parse into a JSONObject
  public InputStreamReader getInfo() throws MalformedURLException, IOException, JSONException {
	  
	  HttpsURLConnection connection = (HttpsURLConnection) getURL().openConnection();
	  connection.setRequestMethod("GET");
	  connection.setDoInput(true);
	  connection.connect();
	  InputStreamReader rd = new InputStreamReader(connection.getInputStream());
	  
	  return rd;
  }
 
}
