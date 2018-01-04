-- ================ --
-- PUBLIC VARIABLES --
-- ================ --

-- ================ --
-- PUBLIC FUNCTIONS --
-- ================ --
function pushover(request)
  luup.log("=======================================================================")
  luup.log("                         PUSHOVER REQUEST                              ")
  luup.log("=======================================================================")
  
  local http = require("socket.http")
  local pushoverUrl = "https://api.pushover.net/1/messages.json"
  http.TIMEOUT = 5
  
  -- Build the POST string
  local data_str = {}
  table.insert(data_str,"token=" .. tostring(PUSHOVER_APP_KEY))
  table.insert(data_str,"user=" .. tostring(PUSHOVER_USER_KEY))
  for k,v in pairs(request) do
    table.insert(data_str, tostring(k) .. "=" .. tostring(v))
  end
  data_str = table.concat(data_str, "&")
  
  -- For Debugging
  luup.log("VARIABLE VALUES")
  luup.log("token: " .. tostring(PUSHOVER_APP_KEY))
  luup.log("user: " .. tostring(PUSHOVER_USER_KEY))
  for k,v in pairs(request) do
    luup.log(tostring(k) .. ": " .. tostring(v))
  end
  luup.log("============================================================")
  luup.log("Data Sent to PushOver: " .. data_str)
  luup.log("============================================================")
  
  -- Send the request and collect the result
  local res, code, headers, status = http.request(pushoverUrl,data_str)
  
  -- Check for errors
  if (code ~= 200) then
    local errstr = "Error while sending request. Status code: " .. tostring(code) .. ", Body: " .. tostring(res)
    return false, errstr
  else 
    return true, "OK"
  end
  
  luup.log("=======================================================================")
  luup.log("                      PUSHOVER REQUEST (DONE)                          ")
  luup.log("=======================================================================")
  luup.log("                                                                       ")
end

function logPushoverResponse(success, err)
  luup.log("=======================================================================")
  luup.log("                          PUSHOVER RESPONSE                            ")
  luup.log("=======================================================================")
  luup.log("VARIABLE VALUES")
  luup.log("success: " .. tostring(success))
  luup.log("err:" .. tostring(err))
  if (success) then
    luup.log("Hells yeah! The push was sent successfully.")
  else
    luup.log("Awe snap! The push failed with error: " .. err)
  end
  luup.log("=======================================================================")
  luup.log("                      PUSHOVER RESPONSE (DONE)                         ")
  luup.log("=======================================================================")
  luup.log("                                                                       ")
end
