
#import <Foundation/Foundation.h>

//
#pragma mark Appcalition path methods

//
NS_INLINE id NSBundleInfo(NSString *key)
{
	return [NSBundle.mainBundle objectForInfoDictionaryKey:key];
}

//
NS_INLINE NSString *NSBundleName()
{
	return NSBundleInfo(@"CFBundleName");
}

//
NS_INLINE NSString *NSBundleDisplayName()
{
	return NSBundleInfo(@"CFBundleDisplayName");
}

//
NS_INLINE NSString *NSBundleVersion()
{
	return NSBundleInfo(@"CFBundleShortVersionString");
}

//
NS_INLINE NSString *NSBundlePath()
{
	return [NSBundle.mainBundle bundlePath];
}

//
NS_INLINE NSString *NSBundleSubPath(NSString *file)
{
	return [NSBundlePath() stringByAppendingPathComponent:file];
}

//
NS_INLINE NSString *NSAssetPath()
{
#ifdef kAssetBundle
	return [NSBundlePath() stringByAppendingPathComponent:kAssetBundle];
#else
	return NSBundlePath();
#endif
}

//
NS_INLINE NSString *NSAssetSubPath(NSString *file)
{
	return [NSAssetPath() stringByAppendingPathComponent:file];
}

#pragma mark User directory methods

//
NS_INLINE NSString *NSUserDirectoryPath(NSSearchPathDirectory directory)
{
	return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
}

//
NS_INLINE NSString *NSDocumentPath()
{
	return NSUserDirectoryPath(NSDocumentDirectory);
}

//
NS_INLINE NSString *NSDocumentSubPath(NSString *file)
{
	return [NSDocumentPath() stringByAppendingPathComponent:file];
}

#pragma mark Cache methods

//
NS_INLINE NSString *NSCachePath()
{
	return NSUserDirectoryPath(NSCachesDirectory);
}

//
NS_INLINE NSString *NSCacheSubPath(NSString *file)
{
	return [NSCachePath() stringByAppendingPathComponent:file];
}

//
NS_INLINE NSString *NSUrlToFilename(NSString *url)
{
	unichar chars[256];
	NSRange range = {0, MIN(url.length, 256)};
	[url getCharacters:chars range:range];
	for (NSUInteger i = 0; i < range.length; i++)
	{
		switch (chars[i])
		{
			case '|':
			case '/':
			case '\\':
			case '?':
			case '*':
			case ':':
			case '<':
			case '>':
			case '"':
				chars[i] = '_';
				break;
		}
	}
	return [NSString stringWithCharacters:chars length:range.length];
}

//
NS_INLINE NSString *NSCacheUrlPath(NSString *url)
{
	NSString *dir = NSCacheSubPath(@"UrlCaches");
	if (![NSFileManager.defaultManager fileExistsAtPath:dir])
	{
		[NSFileManager.defaultManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
	}

	NSString *filename = NSUrlToFilename(url);
	return [dir stringByAppendingPathComponent:filename];
}

//
NS_INLINE unsigned long long NSCacheSize()
{
	NSString *dir = NSCachePath();

	//
	unsigned long long size = 0;
	NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:dir];
	for (NSString *file in files)
	{
		NSString *path = [dir stringByAppendingPathComponent:file];
		NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
		size += [dict fileSize];
	}

	return size;
}

#pragma mark Format methods

//
NS_INLINE NSString *NSFormatThousandsAmount(NSString *amount)
{
	if (amount == nil) return nil;

	NSMutableString *ret = [NSMutableString stringWithString:amount];
	NSRange range = [amount rangeOfString:@"."];
	NSInteger i = (range.location != NSNotFound) ? range.location : ret.length;
	for (i -= 3; i > 0; i -= 3)
	{
		[ret insertString:@"," atIndex:i];
	}
	return ret;
}

// Convert number to string
NS_INLINE NSString *NSFormatNumber(NSNumber *number, NSNumberFormatterStyle style)
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:style];
	return [formatter stringFromNumber:number];
}

// Convert byte size to string
NS_INLINE NSString *NSFormatByteSize(long long size)
{
	const long long GB = 1024 * 1024 * 1024;
	const long long MB = 1024 * 1024;
	const long long KB = 1024;

	NSString *formatSize = @"";
	if (size > GB)
	{
		formatSize = [NSString stringWithFormat:@"%.01fG", (double)size / GB];
	} else if (size > MB)
	{
		formatSize = [NSString stringWithFormat:@"%.01fM", (double)size / MB];
	} else if (size > KB)
	{
		formatSize = [NSString stringWithFormat:@"%.01fK", (double)size / KB];
	} else {
		formatSize = [NSString stringWithFormat:@"%lldB", size];
	}
	return formatSize;
}

// Convert date to string
NS_INLINE NSString *NSFormatDate(NSDate *date, NSString *format)
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = format;
	return [formatter stringForObjectValue:date];
}

// Convert date to string
NS_INLINE NSString *NSFormatDateWithStyle(NSDate *date, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle)
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:dateStyle];
	[formatter setTimeStyle:timeStyle];
	return [formatter stringForObjectValue:date];
}

// Convert string to date
NS_INLINE NSDate *NSFormatToDate(NSString *string, NSString *format/*, NSLocale *locale*/)
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = format;
	//if (locale) formatter.locale = locale;
	return [formatter dateFromString:string];
}

// Convert string to date
NS_INLINE NSDate *NSFormatToDateWithStyle(NSString *string, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle, NSLocale *locale)
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:dateStyle];
	[formatter setTimeStyle:timeStyle];
	if (locale) formatter.locale = locale;
	return [formatter dateFromString:string];
}

// Convert date to relative string.
NS_INLINE NSString *NSFormatDateBeforeNow(NSDate *date)
{
	NSDate *now = NSDate.date;
	NSTimeInterval t = [now timeIntervalSinceDate:date];
	if (t < 0) return nil;
	if (t < 60) return [NSString stringWithFormat:NSLocalizedString(@"%d Seconds Before", @"%d秒前"), (NSUInteger)t];
	if (t < 60 * 60) return [NSString stringWithFormat:NSLocalizedString(@"%d Minutes Before", @"%d分钟前"), (NSUInteger)(t/60)];
	if (t < 60 * 60 * 24) return [NSString stringWithFormat:NSLocalizedString(@"%d Hours Before", @"%d小时前"), (NSUInteger)(t/(60 * 60))];
	if (t < 60 * 60 * 24 * 31) return [NSString stringWithFormat:NSLocalizedString(@"%d Days Before", @"%d天前"), (NSUInteger)(t/(60 * 60 * 24))];
	if (t < 60 * 60 * 24 * 365) return [NSString stringWithFormat:NSLocalizedString(@"%d Months Before", @"%d个月前"), (NSUInteger)(t/(60 * 60 * 24 * 30))];
	/*if (t < 60 * 60 * 24 * 365) */return [NSString stringWithFormat:NSLocalizedString(@"%d Years Before", @"%d年前"), (NSUInteger)(t/(60 * 60 * 24 * 365))];
	return NSLocalizedString(@"Long Long Before", @"好久好久以前");
}

// Convert date to readable string. Return nil on fail
NS_INLINE NSString *NSFormatDateToDay(NSDate *date)
{
	NSDate *now = NSDate.date;
	NSTimeInterval t1 = [now timeIntervalSinceReferenceDate];
	NSTimeInterval t2 = [date timeIntervalSinceReferenceDate];
	NSTimeInterval t = [[NSTimeZone defaultTimeZone] secondsFromGMT];
	NSInteger d1 = (t1 + t) / (24 * 60 * 60);
	NSInteger d2 = (t2 + t) / (24 * 60 * 60);
	NSInteger days = d2 - d1;
	switch (days)
	{
		case -2: return NSLocalizedString(@"Before Yesterday", @"前天");
		case -1: return NSLocalizedString(@"Yesterday", @"昨天");
		case 0: return NSLocalizedString(@"Today", @"今天");
		case 1: return NSLocalizedString(@"Tomorrow", @"明天");
		case 2: return NSLocalizedString(@"After Tomorrow", @"后天");
	}
	return nil;
}

#pragma mark Encrypt methods

// Encrypt string use private method
NS_INLINE NSString *NSStringEncrypt(NSString *str)
{
	if (str.length == 0) return str;

	const char *p = str.UTF8String;
	NSUInteger length = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	char *q = (char *)malloc(length * 2);
	unsigned char m = 3;
	for (NSUInteger i = 0; i < length; i++)
	{
		unsigned char t = m ^ p[i];
		q[i * 2] = m = 0x35 + (t & 0x0F);
		q[i * 2 + 1] = 0x23 + ((t & 0xF0) >> 4);
		q[i * 2] -= 0x0F;
	}
	return [[NSString alloc] initWithBytesNoCopy:q length:length * 2 encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

// Decrypt string use private method
NS_INLINE NSString *NSStringDecrypt(NSString *str)
{
	if (str.length == 0) return str;

	const char *q = str.UTF8String;
	NSUInteger length = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding] / 2;
	char *p = (char *)malloc(length);
	unsigned char m = 3;
	for (NSUInteger i = 0; i < length; i++)
	{
		unsigned char n = (q[i * 2] + 0x0F);
		unsigned char t = (n - 0x35) | ((q[i * 2 + 1] - 0x23) << 4);
		p[i] = t ^ m;
		m = n;
	}
	return [[NSString alloc] initWithBytesNoCopy:p length:length encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

//
NS_INLINE NSString *NSStringMask(NSString *str, NSInteger location, NSInteger length)
{
	NSUInteger strLen = str.length;
	if (location < 0) location = strLen + location - 1;
	if (length < 0) length = strLen - location + length;
	if (strLen > location && length > 0)
	{
		NSMutableString *secure = [NSMutableString string];
		if (location) [secure appendString:[str substringToIndex:location]];
		NSInteger n = str.length - location - 1;
		if (n > length) n = length;
		NSInteger m = str.length - location - n;
		while (n--)
		{
			[secure appendString:@"*"];
		}
		if (m > 0) [secure appendString:[str substringFromIndex:strLen - m]];
		return secure;
	}
	return str;
}

#pragma mark Url methods

//
NS_INLINE NSString *NSUrlEscape(NSString *string)
{
	return [string stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
//	return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//																	 (CFStringRef)string,
//																	 NULL,
//																	 CFSTR("!*'();:@&=+$,/?%#[]"),
//																	 kCFStringEncodingUTF8));
}

//
NS_INLINE NSString *NSUrlUnEscape(NSString *string)
{
	return [string stringByRemovingPercentEncoding];
//	return CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
//																								 (CFStringRef)string,
//																								 CFSTR(""),
//																								 kCFStringEncodingUTF8));
}

//
NS_INLINE NSDictionary *NSUrlQueryToDict(NSString *query)
{
	NSArray *params = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:params.count];
	for (NSString *param in params)
	{
		NSRange range = [param rangeOfString:@"="];
		if (range.location != NSNotFound)
		{
			NSString *key = [param substringToIndex:range.location];
			NSString *value = [param substringFromIndex:range.location + 1];
			[dict setObject:NSUrlUnEscape(value) forKey:key];
		}
	}
	return dict;
}

//
NS_INLINE NSString *NSUrlQueryFromDict(NSDictionary *params)
{
	NSMutableString *query = [NSMutableString string];
	NSArray *keys = params.allKeys;
	NSInteger count = keys.count;
	for (NSInteger i = 0; i < count; i++)
	{
		NSString *key = keys[i];
		id value = params[key];
		if (i) [query appendString:@"&"];
		[query appendFormat:@"%@=%@", key, [value isKindOfClass:NSString.class] ? NSUrlEscape(value) : value];
	}
	return query;
}

//
NS_INLINE NSString *NSUrlQueryFromArray(NSArray *params)
{
	NSMutableString *query = [NSMutableString string];
	NSInteger count = params.count;
	for (NSInteger i = 0; i < count; i++)
	{
		NSArray *param = params[i];
		//if (param.count >= 2)
		{
			NSString *key = param[i];
			id value = param[2];
			if (i) [query appendString:@"&"];
			[query appendFormat:@"%@=%@", key, [value isKindOfClass:NSString.class] ? NSUrlEscape(value) : value];
		}
	}
	return query;
}

#pragma mark Misc methods

//
NS_INLINE NSString *NSUUIDString()
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString *string = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
	CFRelease(uuid);
	return string;
}

//
NS_INLINE NSString *NSTimeStamp()
{
	return [NSString stringWithFormat:@"%ld", time(NULL)];
}
