
#import "HookMain.h"

//
FUNHOOK(OSStatus, SSLRead, SSLContextRef context, void *data, size_t dataLength, size_t *processed)
{
	OSStatus ret = _SSLRead(context, data, dataLength, processed);
	_LogData(data, dataLength);
	return ret;
}
ENDHOOK

//
FUNHOOK(OSStatus, SSLWrite, SSLContextRef context, const void *data, size_t dataLength, size_t *processed)
{
	OSStatus ret = _SSLWrite(context, data, dataLength, processed);
	_LogData(data, dataLength);
	return ret;
} ENDHOOK

//
void SSLPeekInit(NSString *processName)
{
	_HOOKFUN(/System/Library/Frameworks/Security.framework/Security, SSLRead);
	_HOOKFUN(/System/Library/Frameworks/Security.framework/Security, SSLWrite);
}
