(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Pause at the end of the current track with the option to then go to sleep. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- Does NOT work if iTunes is streaming the track; as of 2018, have not looked into solution. 
- The "play current track with once" operation does not work if the "Up Next" queue contains tracks. 
- The track calculation Ñ duration minus player position Ñ returns an imprecise result and cannot be used to simply delay and pause. Hence the implementation of the track change event handler using the repeat until routine.
*)

property script_title : "iTunes | Pause At End"
property sleep_button : "Yes, SLEEP"
property now_button : "Pause NOW"

tell application "iTunes"
	if not running or player state is not playing then
		activate
		delay 1
		display alert "iTunes is NOT Playing." as informational giving up after 6
		error number -128
	else
		try
			set curr_track to current track
			set {name:track_name, artist:track_artist, duration:track_duration} to curr_track
		on error errMsg
			tell application "iTunes" to activate
			display dialog "ERROR:  " & errMsg & linefeed & linefeed & Â
				"iTunes is probably STREAMING the track!" & linefeed & linefeed & Â
				"Track needs to be ADDED to Library in order for AppleScript to run properly." giving up after 12
			error number -128
		end try
	end if
end tell

-- set variable
set track_info to "\"" & track_name & "\" by " & track_artist

-- option to sleep
display dialog "Sleep at end of " & track_info & "?" buttons {"Stay Awake", sleep_button, now_button} Â
	default button 1 with title script_title giving up after 12
set answer to button returned of result
delay 0.5

-- pause and/or sleep
if answer is now_button then
	tell application "iTunes" to pause
else
	tell application "iTunes"
		set song repeat to off -- assure track change
		set timer to track_duration - player position
		set tminus_string to "T-minus " & (timer div 60 as string) & " min & " & (round (timer mod 60)) & " sec"
		display notification "At end of " & track_info with title script_title subtitle tminus_string -- UX
		set track_change_trigger to curr_track
		delay track_duration - player position - 0.5 -- delay until last half-second of track
		repeat until curr_track is not track_change_trigger or player state is not playing -- listen for track change event
			try
				set track_change_trigger to current track
			on error
				set track_change_trigger to missing value
			end try
		end repeat
		pause
	end tell
	if answer is sleep_button then
		tell application "Finder"
			activate
			display dialog "Going to Sleep in Ten Seconds." buttons {"Cancel Sleep"} Â
				default button 1 cancel button 1 with icon caution giving up after 10
			delay 0.5
			sleep
		end tell
	end if
end if