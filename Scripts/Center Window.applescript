(*
Author: Stuart Ottenritter
Date Created: 2019-02-27
Description: Center the front most window.
*)

tell application "Finder"
	set screen_size to bounds of window of desktop
	set screen_width to item 3 of screen_size
	set screen_height to item 4 of screen_size
end tell

tell application "System Events"
	set the_frontmost to name of first item of (processes whose frontmost is true)
	tell process the_frontmost
		if front window exists then
			tell front window
				if value of attribute "AXFullScreen" then
					display alert "Full Screen Mode is Active" giving up after 6
				else
					try
						set window_prop to properties
						set window_size to size
						set window_width to item 1 of window_size
						set window_height to item 2 of window_size
						set x_origin to round ((screen_width - window_width) / 2) rounding as taught in school
						set y_origin to round ((screen_height - window_height) / 2) rounding as taught in school
						set position to {x_origin, y_origin}
					on error errMsg
						display alert "ERROR: " & errMsg giving up after 6
					end try
				end if
			end tell
		else
			beep
		end if
	end tell
end tell