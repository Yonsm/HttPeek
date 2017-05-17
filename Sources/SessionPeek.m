
//
/*
HOOK_MESSAGE(void, NSURLSessionTask, resume)
{
	NSLog(@"%s: %@", __FUNCTION__, self);

	_NSURLSessionTask_resume(self, sel);
	_LogRequest([self currentRequest]);
}
 */
#ifdef _ForceProxy
//
_HOOK_MESSAGE(void, ASTNetworking, URLSession_task_didReceiveChallenge_completionHandler_, NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))
{
	_LogLine();
	completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

HOOK_META(NSURLSession *, NSURLSession, sessionWithConfiguration_delegate_delegateQueue_, NSURLSessionConfiguration *configuration, id <NSURLSessionDelegate> delegate, NSOperationQueue * queue)
{
#define proxyHost @"192.168.1.3"
#define proxyPort @8888
	
	NSDictionary *proxyDict = @{
								@"HTTPEnable"  : @YES,
								(NSString *)kCFStreamPropertyHTTPProxyHost  : proxyHost,
								(NSString *)kCFStreamPropertyHTTPProxyPort  : proxyPort,
								
								@"HTTPSEnable" : @YES,
								(NSString *)kCFStreamPropertyHTTPSProxyHost : proxyHost,
								(NSString *)kCFStreamPropertyHTTPSProxyPort : proxyPort,
								};

	_LogLine();
	configuration.connectionProxyDictionary = proxyDict;
	
	NSLog(@"delegate: %@", delegate);
	
	void *old;
	_HookMessage([(NSObject *)delegate class], "URLSession_task_didReceiveChallenge_completionHandler_", (void *)$ASTNetworking_URLSession_task_didReceiveChallenge_completionHandler_, &old);

	return _NSURLSession_sessionWithConfiguration_delegate_delegateQueue_(self, sel, configuration, delegate, queue);
}
#endif

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithRequest_, NSURLRequest *request)
{
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_dataTaskWithRequest_(self, sel, request);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithURL_, NSURL *url)
{
	_LogLine();
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_dataTaskWithURL_(self, sel, url);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromFile_, NSURLRequest *request, NSURL *fileURL)
{
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_uploadTaskWithRequest_fromFile_(self, sel, request, fileURL);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromData_, NSURLRequest *request, NSData *bodyData)
{
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_uploadTaskWithRequest_fromData_(self, sel, request, bodyData);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithStreamedRequest_, NSURLRequest *request)
{
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_uploadTaskWithStreamedRequest_(self, sel, request);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithRequest_, NSURLRequest *request)
{
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_downloadTaskWithRequest_(self, sel, request);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithURL_, NSURL *url)
{
	_LogLine();
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_downloadTaskWithURL_(self, sel, url);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithResumeData_, NSData *resumeData)
{
	_LogLine();
	
	//_LogRequest([]);
	return _NSURLSession_downloadTaskWithResumeData_(self, sel, resumeData);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, streamTaskWithHostName_port_, NSString *hostname, NSInteger port)
{
	_LogLine();
	//_LogRequest(request);
	return _NSURLSession_streamTaskWithHostName_port_(self, sel, hostname, port);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, streamTaskWithNetService_, NSNetService *service)
{
	_LogLine();
	//_LogRequest(request);
	return _NSURLSession_streamTaskWithNetService_(self, sel, service);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithRequest_completionHandler_, NSURLRequest *request, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	__block void (^completionHandler0)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) = completionHandler;
	
	void (^completionHandler2)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) =
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		_LogLine();
		_LogData(data.bytes, data.length);
		return completionHandler0(data, response, error);
	};
	
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_dataTaskWithRequest_completionHandler_(self, sel, request, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithURL_completionHandler_, NSURL *url, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_dataTaskWithURL_completionHandler_(self, sel, url, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromFile_completionHandler_, NSURLRequest *request, NSURL *fileURL, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_uploadTaskWithRequest_fromFile_completionHandler_(self, sel, request, fileURL, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromData_completionHandler_, NSURLRequest *request, NSData *bodyData, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_uploadTaskWithRequest_fromData_completionHandler_(self, sel, request, bodyData, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithRequest_completionHandler_, NSURLRequest *request, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	_LogRequest(request);
	return _NSURLSession_downloadTaskWithRequest_completionHandler_(self, sel, request, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithURL_completionHandler_, NSURL *url, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_downloadTaskWithURL_completionHandler_(self, sel, url, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithResumeData_completionHandler_, NSData *resumeData, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	//_LogRequest(request);
	return _NSURLSession_downloadTaskWithResumeData_completionHandler_(self, sel, resumeData, completionHandler);
}

