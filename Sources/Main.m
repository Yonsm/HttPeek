
#import "NSData+GZIP.h"

//
NSString *LogFilePath(NSString *fileName, NSString *extName)
{
	static NSString *_logDir = nil;
	if (_logDir == nil)
	{
		_logDir = [[NSString alloc] initWithFormat:@"/tmp/%@.req", NSProcessInfo.processInfo.processName];
		[[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
#define _SIMPLE
#ifdef _SIMPLE
	return [NSString stringWithFormat:@"%@/%@.%@", _logDir, fileName, extName];
#else
	static int _index = 0;
	return [NSString stringWithFormat:@"%@/%03d-%@.%@", _logDir, _index++, fileName, extName];
#endif
}

//
const void *LogData(const void *data, size_t dataLength, void *returnAddress)
{
	if (data == nil || dataLength == 0)
		return data;

    _LogLine();

	Dl_info info = {0};
	dladdr(returnAddress, &info);

	NSString *str = [NSString stringWithFormat:@"FROM %s(%p)-%s(%p=>%#08lx)\n<%@>\n\n", info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr, (long)info.dli_saddr-(long)info.dli_fbase-0x1000, @""];
	NSLog(@"HTTPEEK DATA: %@\n", str);

	NSMutableData *dat = [NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
	[dat appendBytes:data length:dataLength];
	
	NSString *txt = [[NSString alloc] initWithBytesNoCopy:(void *)data length:dataLength encoding:NSUTF8StringEncoding freeWhenDone:NO];
	if (txt) NSLog(@"%@\n\n", txt);

	[dat writeToFile:LogFilePath(@"DATA", txt ? @"txt" : @"bin") atomically:NO];
	
	return data;
}

void LogInfoData(NSString *info, NSURL *URL, NSData *data, NSString *typeName)
{
#ifdef _SIMPLE
	NSString *logPath = LogFilePath(NSUrlPath(URL.path.lastPathComponent), [typeName stringByAppendingString:@".txt"]);
#else
	NSString *logPath = LogFilePath(NSUrlPath([URL.host stringByAppendingString:URL.path]), [typeName stringByAppendingString:@".txt"]);
#endif
	data = [data gunzippedData];
	if (data.length && data.length < 10240)
	{
#ifdef _SIMPLE
		id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
		if (obj)
		{
			data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
		}
#endif
		
		NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		if (content)
		{
			[[info stringByAppendingString:content] writeToFile:logPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
			_Log(@"%@ With Text Content: %@\n%@\n\n", typeName, info, content);
			return;
		}
	}
	
	_Log(@"%@: %@\n", typeName, info);
	[info writeToFile:logPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
	if (data.length)
	{
		_Log(@"With Binay Content <%d Bytes>", (int)data.length);
		[data writeToFile:[logPath stringByAppendingString:@".dat"] atomically:NO];
	}
}

//
NSURLRequest *LogRequest(NSURLRequest *request, void *returnAddress)
{
	if (![request respondsToSelector:@selector(HTTPMethod)])
	{
		_LogObj(@"NOT HTTP Request!!");
		return request;
	}

	//
	static NSMutableArray *_requests;
	if (_requests == nil) _requests = [[NSMutableArray alloc] init];
	for (NSValue *value in _requests)
	{
		if (value.pointerValue == (__bridge void*)request)
		{
			_LogObj(@"Duplicated Request!!");
			return request;
		}
	}
	[_requests addObject:[NSValue valueWithPointer:(__bridge void*)request]];
	
	Dl_info info = {0};
	dladdr(returnAddress, &info);
	NSString *str = [NSString stringWithFormat:@"FROM %s(%p)-%s(%p=>%#08lx)\n<%@>\n%@: %@\n%@\n\n", info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr, (long)info.dli_saddr-(long)info.dli_fbase-0x1000, @"", request.HTTPMethod, request.URL.absoluteString, request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @""];

	LogInfoData(str, request.URL, request.HTTPBody, @"REQUEST");
	return request;
}

NSURLResponse *LogResponse(NSURLResponse *response, NSData *data)
{
	LogInfoData(response.description, response.URL, data, @"RESPONSE");
	return response;
}

//
#if __cplusplus
extern "C"
#endif
int main()
{
#if DEBUG
	BOOL isDebug = YES;
#else
	BOOL isDebug = NO;
#endif
	_Log(@"Line Log: %s (%u) %s isDebug: %d", __FUNCTION__, __LINE__, __TIME__, isDebug);
	return 0;
}
