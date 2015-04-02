
#define HOOK_SECURITY(RET, ...) HOOK_FUNCTION(RET, /System/Library/Frameworks/Security.framework/Security, __VA_ARGS__)

//
HOOK_SECURITY(OSStatus, SSLRead, SSLContextRef context, void *data, size_t dataLength, size_t *processed)
{
	OSStatus ret = _SSLRead(context, data, dataLength, processed);
	_LogData(data, dataLength);
	return ret;
}

//
HOOK_SECURITY(OSStatus, SSLWrite, SSLContextRef context, const void *data, size_t dataLength, size_t *processed)
{
	OSStatus ret = _SSLWrite(context, data, dataLength, processed);
	_LogData(data, dataLength);
	return ret;
}

//
HOOK_SECURITY(OSStatus, SSLSetSessionOption, SSLContextRef context, SSLSessionOption option, Boolean value)
{
    // Remove the ability to modify the value of the kSSLSessionOptionBreakOnServerAuth option
    if (option == kSSLSessionOptionBreakOnServerAuth)
        return noErr;
    else
        return _SSLSetSessionOption(context, option, value);
}

//
HOOK_SECURITY(SSLContextRef, SSLCreateContext, CFAllocatorRef allocator, SSLProtocolSide protocolSide, SSLConnectionType connectionType)
{
	SSLContextRef ret = _SSLCreateContext(allocator, protocolSide, connectionType);
    
    // Immediately set the kSSLSessionOptionBreakOnServerAuth option in order to disable cert validation
    _SSLSetSessionOption(ret, kSSLSessionOptionBreakOnServerAuth, true);
    return ret;
}

//
HOOK_SECURITY(OSStatus, SSLHandshake, SSLContextRef context)
{
	OSStatus ret = _SSLHandshake(context);
    return (ret == errSSLServerAuthCompleted) ? _SSLHandshake(context) : ret;
}
