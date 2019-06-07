(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Make a reminder out of an email message. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

property script_title : "Mail | Reminders"
property reminders_list : "Reminders"
property n_days : 10 -- default days from now on which to be reminded.

-- define variables
set soon_ish to (current date) + (n_days * days)
set {month:_month, day:_day, year:_year} to soon_ish

-- create reminder
tell application "Mail"
	if not running then
		activate
		check for new mail
		delay 4
		display alert "Select message(s)." as informational giving up after 12
		error number -128
	else
		activate
	end if
	try
		set input to (get selection)
	on error errMsg
		display alert "ERROR: " & errMsg giving up after 12
		error number -128
	end try
end tell
repeat with this_msg in input
	try
		tell application "Mail" to set {sender:_sender, subject:_subj} to this_msg
	on error errMsg
		display alert "ERROR: " & errMsg giving up after 12
		error number -128
	end try
	set msg_details to _subj & " | " & _sender
	display dialog "Enter date on which to be reminded of ..." & linefeed & linefeed & _subj & "." & linefeed & linefeed & Â
		"Use the date format shown or mm-dd-yyyy hh:mm am(or pm)." default answer ((_month & space & _day & ", " & _year) as string) & Â
		" 9:05 AM" with title script_title giving up after 24
	set new_date to date (text returned of result)
	tell application "Reminders"
		try
			tell list reminders_list
				make new reminder with properties {name:msg_details, due date:new_date}
			end tell
		on error errMsg
			display alert "ERROR: " & errMsg giving up after 12
			error number -128
		end try
	end tell
end repeat
display notification ((count of input) as string) & " reminder(s) created." with title script_title
