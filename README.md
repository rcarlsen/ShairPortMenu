ShairPortMenu v0.1
==================
Robert Carlsen | robertcarlsen.net
[Announcement and binary](http://robertcarlsen.net/2011/04/17/weekend-project-shairport-menulet-1365)

Description
-----------
A simple OS X status bar menu wrapper for ShairPort / HairTunes

ShairPort is an open source AirPort Express emulator.
Read more about ShairPort / HairTunes at the github site:

[https://github.com/albertz/shairport](https://github.com/albertz/shairport)

The above shairport repo is included as a submodule in this project. You will have to run:
    $ git submodule init
    $ git submodule update
to initialize the submodule and checkout the latest files in your local copy of this repo.
Follow the building instructions for ShairPort and hairtunes at the above link.

Building
--------
The Xcode project is pretty straightforward. Try to build and run and see what happens. 
Most of my cocoa experience is in iOS dev, so please forgive any glaring desktop cocoa 
snafus (though, kindly point out my folly so I can learn).

You should probably ensure that shairport.pl runs correctly on your system when 
launched standalone before troubleshooting issues with this menu widget.

Cheers!
-Robert

