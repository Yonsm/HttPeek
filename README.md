
HttPeek
======

iOS HTTP/SSL/URL Peeker

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
4. kill -s KILL xxxx(itunesstored's pid)

Now itunesstored will restart automatically with injection of HttPeek.dylib.
