--[[ 
---------------------------------------------------------------------------------------
This script will POST a JSON request to a specific URL

NOTE: You need to set the following values in the startup lua (Apps / Develop Apps / Edit Startup Lua)
   JSON_URL = The http URL to POST the JSON object to (ex. http://google.com/json_receiver.php)

Usage Syntax: 
   buildAndSendJsonRequest( { a table with keys/values pairs to be POSTED } )
   
---------------------------------------------------------------------------------------
Example Usage:
---------------------------------------------------------------------------------------
     require("CustomScript_json")

     local variableTable = {}
     variableTable["Device1"] = "SmartSwitch"
     variableTable["Device2"] = "Thermostat"

     buildAndSendJsonRequest(variableTable)
---------------------------------------------------------------------------------------
]]--

-- ================ --
-- PUBLIC VARIABLES --
-- ================ --
local http = require("socket.http")
local ltn12 = require("ltn12")

-- ================ --
-- PUBLIC FUNCTIONS --
-- ================ --
function buildAndSendJsonRequest(variableTable)

	--local payload = [[ {"key":"My Key","name":"My Name","description":"The description","state":1} ]]
	local payload = ""
	
	for key,value in pairs(variableTable) do 
	
		if payload == "" then
			payload = key .. "===".. value
		else
			payload = payload .. "|||".. key .. "===".. value
		end
    end
	
	--payload = payload .. "}} ]]"
	
	luup.log("JSON REQUEST: "..payload)
	
	--Send the payload
	sendJSONRequest(payload)

end

function sendJSONRequest(jsonRequest)
	local payload = jsonRequest
	local response_body = { }

	luup.log(" SENDING JSON ")
	local res, code, response_headers, status = http.request
	{
		url = JSON_URL,
		method = "POST",
		headers =
		{
			["Authorization"] = "Maybe you need an Authorization header?", 
			["Content-Type"] = "application/json",
			["Content-Length"] = payload:len()
		},
		source = ltn12.source.string(payload),
		sink = ltn12.sink.table(response_body)
	}
	--luup.task('Response: = ' .. table.concat(response_body) .. ' code = ' .. code .. '   status = ' .. status,1,'Sample POST request with JSON data',-1)
	luup.log(" SENDING JSON COMPLETED ")
	
end