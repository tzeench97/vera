-----------------------------------------------------------------------------
	File: CustomScript_pushover.lua
	
	Author:  Andrew Stenzel
	
	Purpose:
		This script is to leverage the use of push notifications to your 
		mobile device via the free Pushover application (http://pushover.net)
		NOTE: You need to set the following values in the startup lua 
		(Apps / Develop Apps / Edit Startup Lua)
		    PUSHOVER_APP_KEY   = The applications key (for your specific application; found under "Your Applications") 
                    PUSHOVER_GROUP_KEY = The delivery group key (for your specific delivery groups; found under "Your Delivery Groups")
                    PUSHOVER_USER_KEY  = The Pushover user key (found on the main dashboard of the Pushover web site)
		
	Usage Syntax: 
   		success, err = pushover( { keyValuePairs } )
   		
   	Data Types:
   		success => boolean
   		err => string
   		keyValuePairs => table 
   					(containing key/values corresponding to the pushover API)
   		
   	Example:
		require("CustomScript_pushover")

		-- Setup the three required fields of the request table:
		local request = {
			device    = "Both",
			title     = "Saltwater Tank",
			url       = "http://home.getvera.com",
			url_title = "Sent by VeraEdge (Home Automation Device)",
			html      = 1,
			message   = "The <b><font color='red'>60 Gallon Saltwater Tank</font></b> is drawing less than 10 watts of power.  You might want on check it."
		}

		-- Send the request
		local success, err = pushover( request )

		-- Check the response
		luup.log("=======================================================================")
		luup.log("           60G SALTWATER TANK LOW WATTS - PUSHOVER RESPONSE            ")
		luup.log("=======================================================================")
		luup.log(success)
		luup.log(err)
		if (success) then
			luup.log("Hells yeah! The push was sent successfully.")
		else
			luup.log("Awe snap! The push failed with error: " .. err)
		end
		luup.log("=======================================================================")
		luup.log("        60G SALTWATER TANK LOW WATTS - PUSHOVER RESPONSE (DONE)        ")
		luup.log("=======================================================================")
		
-----------------------------------------------------------------------------
