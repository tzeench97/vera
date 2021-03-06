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
  local res, code, response_headers, status = http.request {
        url = JSON_URL,
        method = "POST",
        headers = {
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