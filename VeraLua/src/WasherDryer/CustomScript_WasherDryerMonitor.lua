--- This module is for monitoring the clothes washer and dryer.
-- It will also send Pushover notifications as needed
-- NOTE: Decisions on sending notifications are set in the
--       NOTIFY_WHEN_xxx_STOPS_AND_xxx_xxx variables.
--       
-- NOTE 2: You will also want to change the following variables,
--      since each machine will be different:
--        DRYER_DEVICE_ID  - Defined in your startup Lua (Apps / Develop Apps / Edit Startup Lua)
--        WASHER_DEVICE_ID - Defined in your startup Lua (Apps / Develop Apps / Edit Startup Lua)
--        MAX_OFF_WATTAGE  - Defined below (might not always be zero as some devices pull some wattage when on, but not running; like for the LEDs/Lights)
--      
--    ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~      
-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
--  !!! REQUIRES THE 'CustomScript_pushover' SCRIPT TO WORK !!!
-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
--     ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
-- 
-- Example Usage:
--    require("CustomScript_WasherDryerMonitor")
--    clothesDryerEnded()
--    
-- ---------------------------------------------------------------
--  Something worth noting:
--   All log enteries are enter with the log level of 79.  This
--   is not a normal logging level, so if tailing the logs by
--   log level will not work.
--   
--   Either change this value to one found in your /etc/cmh/cmh.conf
--   or add the value to the /etc/cmh/cmh.conf and reboot your
--   vera device
--   
--   Tailing by logging level can be done using (which includes
--   sever log levels too, in case there are problems):
--      tail -f /tmp/log/cmh/LuaUPnP.log | grep '^79\|^01'     
-- ---------------------------------------------------------------
-- @author Andrew Stenzel
-- @module WasherDryerMonitor

require("CustomScript_pushover")

-- ---------------
-- Local variables
-- ---------------

-- The devices ID is found in the 'Advanced' page of the device
local MAX_OFF_WATTAGE = 4 -- The maximum wattage pull to be considered 'off'

local NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_STOPPED = true
local NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_RUNNING = false
local NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_STOPPED = true
local NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_RUNNING = true

local WASHER_AND_DRYER_COMPLETE = "The <b><font color='red'>washer</font></b> and <b><font color='red'>dryer</font></b> are complete"
local WASHER_ONLY_COMPLETE = "The <b><font color='red'>washer</font></b> is complete, but the <b><font color='red'>dryer</font></b> is still running"
local DRYER_ONLY_COMPLETE = "The <b><font color='red'>dryer</font></b> is complete, but the <b><font color='red'>washer</font></b> is still running"

local WASHER_AND_DRYER_COMPLETE_TITLE = "Clothes Washer & Dryer Ready"
local WASHER_ONLY_COMPLETE_TITLE = "Clothes Washer is Ready"
local DRYER_ONLY_COMPLETE_TITLE = "Clothes Dryer is Ready"

--- Is triggered when the <b>Clothes Washer</b> has <b>STOPPED</b> (Watts = 0).
function clothesWasherEnded()

  luup.log("The washer has stopped", 79)
  luup.log(string.format("Is the dryer running? %s", tostring(deviceIsRunning(DRYER_DEVICE_ID))),79)
  
  -- Check if the dryer is running
  if (deviceIsRunning(DRYER_DEVICE_ID)) then
    luup.log("Dryer is RUNNING",79)
    luup.log(string.format("Will a push notification be sent? %s", tostring(NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_RUNNING)),79)
    pushNotification(false, WASHER_ONLY_COMPLETE_TITLE, WASHER_ONLY_COMPLETE)
  else
    luup.log("Dryer is STOPPED",79)
    luup.log(string.format("Will a push notification be sent? %s", tostring(NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_STOPPED)),79)
    pushNotification(true, WASHER_AND_DRYER_COMPLETE_TITLE, WASHER_AND_DRYER_COMPLETE)
  end
  
end

--- Is triggered when the <b>Clothes Dryer</b> has <b>STOPPED</b> (Watts = 0).
function clothesDryerEnded()
  
  luup.log("The dryer has stopped", 79)
  luup.log(string.format("Is the washer running? %s", tostring(deviceIsRunning(WASHER_DEVICE_ID))),79)
  
  -- Check if the washer is running
  if (deviceIsRunning(WASHER_DEVICE_ID)) then
    luup.log("Washer is RUNNING",79)
    luup.log(string.format("Will a push notification be sent? %s", tostring(NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_RUNNING)),79)
    pushNotification(true, DRYER_ONLY_COMPLETE_TITLE, DRYER_ONLY_COMPLETE)
  else
    luup.log("Washer is STOPPED",79)
    luup.log(string.format("Will a push notification be sent? %s", tostring(NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_STOPPED)),79)
    pushNotification(true, WASHER_AND_DRYER_COMPLETE_TITLE, WASHER_AND_DRYER_COMPLETE)
  end
  
end

--- Sends a Pushbullet notification, as needed
-- @param booleanValue Boolean for weather or not to push a notification
-- @param notificationTitle (optional) String for the 'Title' of the notification
-- @param notificationMessage (optional) String for the 'Body' of the notification
-- @return None
-- @usage pushNotification(false)
-- @usage pushNotification(true,"Washing Machine", "The washing machine is done!")
function pushNotification(booleanValue, notificationTitle, notificationMessage)

  if (true == booleanValue) then
    luup.log("Sending Push notification.",79)
    
    -- Setup the three required fields of the request table:
    local request = {
      device    = "Both",
      title     = notificationTitle,
      url       = "http://home.getvera.com",
      url_title = "Sent by VeraEdge (Home Automation Device)",
      html      = 1,
      message   = notificationMessage
    }
    
    -- Send the request
    local success, err = pushover( request )
    
    luup.log("=======================================================================",79)
    luup.log("                          PUSHOVER RESPONSE                            ",79)
    luup.log("=======================================================================",79)
    luup.log(success)
    luup.log(err)
    if (success) then
      luup.log("Hells yeah! The push was sent successfully.",79)
    else
      luup.log("Awe snap! The push failed with error: " .. err,79)
    end
    luup.log("=======================================================================",79)
    luup.log("                       PUSHOVER RESPONSE (DONE)                        ",79)
    luup.log("=======================================================================",79)
    
  else
    luup.log("Not Sending Push notification",79)
  end
  
end

--- Checks to see if the device is running (watts > 0)
-- @param deviceID The ID of the device to check
-- @return Boolean (true = running; false = stopped)
-- @usage if (deviceIsRunning(DRYER_DEVICE_ID)) then
--   luup.log("The dryer is running!")
-- else
--   luup.log("The dryer is not running")
-- end
function deviceIsRunning(deviceID)

  local currentWatts = luup.variable_get("urn:micasaverde-com:serviceId:EnergyMetering1", "Watts", deviceID)
  
  if (tonumber(currentWatts) <= MAX_OFF_WATTAGE) then
    return false
  else
    return true
  end
  
end
