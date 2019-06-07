(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Search multiple websites.
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

property search_sites : {Â
	"https://www.google.com/search?q=", Â
	"https://duckduckgo.com/?q=", Â
	"https://twitter.com/search?q=", Â
	"https://www.reddit.com/search?q=", Â
	"https://www.youtube.com/results?search_query="}

display dialog "Search for ..." default answer "" with title "Safari | Multi-Site Search"
try
	set input to text returned of result
on error errMsg
	display alert "ERROR: " & errMsg
	error number -128
end try
delay 0.2
set keyword to my replace_chars(input, " ", "+")
tell application "Safari" to activate
repeat with this_url in search_sites
	set this_url to this_url & keyword
	tell application "Safari" to open location this_url
	delay 0.2
end repeat
set keyword to my replace_chars(input, " ", "")
tell application "Safari" to open location ("https://www.instagram.com/explore/tags/" & keyword)

on replace_chars(this_text, search_string, replacement_string)
	set og_delimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to og_delimiters
	return this_text
end replace_chars