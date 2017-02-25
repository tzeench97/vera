--- This module is for monitoring the clothes washer and dryer.
-- It will also send Pushover notifications as needed
-- NOTE: Decisions on sending notifications or not are set in the
--       NOTIFY_WHEN_xxx_STOPS_AND_xxx_xxx variables.
--
--    ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~      
-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
--  !!! REQUIRES THE 'CustomScript_pushover' SCRIPT TO WORK !!!
-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
--     ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
--       
-- @author Andrew Stenzel
-- @module WasherDryerMonitor

require("CustomScript_pushover")

-- ---------------
-- Local variables
-- ---------------
local DRYER_DEVICE_ID = 4
local WASHER_DEVICE_ID = 19

local NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_STOPPED = true
local NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_RUNNING = false
local NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_STOPPED = true
local NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_RUNNING = true

local WASHER_AND_DRYER_COMPLETE = "The <b><font color='red'>washer</font></b> and <b><font color='red'>dryer</font></b> are complete"
local WASHER_ONLY_COMPLETE = "The <b><font color='red'>washer</font></b> is complete, but the <b><font color='red'>dryer</font></b> is still running"
local DRYER_ONLY_COMPLETE = "The <b><font color='red'>dryer</font></b> is complete, but the <b><font color='red'>washer</font></b> is still running"

local WASHER_AND_DRYER_COMPLETE_TITLE = "Laundry is Ready"
local WASHER_ONLY_COMPLETE = "Laundry is Ready"
local DRYER_ONLY_COMPLETE = "Laundry is Ready"

--- Is triggered when the <b>Clothes Washer</b> has <b>STOPPED</b> (Watts = 0).
function clothesWasherEnded()

  luup.log("The washer has stopped", 79)
  luup.log(string.format("Is the dryer running? %s", tostring(deviceIsRunning(DRYER_DEVICE_ID))),79)
  
  -- Check if the dryer is running
  if (deviceIsRunning(DRYER_DEVICE_ID)) then
    luup.log("Dryer is RUNNING",79)
    luup.log(string.format("Will a push notification be sent? %s", tostring(NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_RUNNING)),79)
    --pushNotification(NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_RUNNING)
    pushNotification(false, WASHER_ONLY_COMPLETE, WASHER_ONLY_COMPLETE)
  else
    luup.log("Dryer is STOPPED",79)
    luup.log(string.format("Will a push notification be sent? %s", tostring(NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_STOPPED)),79)
    --pushNotification(NOTIFY_WHEN_WASHER_STOPS_AND_DRYER_STOPPED)
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
    --pushNotification(NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_RUNNING)
    pushNotification(true, DRYER_ONLY_COMPLETE, DRYER_ONLY_COMPLETE)
  else
    luup.log("Washer is STOPPED",79)
    luup.log(string.format("Will a push notification be sent? %s", tostring(NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_STOPPED)),79)
    --pushNotification(NOTIFY_WHEN_DRYER_STOPS_AND_WASHER_STOPPED)
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

  currentWatts = luup.variable_get("urn:micasaverde-com:serviceId:EnergyMetering1", "Watts", deviceID)
  
  if (currentWatts == "0.000") then
    return false
  else
    return true
  end
  
end

-- =========================================================
--  Executed code
-- =========================================================
luup.log("",79)
luup.log("",79)
luup.log("",79)
luup.log("=======================================================================",79)
luup.log("           Test beginning @ " .. os.date("%c"),79)
luup.log("=======================================================================",79)
luup.log(string.format("Is the DRYER currently Running? %s", tostring(deviceIsRunning(DRYER_DEVICE_ID))),79)
luup.log(string.format("Is the WASHER currently Running? %s", tostring(deviceIsRunning(WASHER_DEVICE_ID))),79)
luup.log("=======================================================================",79)
luup.log("-----------------------------------------------------------------------",79)
luup.log("Simulating the washer as stopped",79)
luup.log("-----------------------------------------------------------------------",79)
clothesWasherEnded()
luup.log("-----------------------------------------------------------------------",79)
luup.log("Simulating the Dryer as stopped",79)
luup.log("-----------------------------------------------------------------------",79)
clothesDryerEnded()
luup.log("=======================================================================",79)
luup.log("                              Test Ended                               ",79)
luup.log("=======================================================================",79)
