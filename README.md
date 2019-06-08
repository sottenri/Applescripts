# AppleScript

*Note: These scripts were last modified in May of 2019; at the time compatible with macOS Mojave Version 10.14.5. This collection is **not** reliably maintained.*

### Most Used Scripts
* [Center Window](./Scripts/Center%20Window.applescript)
* [PDF | Inbox Outbox Archive](./Scripts/Folder%20Action%20Scripts/PDF%20|%20Inbox%20Outbox%20Archive.applescript)
* [Photos | Date Adjustment](./Scripts/Applications/Photos/Photos%20|%20Date%20Adjustment.applescript)
* [iTunes | Pause At End](./Scripts/Applications/iTunes/iTunes%20|%20Pause%20At%20End.applescript)

### Application Specific Scripts
* [Contacts](./Scripts/Applications/Contacts)
* [iTunes](./Scripts/Applications/iTunes)
* [Mail](./Scripts/Applications/Mail)
* [Messages](./Scripts/Applications/Messages)
* [Photos](./Scripts/Applications/Photos)
* [Safari](./Scripts/Applications/Safari)

### Scripts Used with Automator
* [See All Automator Related Scripts](./Scripts/Automator)

### Scripts for Folder Actions
* [See All Folder Action Scripts](./Scripts/Folder%20Action%20Scripts)

#### Applications Used in Some Applescripts
* [Copied by Kevin Chang](https://copiedapp.com)
* [Google Chrome](https://www.google.com/chrome/)
* [Firefox](https://www.mozilla.org/en-US/firefox/)
* [Brave Browser](https://brave.com)
* [Adobe Acrobat](https://acrobat.adobe.com/us/en/acrobat/pdf-reader.html)

---

## About Applescript
>AppleScript is a scripting language that makes possible direct control of scriptable applications and of many parts of the Mac OS. A scriptable application is one that makes its operations and data available in response to AppleScript messages, called Apple events. — [Introduction to AppleScript Overview](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptX/AppleScriptX.html)

### Show Script Menu in Menu Bar
Quickly access scripts in the macOS menu bar. Check the "Show Script menu in menu bar" option in the Script Editor preferences. 
* AppleScripts that are saved to the `~/Library/Scripts/` folder in the users library will appear in the menu bar drop down. 
* Save application specific scripts in the corresponding folders; e.g. Safari scripts in `~/Library/Scripts/Applications/Safari/your_safari_script.scpt` or Photos scripts in `~/Library/Scripts/Applications/Photos/your_photos_script.scpt`. These scripts will be shown in the Script menu bar drop down when the corresponding application is active.

Read More:
* [How to enable the AppleScript menu on the Mac OS X menu bar | alvinalexander.com](https://alvinalexander.com/mac-os-x/how-to-show-applescript-menu-item-mac-osx-menu-bar)
* [Where to save your custom AppleScript programs | alvinalexander.com](https://alvinalexander.com/blog/post/mac-os-x/where-put-applescript-program-script-directory-folder)

### Folder Actions
>Folder Actions is a feature of macOS that lets you associate AppleScript scripts with folders. A Folder Action script is executed when the folder to which it is attached has items added or removed, or when its window is opened, closed, moved, or resized. The script provides a handler that matches the appropriate format for the action, as described in this chapter.
>
>Folder Actions make it easy to create hot folders that respond to external actions to trigger a workflow. [...]
>
>Folder Actions Setup looks for scripts located in `/Library/Scripts/Folder Action Scripts` and `~/Library/Scripts/Folder Action Scripts`. — [Folder Actions Reference](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_folder_actions.html)

### Combine AppleScript with Automator
Some Applescripts are best when run within an Automator Quick Action workflow; formerly called a Service. Scripts meant to run within or be launched by Automator are located in the [Automator](./Scripts/Automator) folder. Quick Action workflows can be accessed in the Finder window, Services menu, Touch Bar, and most notably can be assigned a **keystroke shortcut**. 

>"If the task you need to automate isn’t in the list of built-in actions, you can add your own scripts, such as AppleScript and JavaScript scripts, and shell commands to your workflow. Simply add the appropriate run script action to your workflow and enter your script code or shell commands."  — [Welcome to Automator on Mac - Apple Support](https://support.apple.com/guide/automator/welcome/mac)

>”If you have a workflow you use frequently — for example, adding a watermark to large sets of images — and you want to make it easy to get to, you can create a Quick Action workflow. It will then be available from Finder windows, the Services menu, or the Touch Bar (on a Mac with a Touch Bar)." — [About Automator - Apple Support](https://support.apple.com/guide/automator/about-automator-aut6e8156d85/mac)

See the hyperlinks below for further instruction:
* [About Automator - Apple Support](https://support.apple.com/guide/automator/about-automator-aut6e8156d85/mac)
* [How to use services in Mac OS X | Macworld](https://www.macworld.com/article/1163996/how-to-use-services-in-mac-os-x.html)
* [Create keyboard shortcuts for apps on Mac - Apple Support](https://support.apple.com/guide/mac-help/create-keyboard-shortcuts-for-apps-mchlp2271/mac)

### Frequently Used Troubleshooting Hyperlinks
* [Coercion (Object Conversion) | AppleScript Fundamentals](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/conceptual/ASLR_fundamentals.html#//apple_ref/doc/uid/TP40000983-CH218-SW21)
* [Aliases and Files | AppleScript Fundamentals](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/conceptual/ASLR_fundamentals.html#//apple_ref/doc/uid/TP40000983-CH218-SW28)
* [Debugging | AppleScript Fundamentals](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/conceptual/ASLR_fundamentals.html#//apple_ref/doc/uid/TP40000983-CH218-SW20)