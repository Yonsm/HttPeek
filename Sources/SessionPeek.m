
typedef void (^NSURLSessionTaskHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

//
@interface ReplaceTaskHandler: NSObject <NSURLSessionDelegate>
{
	NSURLSessionTaskHandler _origionalHandler;
}
@end

//
@implementation ReplaceTaskHandler

- (instancetype)initWithHandler:(NSURLSessionTaskHandler)handler
{
	self = [super init];
	
	NSLog(@"completionHandler: %p", handler);
	_origionalHandler = handler;
	return self;
};

- (NSURLSessionTaskHandler)replacedHandler
{
	CFBridgingRetain(self);
	
	NSURLSessionTaskHandler replacedHandler =
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		_LogLine();
		_LogObj(response);
		_LogData(data.bytes, data.length);
		if (_origionalHandler)
		{
			_origionalHandler(data, response, error);
			_LogLine();
		}
		CFBridgingRelease((__bridge CFTypeRef)self);
	};
	return replacedHandler;
}

@end

#define _ReplaceHandler(handler) [[[ReplaceTaskHandler alloc] initWithHandler:handler] replacedHandler]

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
