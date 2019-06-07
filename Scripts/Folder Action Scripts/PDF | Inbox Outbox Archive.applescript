(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Filter for PDFs, then rename, move to outbox folder, and prepend to all keyword-matched PDFs within the archive folder. The input PDFs must follow this strategy; keywords (multiple keywords are separated with a single SPACE character) are prefixed to the filename of the input PDF. Use a delimiter of your choice (see property below, e.g. "--") to split the keyword prefix and filename. If the keyword is contained within the filename of the archive PDF within the archive folder, then the input PDF is prepended to that matched archive PDF.
Parameters:
- this_folder [alias]: the folder to which the Folder Action is assigned. Â
https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_folder_actions.html
- these_items [list]: a list of items (aliases) added to folder
*)

(*
TO FILTER FOR SPECIFIC FILES, ENTER THE APPROPRIATE DATA IN THE PROPERTY LISTS. Â
This script is copied with changes from "Recursive File Processing Droplet.app" template in "Script Editor".
*)

-- Filter for PDFs
property type_list : {"PDF "} -- e.g.: {"JPEG", "PNGf", "GIFf", "PDF "}, NOTE the trailing SPACE character of type, "PDF "
property extension_list : {"pdf"} -- e.g.: {"txt", "jpg"}, NOT: {".txt", ".jpg"}
property typeIDs_list : {"com.adobe.pdf"} -- e.g.: {"public.jpeg", "com.adobe.photoshop-image", "com.adobe.pdf", "com.apple.pict"}

-- Folder Structure
property parent_folder : missing value
property outbox_folder : missing value
property archive_folder : missing value
property outbox_folder_name : "PDF Outbox"
property archive_folder_name : "PDF Archive"

-- Filename Delimiter; my delimiter of choice is double dashes. 
-- Multiple keywords are seperated by the SPACE character; e.g. key01 key02--example.pdf
property my_delimiter : "--"

on adding folder items to this_folder after receiving these_items
	
	internet_check("www.apple.com") -- check internet connection
	tell application "Finder" to display notification "Please give Apple iCloud a moment to sync." with title name of folder this_folder & " Folder Action"
	delay 10 -- a moment for iCloud to sync
	outbox_archive_folder(this_folder) -- check folder structure
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

-- sub-routine confirms the existence of or makes an outbox & archive folder
on outbox_archive_folder(this_folder)
	tell application "Finder"
		set parent_folder to container of this_folder
		repeat with folder_name in {outbox_folder_name, archive_folder_name}
			try
				if not (exists folder folder_name of parent_folder) then
					make new folder at parent_folder with properties {name:folder_name}
				end if
			end try
		end repeat
		set outbox_folder to folder outbox_folder_name of parent_folder
		set archive_folder to folder archive_folder_name of parent_folder
	end tell
end outbox_archive_folder

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
		set this_filetype to the file type of item_info
	on error
		set this_filetype to ""
	end try
	try
		set this_typeID to the type identifier of item_info
	on error
		set this_typeID to ""
	end try
	if (folder of the item_info is false) Â
		and (package folder of the item_info is false) Â
		and (alias of the item_info is false) Â
		and ((this_filetype is in the type_list) or (this_extension is in the extension_list) or (this_typeID is in typeIDs_list)) then
		process_file(this_item)
	end if
end filter_and_process

-- sub-routine processes files 
on process_file(this_item)
	-- NOTE that during execution, the variable this_item contains a file reference in alias format to the item passed into sub-routine
	set date_prefix to date_stamp(current date)
	set {these_keywords, file_name} to keys_and_file_name(this_item)
	display dialog "Enter a Date Prefix" default answer date_prefix with title file_name giving up after 24
	try
		set date_prefix to (text returned of result)
		if date_prefix is not "" then set file_name to date_prefix & space & file_name
	on error errMsg
		display alert "ERROR: " & errMsg giving up after 6
	end try
	delay 0.5
	tell application "Finder"
		set the name of (move this_item to outbox_folder with replacing) to file_name
		set this_item to file file_name of outbox_folder
	end tell
	set matched_items to list_keyword_archive_matches(these_keywords)
	prepend(this_item, matched_items)
end process_file

-- sub-routine returns a date stamp
on date_stamp(dt)
	set {year:y, month:m, day:d} to dt
	set m to m as integer -- convert from name to number of the month
	if m is less than 10 then set m to "0" & (m as string) -- two number places; e.g. 01
	if d is less than 10 then set d to "0" & (d as string) -- two number places; e.g. 01
	set stamp to (y & "-" & m & "-" & d) as string
	return stamp
end date_stamp

-- sub-routine uses my delimiter to seperate the keyword prefix & filename; multiple keywords are seperated with a SPACE character
-- returns a keyword list & filename string
on keys_and_file_name(this_item)
	set these_keywords to {}
	tell application "Finder" to set file_name to name of file this_item
	if file_name contains my_delimiter then
		set original_delimiter to AppleScript's text item delimiters
		set AppleScript's text item delimiters to my_delimiter
		set keyword_prefix to text item 1 of file_name
		set file_name to text items 2 thru -1 of file_name as string
		set AppleScript's text item delimiters to space
		copy every text item of keyword_prefix to these_keywords
		set AppleScript's text item delimiters to original_delimiter
	end if
	return {these_keywords, file_name}
end keys_and_file_name

-- sub-routine returns a list of files whose filenames contain keywords
-- parameter:
-- these_keywords [list]: list of strings
on list_keyword_archive_matches(these_keywords)
	set matched_items to {}
	repeat with this_keyword in these_keywords
		set keyword_match to false
		tell application "Finder"
			repeat with this_archive_item in (get every file of archive_folder)
				set this_archive_item_name to name of this_archive_item
				ignoring case and white space
					if this_archive_item_name contains this_keyword then
						copy this_archive_item to end of matched_items
						set keyword_match to true
					end if
				end ignoring
			end repeat
		end tell
		if keyword_match is false then
			display dialog "USER submitted \"" & this_keyword & "\"" & linefeed & linefeed Â
				& "... enter correction or ignore & continue. Separate multiple keywords with a single SPACE character." default answer "" with title Â
				"KEYWORD ERROR: NO MATCH FOUND" with icon caution giving up after 24
			try
				set correct_keyword to (text returned of result)
				if correct_keyword is not "" then
					set correct_keyword_list to {}
					set original_delimiter to AppleScript's text item delimiters
					set AppleScript's text item delimiters to space
					copy every text item of correct_keyword to correct_keyword_list
					set AppleScript's text item delimiters to original_delimiter
					set correct_matched_items to list_keyword_archive_matches(correct_keyword_list)
					set matched_items to matched_items & correct_matched_items
				end if
			on error errMsg
				display alert "ERROR: " & errMsg giving up after 6
			end try
			delay 0.5
		end if
	end repeat
	return matched_items
end list_keyword_archive_matches

-- sub-routine prepends the PDF to the matched archive PDF
on prepend(this_item, matched_items)
	set {prepend_doc, page_count, bookmark_dpn, bookmark_name} to pdf_info(this_item)
	repeat with this_matched_item in matched_items
		set master_doc to open_pdf(this_matched_item)
		tell application "Adobe Acrobat"
			tell master_doc
				try
					-- "without insert bookmarks" b/c "with" assumes append operation & mis-formats the final bookmark order
					insert pages after 0 from prepend_doc starting with 1 number of pages page_count without insert bookmarks
				on error errMsg
					display alert "Failed to prepend PDF." & linefeed & linefeed & errMsg giving up after 6
				end try
				-- my insert bookmarks; note, bookmark folders are NOT preserved Ñ all bookmarks are inserted, but un-nested
				repeat with i from (count of bookmark_dpn) to 1 by -1
					set this_dpn to item i of bookmark_dpn
					set this_bookmark_name to item i of bookmark_name
					make bookmark with properties {destination page number:{this_dpn}, fit type:fit page, name:this_bookmark_name}
				end repeat
				create thumbs
				set view mode to pages and bookmarks
				-- NOTE: toggle "close saving ask" as needed; also consider "close saving yes"
				-- close saving ask
			end tell
		end tell
	end repeat
	tell application "Adobe Acrobat" to close prepend_doc saving no
end prepend

-- sub-routine returns info needed to prepend PDFs
on pdf_info(this_item)
	set bookmark_dpn to {}
	set bookmark_name to {}
	set this_basename to basename(this_item)
	set this_open_pdf to open_pdf(this_item)
	tell application "Adobe Acrobat"
		set page_count to count of pages of this_open_pdf
		make bookmark with properties {destination page number:{1}, fit type:fit page, name:this_basename}
		repeat with this_bookmark in bookmarks of this_open_pdf
			set {destination page number:dpn, name:b_name} to this_bookmark
			copy dpn to end of bookmark_dpn
			copy b_name to end of bookmark_name
		end repeat
	end tell
	return {this_open_pdf, page_count, bookmark_dpn, bookmark_name}
end pdf_info

-- sub-routine returns the basename; i.e. removes extension
on basename(this_item)
	set {name:item_name, name extension:item_name_extension} to (info for this_item)
	set item_name to text 1 thru ((count item_name) - (count item_name_extension) - 1) of item_name
	return item_name
end basename

-- sub-routine opens PDFs in Adobe Acrobat
on open_pdf(this_item)
	tell application "Adobe Acrobat"
		activate
		try
			open this_item as alias
		on error errMsg
			display alert "ERROR: Cannot Open PDF - " & (this_item as string) & linefeed & linefeed & errMsg giving up after 6
			set this_item to (choose file with prompt "Try Again ... Choose PDF:" of type {"com.adobe.pdf"} without invisibles)
			open this_item as alias
		end try
		set this_open_pdf to active doc
	end tell
	return this_open_pdf
end open_pdf