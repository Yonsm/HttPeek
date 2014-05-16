
#import "HookMain.h"

//
MSGHOOK(id, NSURLConnection_initWithRequest, NSURLRequest *request, id delegate)
{
	id ret = _NSURLConnection_initWithRequest(self, sel, request, delegate);
	_LogRequest(request);
	return ret;
} ENDHOOK

//
MSGHOOK(NSURLConnection *, NSURLConnection_connectionWithRequest, NSURLRequest *request, NSURLRequest **outRequest)
{
	_Log(@"NSURLConnection_connectionWithRequest: %@ <%@>", self, request);
	_LogRequest(request);
	_LineLog();
	NSURLConnection *ret = _NSURLConnection_connectionWithRequest(self, sel, request, outRequest);
	if (outRequest) _LogRequest(*outRequest);
	_LineLog();
	return ret;
} ENDHOOK

//
MSGHOOK(NSData *, NSURLConnection_sendSynchronousRequest, NSURLRequest *request, NSURLResponse **reponse, NSError **error)
{
	_Log(@"NSURLConnection_sendSynchronousRequest: %@ <%@>", self, request);
	_LogRequest(request);
	NSData *ret = _NSURLConnection_sendSynchronousRequest(self, sel, request, reponse, error);
	return ret;
} ENDHOOK

//
MSGHOOK(void *, NSURLConnection_start)
{
	_Log(@"NSURLConnection_start: %@", self);

	void *ret = _NSURLConnection_start(self, sel);
	_LogRequest([self currentRequest]);
	return ret;
} ENDHOOK

//
void ConnectionPeekInit(NSString *processName)
{
	_HOOKMSG(NSURLConnection_start, NSURLConnection, start);
	_HOOKMSG(NSURLConnection_initWithRequest, NSURLConnection, initWithRequest:delegate:);
	
	_HOOKCLS(NSURLConnection_connectionWithRequest, NSURLConnection, connectionWithRequest:delegate:);
	_HOOKCLS(NSURLConnection_sendSynchronousRequest, NSURLConnection, sendSynchronousRequest:returningResponse:error:);
	
	//_MSHookMessageEx([NSURLConnection class], @selector(setHTTPBody:), (IMP)MySetHTTPBody, (IMP *)&pSetHTTPBody);
	//_MSHookMessageEx([NSURLConnection class], @selector(initWithRequest: delegate: usesCache: maxContentLength: startImmediately: connectionProperties:), (IMP)MyInitWithRequest2, (IMP *)&pInitWithRequest2);
	//_MSHookMessageEx([NSURLConnection class], @selector(initWithRequest: delegate: startImmediately: connectionProperties:), (IMP)MyInitWithRequest3, (IMP *)&pInitWithRequest3);
	//_MSHookMessageEx([NSURLConnection class], @selector(initWithCFURLRequest:), (IMP)MyInitWithCFURLRequest, (IMP *)&pInitWithCFURLRequest);
}
