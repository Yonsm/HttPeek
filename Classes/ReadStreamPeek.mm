
#import "HookMain.h"

//
FUNHOOK(CFReadStreamRef, CFReadStreamCreateForHTTPRequest, CFAllocatorRef alloc, CFHTTPMessageRef request)
{
	NSLog(@"CFReadStreamCreateForHTTPRequest: %p", request);
	return _CFReadStreamCreateForHTTPRequest(alloc, request);
} ENDHOOK

//
FUNHOOK(CFDictionaryRef, CFURLRequestCopyAllHTTPHeaderFields, id request)
{
	NSLog(@"CFURLRequestCopyAllHTTPHeaderFields: %p", request);
	return _CFURLRequestCopyAllHTTPHeaderFields(request);
} ENDHOOK


//
void ReadStreamPeekInit(NSString *processName)
{
	_HOOKFUN(/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFReadStreamCreateForHTTPRequest);
	_HOOKFUN(/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFURLRequestCopyAllHTTPHeaderFields);
}
