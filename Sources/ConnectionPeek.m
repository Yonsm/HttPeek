

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
	_LogRequest(request);
	NSURLConnection *ret = _NSURLConnection_connectionWithRequest_delegate_(self, sel, request, delegate);
	return ret;
}

//
HOOK_MESSAGE(NSData *, NSURLConnection, sendSynchronousRequest_returningResponse_error_, NSURLRequest *request, NSURLResponse **reponse, NSError **error)
{
	_LogRequest(request);
	NSData *data = _NSURLConnection_sendSynchronousRequest_returningResponse_error_(self, sel, request, reponse, error);
	if (reponse)
	{
		_LogResponse(*reponse, data);
	}
	return data;
}

//
/*
 HOOK_MESSAGE(void *, NSURLConnection, start)
 {
	_Log(@"%s: %@", __FUNCTION__, self);
 
	void *ret = _NSURLConnection_start(self, sel);
	_LogRequest([self currentRequest]);
	return ret;
 }*/
