(*
Author: Stuart Ottenritter
Date Created: 2019-05-31
Description: Filter for AppleScripts (.scpt) and save each as text (.applescript) in the same location. Move the original AppleScripts to the Trash. Folder and sub-folder structure is preserved. This script was created using a droplet template; see Script Editor > File > New from Template > Droplets > Recursive File Processing Droplet.app
Parameters:
- this_folder [alias]: the folder to which the Folder Action is assigned. Â
https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_folder_actions.html
- these_items [list]: a list of items (aliases) added to folder
*)

(* TO FILTER FOR SPECIFIC FILES, ENTER THE APPROPRIATE DATA IN THE PROPERTY LISTS. *)
property type_list : {"osas"} -- e.g.: {"PICT", "JPEG", "TIFF", "GIFf"} 
property extension_list : {"scpt"} -- e.g.: {"txt", "text", "jpg", "jpeg"}, NOT: {".txt", ".text", ".jpg", ".jpeg"}

on adding folder items to this_folder after receiving these_items
	
	repeat with this_item in these_items
		set the item_info to info for this_item
		if folder of the item_info is true then
			process_folder(this_item)
		else
			try
				set this_extension to the name extension of item_info
			on error
				set this_extension to ""
			end try
			try
				set this_filetype to the file type of item_info
			on error
				set this_filetype to ""
			end try
			if (folder of the item_info is false) Â
				and (package folder of the item_info is false) Â
				and (alias of the item_info is false) Â
				and ((this_filetype is in the type_list) Â
				or (this_extension is in the extension_list)) then
				process_file(this_item)
			end if
		end if
	end repeat
	
end adding folder items to

-- this sub-routine processes folders 
on process_folder(this_folder)
	set these_items to list folder this_folder without invisibles
	repeat with i from 1 to the count of these_items
		set this_item to alias ((this_folder as Unicode text) & (item i of these_items))
		set the item_info to info for this_item
		if folder of the item_info is true then
			process_folder(this_item)
		else
			try
				set this_extension to the name extension of item_info
			on error
				set this_extension to ""
			end try
			try
				set this_filetype to the file type of item_info
			on error
				set this_filetype to ""
			end try
			if (folder of the item_info is false) Â
				and (package folder of the item_info is false) Â
				and (alias of the item_info is false) Â
				and ((this_filetype is in the type_list) Â
				or (this_extension is in the extension_list)) then
				process_file(this_item)
			end if
		end if
	end repeat
end process_folder

-- this sub-routine processes files 
on process_file(this_item)
	-- NOTE: this sub-routine variable this_item contains a file reference in alias format
	-- FILE PROCESSING STATEMENTS GO HERE
	set {new_file_alias, new_filename} to make_new_file(this_item)
	tell application "Script Editor"
		try
			set this_scpt to open this_item
			save this_scpt as "text" in new_file_alias
			close document new_filename saving no
		on error errMsg
			display alert "ERROR: " & errMsg giving up after 6
		end try
	end tell
	tell application "Finder" to delete this_item
end process_file

-- this sub-routine returns an alias in which to save the AppleScript and its filename.
on make_new_file(this_item)
	tell application "Finder"
		try -- isolate the name; fails on hidden files whose filenames begin with "."
			set parent_folder to container of this_item as alias
			set the_filename to name of this_item
			set original_delimiter to AppleScript's text item delimiters
			set AppleScript's text item delimiters to "."
			if the_filename contains "." then
				set the_name to text items 1 thru -2 of the_filename
			else
				set the_name to the_filename
			end if
			set AppleScript's text item delimiters to original_delimiter
		on error errMsg
			display alert "ERROR: " & errMsg giving up after 6
		end try
		set new_filename to the_name & ".applescript" as string
		set new_file_alias to parent_folder & new_filename as string
	end tell
	return {new_file_alias, new_filename}
end make_new_file