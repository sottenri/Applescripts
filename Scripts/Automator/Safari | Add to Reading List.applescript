(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Add URLs to the Safari Reading List. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- This Applescript snippet is meant to run within an Automator Quick Action workflow (formerly known as a Service).
- The Automator workflow receives text in any application as input. The input is passed through the Automator Extract URLs from Text action and then to the Run Applescript action, which runs this snippet.
- Common method of use: Secondary click text and navigate to Services.
*)

(*

IMPORTANT

Insert code within the Run Applescript action of Automator; replace the action's default code.

*)

on run {input, parameters}
	
	using terms from application "Safari"
		tell application "Safari"
			repeat with theUrl in input
				delay 0.5
				add reading list item theUrl as string
			end repeat
		end tell
	end using terms from
	display notification ((count of input) as string) Â
		& " item(s) added to the Reading List" with title "Safari"
	
	return input
end run