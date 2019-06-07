(*
Author: Stuart Ottenritter
Date Created: 2018-10-01
Description: Close all notification alerts.
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

tell application "System Events"
	tell process "Notification Center"
		set window_count to count of every window
		repeat with i from window_count to 1 by -1
			try
				click button 1 of window i
			end try
		end repeat
	end tell
end tell