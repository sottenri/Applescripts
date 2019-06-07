(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: In Safari, open frequently visited websites by category. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- This Applescript snippet is meant to run within an Automator Quick Action workflow (formerly known as a Service).
- An Automator Quick Action workflow enables the user to assign a keystroke shortcut. First, save the workflow in the ~/Library/Services/ folder. Then assign a keystroke shortcut in System Preferences; navigate to the Keyboard preference and select the Shortcuts tab. Select the Services category on left. Scroll to locate the Quick Actions on right. Assign a keystroke to run the Quick Action. (Read More: https://apple.stackexchange.com/questions/175215/how-do-i-assign-a-keyboard-shortcut-to-an-applescript-i-wrote)
- This snippet accepts a nested list of URLs as input. The first item of each nested list is the category name. Customize your URL categories & hyperlinks as needed. See example code below:

	set input to {Â
		{"YouTube", "https://www.youtube.com/playlist?list=WL&disable_polymer=true"}, Â
		{"Reading", "https://feedly.com/i/latest", "https://medium.com"}, Â
		{"Cryptocurrency", "https://coinmarketcap.com", "https://coincap.io"} Â
			}		
*)

(*

IMPORTANT

Insert code within the Run Applescript action of Automator; replace the action's default code.

*)

on run {input, parameters}
	
	set script_title to "Safari | Open Websites"
	set these_choices to {}
	repeat with this_input in input
		copy item 1 of this_input to the end of these_choices
	end repeat
	set default_choice to item 1 of (item 1 of input)
	
	-- choose catagory
	set my_choices to choose from list these_choices with title script_title with prompt Â
		"Select a Category" default items default_choice OK button name "Open Websites" cancel button name Â
		"Cancel" with multiple selections allowed without empty selection allowed
	delay 0.2
	
	-- open websites
	repeat with this_choice in my_choices
		repeat with this_item in input
			if this_choice is in this_item then
				set URL_list to (items 2 thru -1 of this_item)
				my open_websites(URL_list)
			end if
		end repeat
	end repeat
	
	-- SPECIAL INSTRUCTIONS FOR SINGLE SELECTION ONLY
	if (count of my_choices) is equal to 1 then
		if my_choices contains "YouTube" then
			set theClassName to Â
				"yt-uix-button yt-uix-button-size-default yt-uix-button-default remove-watched-button" -- from source code of YouTube Watch Later Playlist
			set elementnum to 0
			set the_state to missing value
			set removebutton to true
			delay 2
			tell application "Safari"
				repeat until the_state is "complete"
					set the_state to (do JavaScript "document.readyState" in document 1)
					delay 0.5
				end repeat
				delay 2
				if (source of document 1 as text) contains theClassName then
					repeat until removebutton is false
						delay 1
						if (source of document 1 as text) contains theClassName then
							my clickClassName(theClassName, elementnum) -- remove watched YouTube videos
						else
							delay 1
							set removebutton to false
							set the URL of the current tab of window 1 to "https://www.youtube.com/feed/subscriptions"
						end if
					end repeat
				else
					set the URL of the current tab of window 1 to "https://www.youtube.com/feed/subscriptions"
				end if
			end tell
		else if my_choices contains "Reading" then
			tell application "News" to activate
		end if
	end if
	
	return input
end run

(*
Insert sub-routines below the run function of the Run Applescript action of Automator.
*)

-- this sub-routine opens websites in Safari
on open_websites(URL_list)
	tell application "Safari"
		activate
		repeat with this_website in URL_list
			open location this_website
			delay 0.2
		end repeat
	end tell
end open_websites

-- this sub-routine performs JavaScript code that clicks on the element of a specific id
to clickID(theId)
	tell application "Safari" to do JavaScript "document.getElementById('" & theId & "').click();" in document 1
end clickID

-- this sub-routine performs JavaScript code that clicks on the element of a specific class
to clickClassName(theClassName, elementnum)
	tell application "Safari" to do JavaScript "document.getElementsByClassName('" & theClassName & "')[" & elementnum & "].click();" in document 1
end clickClassName