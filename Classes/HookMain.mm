

#import "HookMain.h"

FUNPTR(void, MSHookFunction, void *symbol, void *replace, void **result) = NULL;
FUNPTR(void, MSHookMessageEx, Class _class, SEL sel, IMP imp, IMP *result) = NULL;


//
#import <vector>
#import <algorithm>

//
void LogRequest(NSURLRequest *request, void *returnAddress)
{
	static int s_index = 0;
	static NSString *_logDir = nil;
	static std::vector<NSURLRequest *> _requests;

	if (_logDir == nil)
	{
		_logDir = [[NSString alloc] initWithFormat:@"/tmp/%@.req", NSProcessInfo.processInfo.processName];
		[[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	if ([request respondsToSelector:@selector(HTTPMethod)])
	{
		if (std::find(_requests.begin(), _requests.end(), request) == _requests.end())
		{
			_requests.push_back(request);
			if (_requests.size() > 1024)
			{
				_requests.erase(_requests.begin(), _requests.begin() + 512);
			}
			
			Dl_info info = {0};
			dladdr(returnAddress, &info);
			
			NSString *str = [NSString stringWithFormat:@"FROM %s(%p)-%s(%p=>%#08lx)\n<%@>\n%@: %@\n%@\n\n", info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr, (long)info.dli_saddr-(long)info.dli_fbase-0x1000, [NSThread callStackSymbols], request.HTTPMethod, request.URL.absoluteString, request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @""];
			NSLog(@"HTTPEEK REQUEST: %@", str);
			
			NSString *file = [NSString stringWithFormat:@"%@/%d=%@.txt", _logDir, s_index++, NSUtil::UrlPath([request.URL.host stringByAppendingString:request.URL.path])];
			if (request.HTTPBody.length && request.HTTPBody.length < 10240)
			{
				NSString *str2 = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
				if (str2)
				{
					[[str stringByAppendingString:str2] writeToFile:file atomically:NO encoding:NSUTF8StringEncoding error:nil];
					[str2 release];
					return;
				}
			}
			
			[str writeToFile:file atomically:NO encoding:NSUTF8StringEncoding error:nil];
			[request.HTTPBody writeToFile:[file stringByAppendingString:@".dat"] atomically:NO];
		}
	}
}

//
void WebViewPeekInit(NSString *processName);
void ConnectionPeekInit(NSString *processName);
void ReadStreamPeekInit(NSString *processName);
void ApplicationPeekInit(NSString *processName);

//
extern "C" void AppInit()
{
	@autoreleasepool
	{
		NSString *processName = NSProcessInfo.processInfo.processName;
		_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookFunction);
		_PTRFUN(/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate, MSHookMessageEx);
		
		NSLog(@"HTTPEEK new process %@ MSHookFunction=%p, MSHookMessageEx=%p", processName, _MSHookFunction, _MSHookMessageEx);
				
		WebViewPeekInit(processName);
		ConnectionPeekInit(processName);
		ReadStreamPeekInit(processName);
		ApplicationPeekInit(processName);
		
		return;
	}
}
