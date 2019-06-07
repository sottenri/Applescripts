(*
Author: Stuart Ottenritter
Date Created: 2019-05-31
Description: Filter for txt files. Trigger actions based on the filename. Delete the txt file(s).
Parameters:
- this_folder [alias]: the folder to which the Folder Action is assigned. Â
https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_folder_actions.html
- these_items [list]: a list of items (aliases) added to folder
*)

(*
TO FILTER FOR SPECIFIC FILES, ENTER THE APPROPRIATE DATA IN THE FOLLOWING LISTS; Â
copied with changes from "Recursive File Processing Droplet.app" template in "Script Editor" Â
https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/conceptual/ASLR_variables.html#//apple_ref/doc/uid/TP40000983-CH223-SW1
*)

-- Txt Trigger Properties for Sleep
property sleep_txt_trigger : "Sleep"

-- Txt Trigger Properties for iTunes | Pause At End
property pause_at_end_txt_trigger : "Pause"
property pause_at_end_POSIX_path : (POSIX path of (path to library folder from user domain) Â
	& "/Scripts/Applications/iTunes/iTunes | Pause At End.scpt")

-- Txt Trigger Properties for Movie Ratings
property movie_rating_txt_trigger : "Rating"
property movie_rating_POSIX_path : (POSIX path of (path to library folder from user domain) Â
	& "/Mobile Documents/com~apple~Numbers/Documents/Movie Ratings.numbers")
property movie_rating_table_name : "Movie Ratings"

-- Filter for txt Files
property extension_list : {"txt"} -- e.g.: {"txt", "jpg"}, NOT: {".txt", ".jpg"}
property typeIDs_list : {"public.plain-text"} -- e.g.: {"public.jpeg", "com.adobe.pdf", "com.apple.pict"}

on adding folder items to this_folder after receiving these_items
	
	internet_check("www.apple.com") -- check internet connection
	tell application "Finder" to display notification "Please give Apple iCloud a moment to sync." with title name of folder this_folder & " Folder Action"
	delay 4 -- wait a moment for iCloud to sync
	repeat with this_item in these_items
		set the item_info to info for this_item
		if folder of the item_info is true then
			process_folder(this_item)
		else
			filter_and_process(this_item)
		end if
	end repeat
	
end adding folder items to

-- sub-routine checks the internet connection by pinging a website
on internet_check(www)
	repeat with int from 1 to 2
		try
			do shell script "ping -o -t 2 " & www as string
			exit repeat
		on error errMsg
			delay 2
			if int = 2 then
				display alert "No Internet Connection" & linefeed & linefeed & errMsg as critical giving up after 6
				error number -128
			end if
		end try
	end repeat
end internet_check

-- sub-routine processes folders; copied with changes from "Recursive File Processing Droplet.app" template in "Script Editor"
on process_folder(this_folder)
	set these_items to list folder this_folder without invisibles
	repeat with i from 1 to the count of these_items
		set this_item to alias ((this_folder as Unicode text) & (item i of these_items))
		set the item_info to info for this_item
		if folder of the item_info is true then
			process_folder(this_item)
		else
			filter_and_process(this_item)
		end if
	end repeat
	tell application "Finder" to delete this_folder
end process_folder

-- sub-routine filters for specific files; copied from "Recursive File Processing Droplet.app" template in "Script Editor"
on filter_and_process(this_item)
	set the item_info to info for this_item
	try
		set this_extension to the name extension of item_info
	on error
		set this_extension to ""
	end try
	try
		set this_typeID to the type identifier of item_info
	on error
		set this_typeID to ""
	end try
	if (folder of the item_info is false) Â
		and (package folder of the item_info is false) Â
		and (alias of the item_info is false) Â
		and ((this_extension is in the extension_list) or (this_typeID is in typeIDs_list)) then
		process_file(this_item)
	end if
end filter_and_process

-- sub-routine processes files 
on process_file(this_item)
	-- NOTE that during execution, the variable this_item contains a file reference in alias format to the item passed into sub-routine
	try
		set file_name to name of (info for this_item)
		set item_content to paragraphs of (read this_item)
		tell application "Finder" to delete this_item
	on error errMsg
		display alert "ERROR: " & errMsg giving up after 6
	end try
	delay 4 -- wait a moment
	ignoring case and white space
		if file_name contains sleep_txt_trigger then
			tell application "Finder" to sleep
		else if file_name contains pause_at_end_txt_trigger then
			run_this_Applescript(pause_at_end_POSIX_path)
		else if file_name contains movie_rating_txt_trigger then
			set movie_info to first item of item_content
			prepend_row(movie_rating_POSIX_path, movie_rating_table_name, movie_info)
		end if
	end ignoring
end process_file

-- sub-routine runs another Applescript
on run_this_Applescript(POSIX_path_to_Applescript)
	try
		run script POSIX file POSIX_path_to_Applescript
	on error errMsg
		display alert errMsg as informational giving up after 6
		error number -128
	end try
end run_this_Applescript

-- sub-routine prepends a new row to the Apple Numbers spreadsheet; table must be in active (default) sheet of document
on prepend_row(POSIX_path_to_Numbers_file, table_name, row_input)
	if row_input is not "" then
		set input_list to my csv_to_list(row_input)
		tell application "Numbers"
			activate
			try
				open POSIX file POSIX_path_to_Numbers_file as alias
				delay 2
				tell front document's active sheet
					tell table table_name
						set filter_boolean to filtered -- note state of filter
						set filtered to false
						set first_row_of_body to header row count + 1
						add row above row first_row_of_body -- prepend row will match style of body
						tell row first_row_of_body
							repeat with i from 1 to (count of items in input_list)
								set value of cell i to item i of input_list
							end repeat
						end tell
						set filtered to filter_boolean -- restore state of filter
					end tell
				end tell
				delay 2
				close front document saving yes
			end try
		end tell
	else
		display alert "No Values Found" giving up after 6
	end if
end prepend_row

-- sub-routine process comma-separated values
on csv_to_list(csv)
	set tid to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ", "
	set new_list to text items of csv
	set AppleScript's text item delimiters to tid
	return new_list
end csv_to_list

-- sub-routine returns a date stamp
on date_stamp(dt)
	set {year:y, month:m, day:d} to dt
	set m to m as integer -- convert from name to number of the month
	if m is less than 10 then set m to "0" & (m as string) -- two number places; e.g. 01
	if d is less than 10 then set d to "0" & (d as string) -- two number places; e.g. 01
	set stamp to (y & "-" & m & "-" & d) as string
	return stamp
end date_stamp

-- sub-routine returns the basename; i.e. removes extension
on basename(this_item)
	set {name:item_name, name extension:item_name_extension} to (info for this_item)
	set item_name to text 1 thru ((count item_name) - (count item_name_extension) - 1) of item_name
	return item_name
end basename