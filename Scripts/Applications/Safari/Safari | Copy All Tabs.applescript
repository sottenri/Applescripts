(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Copy the URL of every tab, a list of those URLs, and a list of those URLs in markdown to the clipboard. Note, this is designed to work with a clipboard manager, such as Copied by Kevin Chang (https://itunes.apple.com/us/app/copied/id1026349850). The clipboard manager records the input of every copy command for later use.
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

set tab_list to {}
set tab_md_list to {}
tell application "Safari"
	activate
	set open_tabs to tabs of the front window
	repeat with each_tab in open_tabs
		set {URL:tab_url, name:tab_name} to each_tab
		set the clipboard to tab_url
		set tab_list to tab_list & return & tab_url
		set the tab_markdown to "[" & tab_name & "](" & tab_url & ")"
		set tab_md_list to tab_md_list & return & tab_markdown
		delay 0.5
	end repeat
end tell
set the clipboard to tab_list as Unicode text
delay 0.5
set the clipboard to tab_md_list as Unicode text