--[[
=========================================
           Things to remember           
=========================================

------------
 UNIX STUFF
------------
Log file Location:
    /tmp/log/cmh
    
Custom Lua Files:
    /etc/cmh-ludl
    
Tail ONLY log level 79 and critical errors (level 01):
    tail -f /tmp/log/cmh/LuaUPnP.log | grep '^79\|^01'

----------------
 LUA/LUUP STUFF
----------------
luup.log("What is the variables value: " .. varName, 79)
    This will write to the log with the custom log level of 79
    (Note: This is set in the /etc/cmh/cmh.conf file and requires a reboot if changed)

currentWatts = luup.variable_get("urn:micasaverde-com:serviceId:EnergyMetering1", "Watts", 19)
    Use the 'EnergyMetering1' definition to get the variable 'Watts' from device ID 19
    
    Energy Meters ......... urn:micasaverde-com:serviceId:EnergyMetering1
    Garage Doors .......... urn:schemas-micasaverde-com:device:DoorLock:1
    Thermostat ............ urn:schemas-upnp-org:device:HVAC_ZoneThermostat:1
    Door/Window Sensor .... urn:schemas-micasaverde-com:device:DoorSensor:1

]]--