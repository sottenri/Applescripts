(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Copy contact info in both csv and plain text format. Note, this is designed to work with a clipboard manager, such as Copied by Kevin Chang (https://itunes.apple.com/us/app/copied/id1026349850). The clipboard manager records the input of every copy command for later use.
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained. #kludgy
*)

property script_title : "Contacts | Export Info"
property selection_button : "Use Selection"
property group_button : "Choose Group(s)"

tell application "Contacts"
	if not running then
		activate
		delay 2
	end if
end tell

-- export selection or group
set answer to button returned of Â
	(display dialog "Export from selection or choose a Group(s)?" buttons {selection_button, group_button, "Cancel"} Â
		cancel button 3 default button 3 with title script_title giving up after 24)
delay 0.5

if answer is selection_button then
	try
		tell application "Contacts" to set these_contacts_list to (get selection)
	on error errMsg
		display alert "ERROR: " & errMsg giving up after 24
		error number -128
	end try
	if these_contacts_list is {} then
		display alert "Select contact(s) & TRY AGAIN." as informational giving up after 6
		error number -128
	end if
	set export_info to format_info(these_contacts_list)
	set the clipboard to item 1 of export_info as string
	delay 1
	set the clipboard to item 2 of export_info as string
else if answer is group_button then
	try
		tell application "Contacts" to set these_group_names_list to name of groups
	on error errMsg
		display alert "ERROR: " & errMsg giving up after 24
		error number -128
	end try
	set these_group_names to choose from list these_group_names_list with prompt "Select Group(s)" with multiple selections allowed
	set group_export_info to group_format_info(these_group_names)
	set the clipboard to item 1 of group_export_info as string
	delay 1
	set the clipboard to item 2 of group_export_info as string
end if
display notification "Copied to Clipboard" with title script_title

-- sub-routine 
on format_info(these_people)
	set csv_info_list to {}
	set plain_txt_list to ""
	repeat with this_person in these_people
		try -- get contact info
			tell application "Contacts"
				set {first name:first_name, last name:last_name, suffix:suffix_name} to this_person
				set phone_list to the value of every phone of this_person
				set email_list to the value of every email of this_person
				set address_list to the formatted address of every address of this_person
			end tell
		on error errMsg
			display alert "ERROR: " & errMsg giving up after 24
			error number -128
		end try
		-- format contact info
		set phone_list to my format_phone(phone_list)
		set phone_list to my string_format_list(phone_list, ", ")
		set email_list to my string_format_list(email_list, ", ")
		set address_list to my find_n_replace_per_item(address_list, linefeed, ", ")
		-- trim trailing comma & space from those addresses without nationality
		set formatted_address_list to {}
		repeat with this_address in address_list
			if text -1 of this_address is " " then set this_address to text 1 thru -3 of this_address as string
			copy this_address as string to the end of formatted_address_list
		end repeat
		set formatted_address_list to my string_format_list(formatted_address_list, " // ")
		-- copy csv formatted row to list
		set this_person_csv_row to {first_name, last_name, suffix_name, phone_list, email_list, formatted_address_list}
		set this_person_csv_row to my string_format_list(this_person_csv_row, "\", \"")
		set this_person_csv_row to "\"" & this_person_csv_row & "\""
		copy this_person_csv_row & linefeed to the end of csv_info_list
		-- plain text
		if suffix_name is missing value then
			set suffix_name to ""
		else
			set suffix_name to ", " & suffix_name
		end if
		if phone_list is not "" and email_list is not "" then
			set phone_list to linefeed & phone_list
			set email_list to " // " & email_list
		else if phone_list is "" and email_list is not "" then
			set email_list to linefeed & email_list
		end if
		set this_person_txt_entry to first_name & space & last_name & suffix_name & phone_list & email_list & linefeed & formatted_address_list & return & return
		set plain_txt_list to plain_txt_list & this_person_txt_entry
	end repeat
	return {csv_info_list, plain_txt_list}
end format_info

-- sub-routine
on group_format_info(these_group_names)
	set group_info_list to {}
	set plain_txt_list to ""
	repeat with this_group_name in these_group_names
		set plain_txt_list to plain_txt_list & this_group_name & return & return
		tell application "Contacts" to set these_people to people of group this_group_name
		repeat with this_person in these_people
			try -- get contact info
				tell application "Contacts"
					set {first name:first_name, last name:last_name, suffix:suffix_name} to this_person
					set phone_list to the value of every phone of this_person
					set email_list to the value of every email of this_person
					set address_list to the formatted address of every address of this_person
				end tell
			on error errMsg
				display alert "ERROR: " & errMsg giving up after 24
				error number -128
			end try
			-- format contact info
			set phone_list to my format_phone(phone_list)
			set phone_list to my string_format_list(phone_list, ", ")
			set email_list to my string_format_list(email_list, ", ")
			set address_list to my find_n_replace_per_item(address_list, linefeed, ", ")
			-- trim trailing comma & space from those addresses without nationality
			set formatted_address_list to {}
			repeat with this_address in address_list
				if text -1 of this_address is " " then set this_address to text 1 thru -3 of this_address as string
				copy this_address as string to the end of formatted_address_list
			end repeat
			set formatted_address_list to my string_format_list(formatted_address_list, " // ")
			-- copy csv formatted row to list
			set this_person_csv_row to {this_group_name as string, first_name, last_name, suffix_name, phone_list, email_list, formatted_address_list}
			set this_person_csv_row to my string_format_list(this_person_csv_row, "\", \"")
			set this_person_csv_row to "\"" & this_person_csv_row & "\""
			copy this_person_csv_row & linefeed to the end of group_info_list
			-- plain text
			if suffix_name is missing value then
				set suffix_name to ""
			else
				set suffix_name to ", " & suffix_name
			end if
			if phone_list is not "" and email_list is not "" then
				set phone_list to linefeed & phone_list
				set email_list to " // " & email_list
			else if phone_list is "" and email_list is not "" then
				set email_list to linefeed & email_list
			end if
			set this_person_txt_entry to first_name & space & last_name & suffix_name & phone_list & email_list & linefeed & formatted_address_list & return & return
			set plain_txt_list to plain_txt_list & this_person_txt_entry
		end repeat
		set plain_txt_list to plain_txt_list & return & return & return
	end repeat
	return {group_info_list, plain_txt_list}
end group_format_info

-- sub-routine
on format_phone(these_phones)
	set formatted_phone_list to {}
	set digits to characters of "1234567890"
	repeat with this_phone in these_phones
		set international to false
		set formatted_phone to ""
		repeat with i in the characters of this_phone
			if i as string is "+" then
				set international to true
			else if i is in digits then
				set formatted_phone to formatted_phone & i
			end if
		end repeat
		-- phone numbers other than USA remain an unformatted series of digits
		-- extension suffix is trimmed; ten digit USA format only
		if international and character 1 of formatted_phone is "1" then -- USA
			set formatted_phone to "(" & (characters 2 thru 4 of formatted_phone) & ")" & space & Â
				(characters 5 thru 7 of formatted_phone) & "-" & (characters 8 thru 11 of formatted_phone) as string
		else if not international then
			set formatted_phone to "(" & (characters 1 thru 3 of formatted_phone) & ")" & space & Â
				(characters 4 thru 6 of formatted_phone) & "-" & (characters 7 thru 10 of formatted_phone) as string
		end if
		copy formatted_phone to end of formatted_phone_list
	end repeat
	return formatted_phone_list
end format_phone

-- sub-routine
on string_format_list(this_list, my_delimiter)
	set original_delimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to my_delimiter
	set string_formatted_list to this_list as string
	set AppleScript's text item delimiters to original_delimiter
	return string_formatted_list as string
end string_format_list

-- sub-routine
on find_n_replace_per_item(this_list, find, replace)
	set formatted_list to {}
	repeat with this_item in this_list
		set original_delimiter to AppleScript's text item delimiters
		set AppleScript's text item delimiters to find
		set this_item to text items of this_item
		set AppleScript's text item delimiters to replace
		set this_item to this_item as string
		set AppleScript's text item delimiters to original_delimiter
		copy this_item to end of formatted_list
	end repeat
	return formatted_list
end find_n_replace_per_item