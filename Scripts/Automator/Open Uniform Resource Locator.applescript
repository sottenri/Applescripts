(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: URL(s) will be opened within your browser(s) of choice. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- This Applescript snippet is meant to run within an Automator Quick Action workflow (formerly known as a Service).
- The Automator workflow receives text in any application as input. The input is passed through the Automator Extract URLs from Text action and then to the Run Applescript action, which runs this snippet.
- Common method of use: Secondary click text and navigate to Services.
*)

(*

IMPORTANT

Insert code within a Run Applescript action of Automator; replace the action's default code.

*)

on run {input, parameters}
	
	-- define variables
	set script_title to "Open Uniform Resource Locator(s)"
	set browser_list to {"Safari", "Google Chrome", "Firefox", "Brave Browser"}
	
	-- open in browser(s) of choice
	set these_browsers to choose from list browser_list with title script_title with prompt Â
		"Select Browser(s)" default items {"Safari"} OK button name "Open URL(s)" with multiple selections allowed
	repeat with this_browser in these_browsers
		try
			set this_browser_app to POSIX path of (path to application this_browser)
			using terms from application "Safari"
				tell application this_browser_app
					activate
					delay 0.5
					repeat with this_url in input
						try
							open location this_url
						end try
						delay 0.2
					end repeat
				end tell
			end using terms from
		on error errMsg
			display dialog errMsg with icon caution giving up after 6
			delay 0.2
		end try
	end repeat
	
	return input
end run