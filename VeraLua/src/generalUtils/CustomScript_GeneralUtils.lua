--- This is a general utilitys module for working with the
-- vera devices.  These are intentially generic so the can
-- be easily reused.
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
-- @module generalUtils


--- Finds the devices ID by name.
-- @param deviceName The name of the device to get the ID for (String)
-- @return The ID of the device or null if not found
-- @usage luup.log(string.format("Washing Machine ID: %s", ID["Washing Machine"])
function findDeviceIdByName(deviceName)

  -- Initialize and index all the devices by symbolic name
  ID = {}
  for i,d in pairs(luup.devices) do
    ID[d.description] = i
  end
  
  -- Get the device ID by symbolic name
  return ID[deviceName]

end
