

//
HOOK_MESSAGE(id, NSURLConnection, initWithRequest_delegate_, NSURLRequest *request, id delegate)
{
	id ret = _NSURLConnection_initWithRequest_delegate_(self, sel, request, delegate);
	_LogRequest(request);
	return ret;
}

//
HOOK_MESSAGE(NSURLConnection *, NSURLConnection, connectionWithRequest_delegate_, NSURLRequest *request, id delegate)
{
	_Log(@"%s: %@ <%@>", __FUNCTION__, self, request);
	_LogRequest(request);
	_LogLine();
	NSURLConnection *ret = _NSURLConnection_connectionWithRequest_delegate_(self, sel, request, delegate);
	//if (outRequest) _LogRequest(*outRequest);
	_LogLine();
	return ret;
}

//
HOOK_MESSAGE(NSData *, NSURLConnection, sendSynchronousRequest_returningResponse_error_, NSURLRequest *request, NSURLResponse **reponse, NSError **error)
{
	_Log(@"%s: %@ <%@>", __FUNCTION__, self, request);
	_LogRequest(request);
	NSData *ret = _NSURLConnection_sendSynchronousRequest_returningResponse_error_(self, sel, request, reponse, error);
	return ret;
}

//
HOOK_MESSAGE(void *, NSURLConnection, start)
{
	_Log(@"%s: %@", __FUNCTION__, self);

	void *ret = _NSURLConnection_start(self, sel);
	_LogRequest([self currentRequest]);
	return ret;
}
