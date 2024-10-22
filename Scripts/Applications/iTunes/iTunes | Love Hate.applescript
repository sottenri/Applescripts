(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Love or Hate. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- Does NOT work if iTunes is streaming the track; as of 2018, have not looked into solution. 
*)

property script_title : "iTunes | Love Hate"
property love_button : "LOVE"
property hate_button : "HATE"

tell application "iTunes"
	if not running or player state is not playing then
		activate
		delay 1
		display alert "iTunes is NOT Playing." as informational giving up after 6
		error number -128
	else
		try
			set curr_track to current track
			set {name:track_name, artist:track_artist} to curr_track
		on error errMsg
			tell application "iTunes" to activate
			display dialog "ERROR:  " & errMsg & linefeed & linefeed & ¬
				"iTunes is probably STREAMING the track!" & linefeed & linefeed & ¬
				"Track needs to be ADDED to Library in order for AppleScript to run properly." giving up after 12
			error number -128
		end try
	end if
end tell

set track_info to "\"" & track_name & "\" by " & track_artist
display dialog track_info buttons {love_button, hate_button, "Cancel"} ¬
	default button 1 cancel button 3 with title script_title giving up after 12
set answer to button returned of result
delay 0.5

if answer is love_button then
	tell application "iTunes"
		reveal curr_track
		set loved of curr_track to true
		display notification "❤️ " & track_info & "." with title script_title
	end tell
else
	tell application "iTunes"
		reveal curr_track
		set disliked of curr_track to true
		display notification "Hated " & track_info & ". NEXT!" with title script_title
		next track
	end tell
end if