
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
FUNHOOK(OSStatus, SSLSetSessionOption, SSLContextRef context, SSLSessionOption option, Boolean value)
{
    // Remove the ability to modify the value of the kSSLSessionOptionBreakOnServerAuth option
    if (option == kSSLSessionOptionBreakOnServerAuth)
        return noErr;
    else
        return _SSLSetSessionOption(context, option, value);
} ENDHOOK

//
FUNHOOK(SSLContextRef, SSLCreateContext, CFAllocatorRef allocator, SSLProtocolSide protocolSide, SSLConnectionType connectionType)
{
	SSLContextRef ret = _SSLCreateContext(allocator, protocolSide, connectionType);
    
    // Immediately set the kSSLSessionOptionBreakOnServerAuth option in order to disable cert validation
    _SSLSetSessionOption(ret, kSSLSessionOptionBreakOnServerAuth, true);
    return ret;
} ENDHOOK

//
FUNHOOK(OSStatus, SSLHandshake, SSLContextRef context)
{
	OSStatus ret = _SSLHandshake(context);
    return (ret == errSSLServerAuthCompleted) ? _SSLHandshake(context) : ret;
} ENDHOOK

//
void SSLPeekInit(NSString *processName)
{
	_HOOKFUN(/System/Library/Frameworks/Security.framework/Security, SSLRead);
	_HOOKFUN(/System/Library/Frameworks/Security.framework/Security, SSLWrite);
	
	// SSL Kill
	_HOOKFUN(/System/Library/Frameworks/Security.framework/Security, SSLHandshake);
	_HOOKFUN(/System/Library/Frameworks/Security.framework/Security, SSLCreateContext);
	_HOOKFUN(/System/Library/Frameworks/Security.framework/Security, SSLSetSessionOption);
}
