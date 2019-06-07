(*
Author: Stuart Ottenritter
Date Created: 2019-05-31
Description: Prepend movie details and rating ("YEAR, TITLE, GENRE, RATING, DATE of SCREENING") to Apple Numbers spreadsheet.
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

-- Movie Rating Properties
property default_answer : "YEAR, TITLE, GENRE, RATING, DATE of SCREENING"
property movie_rating_POSIX_path : (POSIX path of (path to library folder from user domain) Â
	& "/Mobile Documents/com~apple~Numbers/Documents/Movie Ratings.numbers")
property movie_rating_table_name : "Movie Ratings"

-- Enter Comma-Separated Details
set csv_input to text returned of Â
	(display dialog "Enter Comma-Separated Movie Details & Rating" buttons {"Cancel", "Enter"} Â
		default button 2 default answer default_answer giving up after 90)

-- Prepend Row
if csv_input is not default_answer and csv_input is not "" then
	set input_list to my csv_to_list(csv_input)
	tell application "Numbers"
		activate
		try
			open POSIX file movie_rating_POSIX_path as alias
			delay 2
			tell front document's active sheet
				tell table movie_rating_table_name
					set filter_boolean to filtered --note state of filter
					set filtered to false
					set first_row_of_body to header row count + 1
					add row above row first_row_of_body --new row will match style of body
					tell row first_row_of_body
						repeat with i from 1 to (count of items in input_list)
							set value of cell i to item i of input_list
						end repeat
					end tell
					set filtered to filter_boolean --reset to beginning state of filter
				end tell
			end tell
			delay 4
			close front document saving yes
		end try
	end tell
else
	display alert "No Movie Details Entered" giving up after 6
end if

on csv_to_list(csv)
	set tid to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ", "
	set new_list to text items of csv
	set AppleScript's text item delimiters to tid
	return new_list
end csv_to_list