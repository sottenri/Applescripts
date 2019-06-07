(*
Author: Stuart Ottenritter
Date Created: 2018-10-01
Description: Toggle Dark Mode 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

tell application "System Events"
	tell appearance preferences
		set dark mode to not dark mode
	end tell
end tell