(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Prepend or Append the selected text to the Clipboard content. 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- This Applescript snippet is meant to run within an Automator Quick Action workflow (formerly known as a Service).
- The Automator workflow receives text in any application as input. The input is passed to the Run Applescript action, which runs this snippet.
- Common method of use: Secondary click text and navigate to Services.
*)

(*

IMPORTANT

Insert code within the Run Applescript action of Automator; replace the action's default code.

*)

on run {input, parameters}
	
	set newclipboard to ""
	set additionaltxt to input
	set theclipboard to the clipboard
	set answer to the button returned of Â
		(display dialog "Prepend or Append?" buttons {"Prepend", "Append", "Cancel"} default button 2 cancel button 3 with icon note giving up after 12)
	if answer is "Prepend" then
		set newclipboard to additionaltxt & return & theclipboard
		display notification "Selection has been " & answer & "ed to the Clipboard" with title "Clipboard Update"
	else if answer is "Append" then
		set newclipboard to theclipboard & return & additionaltxt
		display notification "Selection has been " & answer & "ed to the Clipboard" with title "Clipboard Update"
	else
		error number -128
	end if
	set the clipboard to newclipboard as text
	set input to newclipboard
	
	return input
end run