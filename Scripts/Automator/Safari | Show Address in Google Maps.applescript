(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Open a street address in Safari with Google Maps. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- This Applescript snippet is meant to run within an Automator Quick Action workflow (formerly known as a Service).
- The Automator workflow receives addresses in any application as input. The input is passed to the Run Applescript action, which runs this snippet.
- Common method of use: Select the address, secondary click and navigate to Services.
*)

(*

IMPORTANT

Insert code within the Run Applescript action of Automator; replace the action's default code.

*)

on run {input, parameters}
	
	-- format input
	set input to replace_chars(input, return, "+")
	set input to replace_chars(input, linefeed, "+")
	set input to replace_chars(input, " ", "+")
	set input to replace_chars(input, "#", "%23")
	
	-- open Google map
	tell application "Safari"
		open location ("https://www.google.com/maps/place/" & input)
		activate
	end tell
	
	return input
end run

-- sub-routine
on replace_chars(this_text, search_string, replacement_string)
	set original_delimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to original_delimiters
	return this_text
end replace_chars