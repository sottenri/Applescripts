(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Search website(s) of your choosing. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- This Applescript snippet is meant to run within an Automator Quick Action workflow (formerly known as a Service).
- The Automator workflow receives text in any application as input. The input is passed to the Run Applescript action, which runs this snippet.
- Common method of use: Secondary click text and navigate to Services.
*)

(*

IMPORTANT

Insert code within the Run Applescript action of Automator; replace the action's default code.

*)

on run {input, parameters}
	
	-- confirm or edit search input
	set input to text returned of Â
		(display dialog "Enter Search Keyword(s)" buttons {"Cancel", "Search"} Â
			default button 2 default answer input giving up after 90)
	
	-- define variables
	set script_title to "Safari | Multi-Site Search"
	set search_sites_list to {Â
		"https://youtube.com/results?search_query=", Â
		"https://google.com/search?q=", Â
		"https://duckduckgo.com/?q=", Â
		"https://twitter.com/search?q=", Â
		"https://medium.com/search?q=", Â
		"https://reddit.com/search?q="}
	
	-- choose website(s) in which to search; all selected by default
	set these_sites to choose from list search_sites_list with title script_title with prompt Â
		"Search Query ..." default items search_sites_list OK button name Â
		"Query" with multiple selections allowed
	delay 0.2
	set keyword to my replace_chars(input, " ", "+")
	tell application "Safari" to activate
	repeat with this_url in these_sites
		set this_url to this_url & keyword
		tell application "Safari" to open location this_url
		delay 0.2
	end repeat
	
	return input
end run

on replace_chars(this_text, search_string, replacement_string)
	set og_delimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to og_delimiters
	return this_text
end replace_chars