## Watch a folder and display the file system change events (FSEvents) on macOS

Simple macOS app that allows you to choose a folder to watch for file system change events (FSEvents) and displays the events.  It uses the [CDEvents](https://github.com/rastersize/CDEvents) cocoapod to interface with FSEvents.  It was written using [RubyMotion](http://www.rubymotion.com).

### Installation

A built application can be found in the `bin` folder.  If you have RubyMotion installed, then you can change to the folder and run `rake` from the command line.

### Using the program

After starting the app, click the `Watch Folder` button and choose a folder to monitor.
You can then make changes to the folder and see the output.

For example, `vim /Users/myuser/Google Drive/Google Drive Test Data/test.txt` will generate
the following output:

```
Watching: /Users/myuser/Google Drive/Google Drive Test Data
------------------------------------------------------------------------------

FSEvent :     path: /Users/myuser/Google Drive/Google Drive Test Data/.test.txt.swx
        : file ref: 
        : ref path: 
        :    flags: 66304 (isCreated, isRemoved, isFile)

FSEvent :     path: /Users/myuser/Google Drive/Google Drive Test Data/.test.txt.swp
        : file ref: file:///.file/id=6571367.9507634
        : ref path: /Users/myuser/Google Drive/Google Drive Test Data/.test.txt.swp
        :    flags: 66304 (isCreated, isRemoved, isFile)

FSEvent :     path: /Users/myuser/Google Drive/Google Drive Test Data/test.txt
        : file ref: file:///.file/id=6571367.9507635
        : ref path: /Users/myuser/Google Drive/Google Drive Test Data/test.txt
        :    flags: 69888 (isCreated, isFile, isModified)

FSEvent :     path: /Users/myuser/Google Drive/Google Drive Test Data/.test.txt.swp
        : file ref: 
        : ref path: 
        :    flags: 70400 (isCreated, isRemoved, isFile, isModified)
```