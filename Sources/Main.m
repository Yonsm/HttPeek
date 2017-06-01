

//
NSString *LogFilePath(NSString *fileName, NSString *extName)
{
	static NSString *_logDir = nil;
	if (_logDir == nil)
	{
		_logDir = [[NSString alloc] initWithFormat:@"/tmp/%@.req", NSProcessInfo.processInfo.processName];
		[[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
	static int _index = 0;
	return [NSString stringWithFormat:@"%@/%03d-%@.%@", _logDir, _index++, fileName, extName];
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
			//_LogObj(@"Duplicated Request!!");
			return request;
		}
	}
	[_requests addObject:[NSValue valueWithPointer:(__bridge void*)request]];
	
	//
	
	Dl_info info = {0};
	dladdr(returnAddress, &info);
	NSString *str = [NSString stringWithFormat:@"FROM %s(%p)-%s(%p=>%#08lx)\n<%@>\n%@: %@\n%@\n\n", info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr, (long)info.dli_saddr-(long)info.dli_fbase-0x1000, @"", request.HTTPMethod, request.URL.absoluteString, request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @""];
	
	if (request.HTTPBody.length && request.HTTPBody.length < 10240)
	{
		NSString *str2 = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
		if (str2)
		{
			//[[str stringByAppendingString:str2] writeToFile:file atomically:NO encoding:NSUTF8StringEncoding error:nil];
			
			NSLog(@"HTTPEEK REQUEST With Content: %@ \n%@\n\n", str, str2);
			return request;
		}
	}
	
	NSLog(@"HTTPEEK REQUEST: %@\n", str);
	NSString *fileName = NSUrlPath([request.URL.host stringByAppendingString:request.URL.path]);
	[str writeToFile:LogFilePath(fileName, @"txt") atomically:NO encoding:NSUTF8StringEncoding error:nil];
	[request.HTTPBody writeToFile:[fileName stringByAppendingString:@".dat"] atomically:NO];

	return request;
}


NSURLResponse *LogResponse(NSURLResponse *response, NSData *data)
{
	_LogObj(response);
	_LogData(data.bytes, data.length);
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
