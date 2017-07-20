
HttPeek
======

iOS/macOS HTTP(S)/SSL Peeker

#Introduce

<http://yonsm.net/httpeek/>

#Download

<https://github.com/Yonsm/HttPeek/raw/master/Release/HttPeek.dylib>

#History

TBD...

#How to track AppStore's traffic?

1. Install OpenSSH from Cydia;
2. Install adv-cmds from Cydia;
3. ps ax|grep itunesstored
4. killall -s KILL xxxx(itunesstored's pid)

Now itunesstored will restart automatically with injection of HttPeek.dylib.


#How to peek HTTP(S) on macOS

1. Download <https://github.com/Yonsm/HttPeek/raw/master/Release/HttPeex.dylib> to a folder (e.g. /Applications/HttPeex.dylib);
2. Launch your process with HttPeex.dylib inserted:
   
`DYLD_PRINT_LIBRARIES=1 X=1 DYLD_INSERT_LIBRARIES=/Applications/HttPeex.dylib /Applications/QQ.app/Contents/MacOS/QQ`

But it could not work for "library validated process" (e.g. System Apps).
