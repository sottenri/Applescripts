(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Delete SMS messages.
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

tell application "Messages"
	if not running then
		activate
		delay 4
	else
		activate
	end if
	set these_messages to every chat in service "SMS"
	repeat with this_message in these_messages
		delete this_message
		delay 0.2
	end repeat
end tell
if these_messages is {} then
	display notification "NO SMS Messages." with title "Messages"
else
	display notification "SMS messages DELETED." with title "Messages"
end if