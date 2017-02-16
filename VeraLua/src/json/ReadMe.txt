-----------------------------------------------------------------------------
	File: CustomScript_json.lua
	
	Author:  Andrew Stenzel
	
	Purpose:
		This script will POST a JSON request to a specific URL
		NOTE: You need to set the following values in the startup lua (Apps / Develop Apps / Edit Startup Lua)
			JSON_URL = The http URL to POST the JSON object to (ex. http://google.com/json_receiver.php)
		
	Usage Syntax: 
   		buildAndSendJsonRequest( { keyValuePairs } )
   		
   	Data Types:
   		keyValuePairs => table 
   					(containing key/values corresponding to be POSTED)
   		
   	Example:
		require("CustomScript_json")

		local variableTable = {}
		variableTable["Device1"] = "SmartSwitch"
		variableTable["Device2"] = "Thermostat"

		buildAndSendJsonRequest(variableTable)
		
-----------------------------------------------------------------------------