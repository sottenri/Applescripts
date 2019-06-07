(*
Author: Stuart Ottenritter
Date Created: 2018-10-30
Description: Copy track details of an iTunes user playlist to the clipboard.
Note: 
- Tested on macOS Mojave Version 10.14.5. Code is not reliably maintained.
*)

-- choose playlist
tell application "iTunes"
	activate
	delay 1
	set user_playlist_names to name of user playlists whose special kind is none
	set this_playlist_name to Â
		(choose from list user_playlist_names with prompt "Choose a Playlist" without multiple selections allowed) as string
	reveal playlist this_playlist_name
	set playlist_time to time of playlist this_playlist_name
	set these_tracks to tracks of playlist this_playlist_name
end tell

-- build and copy the playlist to the clipboard
set the_list to ""
repeat with i from 1 to count of these_tracks
	set counter to i
	if counter is less than 10 then set counter to "0" & (i as string)
	set this_track to item i of these_tracks
	tell application "iTunes" to set {name:t_name, artist:t_art, year:t_year} to this_track
	if t_year is greater than 0 then
		set t_year to " (" & t_year & ")"
	else
		set t_year to ""
	end if
	set the_entry to (counter as string) & ". \"" & t_name & "\" by " & t_art & t_year
	set the_list to the_list & linefeed & the_entry
end repeat
set printout to this_playlist_name & ": " & (i as string) & " Tracks | " & playlist_time & " Runtime" & linefeed & the_list
set the clipboard to printout as string
display notification "Copied to Clipboard" with title "iTunes | Print Playlist" subtitle this_playlist_name