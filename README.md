
HttPeek
======

iOS/macOS HTTP(S)/SSL Network Traffic Peeker

Worked for NSURLConnection/NSURLSession/SSLRead/SSLWrite network traffic.

<http://yonsm.net/httpeek/>

# Download

<https://github.com/Yonsm/HttPeek/raw/master/Release/HttPeek.dylib>

# FAQ

## How to track AppStore's traffic on iOS?

1. Install OpenSSH from Cydia;
2. Install adv-cmds from Cydia;
3. ps ax|grep itunesstored
4. killall -s KILL xxxx(itunesstored's pid)

  Now itunesstored will restart automatically with injection of HttPeek.dylib.


## How to peek HTTP(S) on macOS

1. Download <https://github.com/Yonsm/HttPeek/raw/master/Release/HttPeex.dylib> to a folder (e.g. /Applications/HttPeex.dylib);
2. Launch your process with HttPeex.dylib inserted:

	DYLD_PRINT_LIBRARIES=1 X=1 DYLD_INSERT_LIBRARIES=/Applications/HttPeex.dylib /Applications/QQ.app/Contents/MacOS/QQ

  But it could not work for "library validated process" (e.g. System Apps).


## How to debug HttPeex on macOS

1. Edit scheme on Xcode;
2. Run -> Info -> Executable: Ask on Launch;
3. Run -> Info -> Arguments -> Environment Variables:

	DYLD_PRINT_LIBRARIES=1

	X=1

	DYLD_INSERT_LIBRARIES=$CODESIGNING_FOLDER_PATH

 4. Just Run & Debug, select any application you want to peek.
