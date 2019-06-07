(*
Author: Stuart Ottenritter
Date Created: 2018-10-24
Description: Files last modified more than ninety days ago are moved to the Trash. Script is triggered when items are added to the folder.
Parameters:
- this_folder [alias]: the folder added to
- these_items [list]: a list of items (aliases) added
Properties:
- age [integer]: days after which items of folder are moved to Trash
*)

property age : 90

on adding folder items to this_folder after receiving these_items
	
	set age_limit to (current date) - (age * days)
	tell application "Finder"
		try
			set old_items to (files of entire contents of folder this_folder whose modification date is less than age_limit)
			set n_items to count of old_items
			if n_items is greater than 0 then
				delete old_items
				display notification (n_items as text) & Â
					" items were moved to the Trash. They were last modified more than " & (age as text) & Â
					" days ago." with title name of folder this_folder & " Folder Action"
			end if
		on error theErr number theErrNumber
			display dialog theErr with title "ERROR: " & theErrNumber with icon caution giving up after 12
		end try
	end tell
	
end adding folder items to