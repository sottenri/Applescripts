(*
Author: Stuart Ottenritter
Date Created: 2018-10-01
Description: Run an Applescript 
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
- This Applescript snippet runs another Applescript.
- Applescripts are commonly saved to the ~/Library/Scripts/ folder; if true, replace "EnterPathToYourApplescriptHere.scpt" with the POSIX path to your Applescript.
*)

try
	run script POSIX file (POSIX path of (path to library folder from user domain) & "/Scripts/EnterPathToYourApplescriptHere.scpt")
on error errMsg
	display alert errMsg as informational giving up after 6
	error number -128
end try