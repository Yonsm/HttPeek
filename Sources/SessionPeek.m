
//
@interface CompletionHandler: NSObject <NSURLSessionDelegate>
{
	void (^_completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);
}

@end

//
@implementation CompletionHandler

- (instancetype)initWithHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
	self = [super init];
	
	NSLog(@"completionHandler: %p", completionHandler);
	_completionHandler = completionHandler;
	return self;
};

- (void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))newCompletionHandler
{
	CFBridgingRetain(self);
	void (^newCompletionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) =
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		_LogLine();
		_LogObj(response);
		_LogData(data.bytes, data.length);
		_LogLine();
		
		if (_completionHandler)
		{
			_completionHandler(data, response, error);
			_LogLine();
		}
		else
			_LogLine();
		
		//CFBridgingRelease((__bridge CFTypeRef)self);
	};
	return newCompletionHandler;
}

@end

#define _ReplaceHandler(handler) [[[CompletionHandler alloc] initWithHandler:handler] newCompletionHandler]

//
HOOK_META(NSURLSession *, NSURLSession, sessionWithConfiguration_delegate_delegateQueue_, NSURLSessionConfiguration *configuration, id <NSURLSessionDelegate> delegate, NSOperationQueue * queue)
{
	_LogLine();
	if (delegate)
	{
		_LogObj(delegate);
		_LogStack();
	}
	return _NSURLSession_sessionWithConfiguration_delegate_delegateQueue_(self, sel, configuration, delegate, queue);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithRequest_, NSURLRequest *request)
{
	_LogLine();
	return _NSURLSession_dataTaskWithRequest_(self, sel, _LogRequest(request));
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
	return _NSURLSession_uploadTaskWithRequest_fromFile_(self, sel, _LogRequest(request), fileURL);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromData_, NSURLRequest *request, NSData *bodyData)
{
	_LogLine();
	return _NSURLSession_uploadTaskWithRequest_fromData_(self, sel, _LogRequest(request), bodyData);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithStreamedRequest_, NSURLRequest *request)
{
	_LogLine();
	return _NSURLSession_uploadTaskWithStreamedRequest_(self, sel, _LogRequest(request));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithRequest_, NSURLRequest *request)
{
	_LogLine();
	return _NSURLSession_downloadTaskWithRequest_(self, sel, _LogRequest(request));
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
	return _NSURLSession_dataTaskWithRequest_completionHandler_(self, sel, _LogRequest(request), _ReplaceHandler(completionHandler));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithURL_completionHandler_, NSURL *url, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_dataTaskWithURL_completionHandler_(self, sel, url, _ReplaceHandler(completionHandler));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromFile_completionHandler_, NSURLRequest *request, NSURL *fileURL, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	return _NSURLSession_uploadTaskWithRequest_fromFile_completionHandler_(self, sel, _LogRequest(request), fileURL, _ReplaceHandler(completionHandler));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromData_completionHandler_, NSURLRequest *request, NSData *bodyData, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	return _NSURLSession_uploadTaskWithRequest_fromData_completionHandler_(self, sel, _LogRequest(request), bodyData, _ReplaceHandler(completionHandler));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithRequest_completionHandler_, NSURLRequest *request, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	return _NSURLSession_downloadTaskWithRequest_completionHandler_(self, sel, _LogRequest(request), completionHandler);
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
	return _NSURLSession_downloadTaskWithResumeData_completionHandler_(self, sel, resumeData, completionHandler);
}
