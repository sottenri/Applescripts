(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: This script adjusts the date of the selected photo(s). This script does NOT preserve the time difference between the selected photos. The date of the youngest (most recent in date and time) selected photo is adjusted to the requested new date and the remaining photos of the selection are incrementally adjusted to a time before that of the new date. The time increment is set below; see the properties of this script. (Note, the native "Adjust Date and Time ..." feature within the macOS Photos application preserves the time difference between photos; e.g. a selection of two photos whose dates are a day apart remain a day apart when their dates are adjusted using the date adjustment feature native to the Photos application.)
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

property time_increment : (-0.05 * minutes) -- time between date adjustments; note, negative when selection loaded into repeat routine backwards
property sir_john_herschel : date "Tuesday, January 1, 1839 at 12:01:00 AM" -- the year the word "photography" was coined; adjustments set before this date will throw an error

-- check for selection
tell application "Photos"
	if not running then
		activate
		delay 4 -- moment for Photos to activate
	else
		activate
	end if
	if selection exists then
		set input to (get selection)
	else
		display alert "No Photos Selected." as informational giving up after 6
		error number -128
	end if
end tell

-- enter new date
set curr_date to current date
set now_ish to (curr_date - (1 * minutes)) -- minute(s) before NOW to avoid time conflict
set {month:_month, day:_day, year:_year, time string:_time} to now_ish
display dialog Â
	"Use date format shown or mm-dd-yyyy hh:mm am(or pm)." default answer (_month & space & _day & ", " & _year & space & _time) as string with title "Enter a Date"
try
	set new_date to date (text returned of result)
on error errMsg
	display alert "ERROR: " & errMsg
	error number -128
end try

-- CHECK DATE; warn if a future date or old AF
set before_photography to (curr_date - sir_john_herschel)
set check_date to (curr_date - new_date)
if check_date ² 0 then
	display alert "A date in the FUTURE was entered." & linefeed & linefeed & "Future-photography has NOT yet been invented. Try Again."
	error number -128
else if check_date > before_photography then
	display dialog "You entered a date in the year " & (year of new_date as string) & "." & linefeed & linefeed & Â
		"That is BEFORE the word \"photography\" was even coined by Sir John Herschel in 1839." & linefeed & linefeed & Â
		"Are you sure you want to adjust the date of the photo?" with icon caution
	copy_as_string(new_date)
	adjust_date_of_photo(input, new_date)
else
	copy_as_string(new_date)
	adjust_date_of_photo(input, new_date)
end if

on copy_as_string(this_item)
	set this_item to this_item as string
	set the clipboard to this_item
	delay 0.5 -- moment to copy to clipboard
	-- display notification this_item with title "Copied to Clipboard"
end copy_as_string

-- sub-routine
on adjust_date_of_photo(these_photos, new_date)
	tell application "Photos"
		activate
		set i to 0 -- counter for time incrementation
		set selection_count to count of these_photos
		repeat with reverse_i from selection_count to 1 by -1 -- loads selection backwards; last photo is set to new date & others are set earlier in time
			set this_photo to item reverse_i of these_photos
			set {name:_name, description:_describe, date:_date, filename:_fname} to this_photo
			set time_difference to (new_date - _date) + (i * time_increment) -- apply time increment
			set i to i + 1 -- count forward; required b/c selection loaded backwards; i.e. the variable "reverse_i" counts backwards
			try
				tell this_photo
					set the date of this_photo to (_date + time_difference) as date
				end tell
			on error errMsg
				display dialog "Unable to change date. Photo details:" & return & "Name: " & _name & return & Â
					"Filename: " & _fname & return & "Description: " & _describe & return & "Date: " & _date & return & "Error: " & errMsg
			end try
		end repeat
		
		-- notify
		delay 0.5
		if selection_count = 1 then
			display notification "One photo adjusted to " & (new_date as string) with title "Photos | Date Adjustment"
		else
			display notification (selection_count as string) & " photos adjusted to " & (new_date as string) with title "Photos | Date Adjustment"
		end if
		delay 3 -- UX pacing
		
		-- spotlight photos or stay in current location
		display dialog "Go to Photo in New Location or Stay Here?" buttons {"Stay Here", "Go to Photo"} default button 2 giving up after 12
		if (button returned of result) is "Go to Photo" then
			delay 0.5
			spotlight this_photo
		end if
	end tell
end adjust_date_of_photo