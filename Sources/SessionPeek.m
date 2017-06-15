
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
	NSURLSessionTaskHandler replacedHandler =
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		_LogLine();
		_LogResponse(response, data);
		if (_origionalHandler)
		{
			_origionalHandler(data, response, error);
			_LogLine();
		}
	};
	if (!_origionalHandler) return nil;
	return replacedHandler;
}

@end

#define _ReplaceTaskHandler(handler) (/*[[self configuration] identifier] && !handler*/!handler) ? handler : [[[ReplaceTaskHandler alloc] initWithHandler:handler] replacedHandler]

//
#if 0
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
#endif

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithRequest_, NSURLRequest *request)
{
	return _NSURLSession_dataTaskWithRequest_(self, sel, _LogRequest(request));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithURL_, NSURL *url)
{
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_dataTaskWithURL_(self, sel, url);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromFile_, NSURLRequest *request, NSURL *fileURL)
{
	return _NSURLSession_uploadTaskWithRequest_fromFile_(self, sel, _LogRequest(request), fileURL);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromData_, NSURLRequest *request, NSData *bodyData)
{
	return _NSURLSession_uploadTaskWithRequest_fromData_(self, sel, _LogRequest(request), bodyData);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithStreamedRequest_, NSURLRequest *request)
{
	return _NSURLSession_uploadTaskWithStreamedRequest_(self, sel, _LogRequest(request));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithRequest_, NSURLRequest *request)
{
	return _NSURLSession_downloadTaskWithRequest_(self, sel, _LogRequest(request));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithURL_, NSURL *url)
{
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_downloadTaskWithURL_(self, sel, url);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithResumeData_, NSData *resumeData)
{
	return _NSURLSession_downloadTaskWithResumeData_(self, sel, resumeData);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, streamTaskWithHostName_port_, NSString *hostname, NSInteger port)
{
	return _NSURLSession_streamTaskWithHostName_port_(self, sel, hostname, port);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, streamTaskWithNetService_, NSNetService *service)
{
	return _NSURLSession_streamTaskWithNetService_(self, sel, service);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithRequest_completionHandler_, NSURLRequest *request, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_Log(@"dataTaskWithRequest_completionHandler_:%@", completionHandler);
	return _NSURLSession_dataTaskWithRequest_completionHandler_(self, sel, _LogRequest(request), _ReplaceTaskHandler(completionHandler));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, dataTaskWithURL_completionHandler_, NSURL *url, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_dataTaskWithURL_completionHandler_(self, sel, url, _ReplaceTaskHandler(completionHandler));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromFile_completionHandler_, NSURLRequest *request, NSURL *fileURL, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	return _NSURLSession_uploadTaskWithRequest_fromFile_completionHandler_(self, sel, _LogRequest(request), fileURL, _ReplaceTaskHandler(completionHandler));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, uploadTaskWithRequest_fromData_completionHandler_, NSURLRequest *request, NSData *bodyData, void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	return _NSURLSession_uploadTaskWithRequest_fromData_completionHandler_(self, sel, _LogRequest(request), bodyData, _ReplaceTaskHandler(completionHandler));
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithRequest_completionHandler_, NSURLRequest *request, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	return _NSURLSession_downloadTaskWithRequest_completionHandler_(self, sel, _LogRequest(request), completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithURL_completionHandler_, NSURL *url, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogRequest([NSURLRequest requestWithURL:url]);
	return _NSURLSession_downloadTaskWithURL_completionHandler_(self, sel, url, completionHandler);
}

//
HOOK_MESSAGE(NSURLSessionDataTask *, NSURLSession, downloadTaskWithResumeData_completionHandler_, NSData *resumeData, void (^completionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))
{
	_LogLine();
	return _NSURLSession_downloadTaskWithResumeData_completionHandler_(self, sel, resumeData, completionHandler);
}
