
//
HOOK_FUNCTION(CFReadStreamRef, /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFReadStreamCreateForHTTPRequest, CFAllocatorRef alloc, CFHTTPMessageRef request)
{
	NSLog(@"%s: %p", __FUNCTION__, request);
	return _CFReadStreamCreateForHTTPRequest(alloc, request);
}

//
HOOK_FUNCTION(CFDictionaryRef, /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFURLRequestCopyAllHTTPHeaderFields, id request)
{
	NSLog(@"%s: %p", __FUNCTION__, request);
	return _CFURLRequestCopyAllHTTPHeaderFields(request);
}
