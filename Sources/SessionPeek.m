
//
NSURLRequest *replaceRequest(NSURLRequest *request);

//
HOOK_META(NSURLSession *, NSURLSession, sessionWithConfiguration_delegate_delegateQueue_, NSURLSessionConfiguration *configuration, id <NSURLSessionDelegate> delegate, NSOperationQueue * queue)
{
	Dl_info info = {0};
	void *returnAddress = __builtin_return_address(0);
	dladdr(returnAddress, &info);
	
	NSString *str = [NSString stringWithFormat:@"FROM %s(%p)-%s(%p=>%#08lx)\n<%@>\n\n", info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr, (long)info.dli_saddr-(long)info.dli_fbase-0x1000, [NSThread callStackSymbols]];
	NSLog(@"HTTPEEK sessionWithConfiguration: %@\n", str);
	
	NSLog(@"delegate: %@", delegate);
	
	return _NSURLSession_sessionWithConfiguration_delegate_delegateQueue_(self, sel, configuration, delegate, queue);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithRequest_, NSURLRequest *request)
{
	_LogLine();
	return _NSURLSession_dataTaskWithRequest_(self, sel, replaceRequest(request));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithURL_, NSURL *url)
{
	_LogLine();
	replaceRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_dataTaskWithURL_(self, sel, url);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromFile_, NSURLRequest *request, NSURL *fileURL)
{
	_LogLine();
	return _NSURLSession_uploadTaskWithRequest_fromFile_(self, sel, replaceRequest(request), fileURL);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromData_, NSURLRequest *request, NSData *bodyData)
{
	_LogLine();
	return _NSURLSession_uploadTaskWithRequest_fromData_(self, sel, replaceRequest(request), bodyData);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithStreamedRequest_, NSURLRequest *request)
{
	_LogLine();
	return _NSURLSession_uploadTaskWithStreamedRequest_(self, sel, replaceRequest(request));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithRequest_, NSURLRequest *request)
{
	_LogLine();
	return _NSURLSession_downloadTaskWithRequest_(self, sel, replaceRequest(request));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithURL_, NSURL *url)
{
	_LogLine();
	replaceRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_downloadTaskWithURL_(self, sel, url);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithResumeData_, NSData *resumeData)
{
	_LogLine();
	return _NSURLSession_downloadTaskWithResumeData_(self, sel, resumeData);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, streamTaskWithHostName_port_, NSString *hostname, NSInteger port)
{
	_LogLine();
	return _NSURLSession_streamTaskWithHostName_port_(self, sel, hostname, port);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, streamTaskWithNetService_, NSNetService *service)
{
	_LogLine();
	return _NSURLSession_streamTaskWithNetService_(self, sel, service);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithRequest_completionHandler_, NSURLRequest *request, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	_Log(@"completionHandler:%@", completionHandler);
	return _NSURLSession_dataTaskWithRequest_completionHandler_(self, sel, replaceRequest(request), completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithURL_completionHandler_, NSURL *url, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	replaceRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_dataTaskWithURL_completionHandler_(self, sel, url, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromFile_completionHandler_, NSURLRequest *request, NSURL *fileURL, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	return _NSURLSession_uploadTaskWithRequest_fromFile_completionHandler_(self, sel, replaceRequest(request), fileURL, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromData_completionHandler_, NSURLRequest *request, NSData *bodyData, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	return _NSURLSession_uploadTaskWithRequest_fromData_completionHandler_(self, sel, replaceRequest(request), bodyData, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithRequest_completionHandler_, NSURLRequest *request, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	return _NSURLSession_downloadTaskWithRequest_completionHandler_(self, sel, replaceRequest(request), completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithURL_completionHandler_, NSURL *url, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	replaceRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_downloadTaskWithURL_completionHandler_(self, sel, url, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithResumeData_completionHandler_, NSData *resumeData, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	return _NSURLSession_downloadTaskWithResumeData_completionHandler_(self, sel, resumeData, completionHandler);
}

//
NSURLRequest *replaceRequest(NSURLRequest *request)
{
	_LogRequest(request);
	
	NSString *url = [[request URL] absoluteString];
	if ([url rangeOfString:@"https://idiagnostics.apple.com"].location != NSNotFound)
	{
		_LogLine();
		
		NSMutableURLRequest *request2 = request.mutableCopy;
		url = [url stringByReplacingOccurrencesOfString:@"https://idiagnostics.apple.com" withString:@"http://192.168.1.3:8080"];
		request2.URL = [NSURL URLWithString:url];
		[request2 setValue:@"" forHTTPHeaderField:@"If-None-Match"];
		_LogLine();
		return request2;
	}
	
	_LogLine();
	return request;
	
	
	//#define _replaceRequest
#ifdef _replaceRequest
	dispatch_after(60, dispatch_get_main_queue(), ^{
		//dispatch_async(dispatch_get_main_queue(), ^{
		NSDictionary *proxyDict = @{
									@"HTTPEnable"  : @YES,
									(NSString *)kCFStreamPropertyHTTPProxyHost  : proxyHost,
									(NSString *)kCFStreamPropertyHTTPProxyPort  : proxyPort,
									
									@"HTTPSEnable" : @YES,
									(NSString *)kCFStreamPropertyHTTPSProxyHost : proxyHost,
									(NSString *)kCFStreamPropertyHTTPSProxyPort : proxyPort,
									};
		
		
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"XXXxx"];
		configuration.connectionProxyDictionary = proxyDict;
		NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:configuration];
		
		NSURLSessionDataTask *dataTask = _NSURLSession_dataTaskWithRequest_completionHandler_(defaultSession, @selector(dataTaskWithRequest:), request, nil);
		
		[dataTask resume];
	});
#endif
}
