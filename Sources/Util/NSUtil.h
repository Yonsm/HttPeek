
#import <Foundation/Foundation.h>

//
class NSUtil
{
#pragma mark Appcalition path methods
public:
	//
	NS_INLINE NSBundle *Bundle()
	{
		return [NSBundle mainBundle];
	}
	
	//
	NS_INLINE id BundleInfo(NSString *key)
	{
		return [Bundle() objectForInfoDictionaryKey:key];
	}
	
	//
	NS_INLINE NSString *BundleName()
	{
		return BundleInfo(@"CFBundleName");
	}
	
	//
	NS_INLINE NSString *BundleDisplayName()
	{
		return BundleInfo(@"CFBundleDisplayName");
	}
	
	//
	NS_INLINE NSString *BundleVersion()
	{
		return BundleInfo(@"CFBundleShortVersionString");
	}
	
	//
	NS_INLINE NSString *BundlePath()
	{
		return [Bundle() bundlePath];
	}
	
	//
	NS_INLINE NSString *BundlePath(NSString *file)
	{
		return [BundlePath() stringByAppendingPathComponent:file];
	}
	
	//
	NS_INLINE NSString *ResourcePath()
	{
#ifdef kResourceBundle
		return [BundlePath() stringByAppendingPathComponent:kResourceBundle];
#else
		return BundlePath();
#endif
	}
	
	//
	NS_INLINE NSString *ResourcePath(NSString *file)
	{
		return [ResourcePath() stringByAppendingPathComponent:file];
	}
	
#pragma mark File manager methods
public:
	//
	NS_INLINE NSFileManager *FileManager()
	{
		return [NSFileManager defaultManager];
	}
	
	//
	NS_INLINE BOOL IsPathExist(NSString* path)
	{
		return [FileManager() fileExistsAtPath:path];
	}
	
	//
	NS_INLINE BOOL IsFileExist(NSString* path)
	{
		BOOL isDirectory;
		return [FileManager() fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory;
	}
	
	//
	NS_INLINE BOOL IsDirectoryExist(NSString* path)
	{
		BOOL isDirectory;
		return [FileManager() fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
	}
	
	//
	NS_INLINE BOOL RemovePath(NSString* path)
	{
		return [FileManager() removeItemAtPath:path error:nil];
	}
	
#pragma mark User directory methods
public:
	//
	NS_INLINE NSString *UserDirectoryPath(NSSearchPathDirectory directory)
	{
		return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
	}
	
	//
	NS_INLINE NSString *DocumentPath()
	{
		return UserDirectoryPath(NSDocumentDirectory);
	}
	
	//
	NS_INLINE NSString *DocumentPath(NSString *file)
	{
		return [DocumentPath() stringByAppendingPathComponent:file];
	}
	
#pragma mark User defaults
public:
	//
	NS_INLINE NSUserDefaults *UserDefaults()
	{
		return [NSUserDefaults standardUserDefaults];
	}
	
	//
	NS_INLINE id DefaultForKey(NSString *key)
	{
		return [UserDefaults() objectForKey:key];
	}
	
	//
	NS_INLINE void SetDefaultForKey(NSString *key, id value)
	{
		return [UserDefaults() setObject:value forKey:key];
	}
	
	//
	NS_INLINE NSString *PhoneNumber()
	{
		return DefaultForKey(@"SBFormattedPhoneNumber");
	}
	
	//
	NS_INLINE NSString *DefaultLanguage()
	{
		return [[NSLocale preferredLanguages] objectAtIndex:0];
		//return [DefaultForKey(@"AppleLanguages") objectAtIndex:0];
	}
	
	//
	static NSString *CountryAreaCode(NSString *country = (NSString *)[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]);
	
	
#pragma mark Cache methods
public:
	//
	NS_INLINE NSString *CachePath()
	{
		//return DocumentPath(@"Cache");
		return UserDirectoryPath(NSCachesDirectory);
	}
	
	//
	NS_INLINE void RemoveCache()
	{
		[FileManager() removeItemAtPath:CachePath() error:nil];
	}
	
	//
	NS_INLINE NSString *CachePath(NSString *file)
	{
		NSString *dir = CachePath();
		if (IsDirectoryExist(dir) == NO)
		{
			[FileManager() createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
		}
		return [dir stringByAppendingPathComponent:file];
	}
	
	//
	NS_INLINE NSString *UrlPath(NSString *url)
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
	NS_INLINE NSString *CacheUrlPath(NSString *url)
	{
		return CachePath(UrlPath(url));
	}
	
	//
	NS_INLINE unsigned long long CacheSize()
	{
		NSString *dir = NSUtil::CachePath();
		
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
public:
	// Convert number to string
	static NSString *FormatNumber(NSNumber *number, NSNumberFormatterStyle style = NSNumberFormatterNoStyle);
	
	// Convert date to string
	static NSString *FormatDate(NSDate *date, NSString *format);
	
	// Convert date to string
	static NSString *FormatDate(NSDate *date, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle = NSDateFormatterNoStyle);
	
	// Convert string to date
	static NSDate *FormatDate(NSString *string, NSString *format = @"yyyy-MM-dd HH:mm:ss", NSLocale *locale = nil);
	
	// Convert string to date
	static NSDate *FormatDate(NSString *string, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle = NSDateFormatterNoStyle, NSLocale *locale = nil);
	
	// Convert date to readable string. Return nil on fail
	static NSString *SmartDate(NSDate *date);
	
	// Convert date to smart string
	static NSString *SmartDate(NSDate *date, NSString *format);
	
	// Convert date to smart string
	static NSString *SmartDate(NSDate *date, NSDateFormatterStyle dateStyle);
	
	// Convert date to smart string
	static NSString *SmartDate(NSDate *date, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle);
	
#pragma mark Misc methods
public:
	// Check email address
	static BOOL IsEmailAddress(NSString *emailAddress);
	
	// Check mobile phone number in China
	static BOOL IsMobileNumberInChina(NSString *phoneNumber);
	
	// Check phone number equal
	static BOOL IsPhoneNumberEqual(NSString *phoneNumber1, NSString *phoneNumber2, NSUInteger minEqual = 10);
	
	// Calculate MD5
	static NSString *MD5(NSString *str);
	
	// Calculate HMAC SHA1
	static NSString *HmacSHA1(NSString *text, NSString *secret);
	
	// BASE64 encode
	static NSString *BASE64Encode(const unsigned char *data, NSUInteger length, NSUInteger lineLength = 0);
	
	// BASE64 decode
	static NSData *BASE64Decode(NSString *string);
	
	// BASE64 encode data
	NS_INLINE NSString *BASE64EncodeData(NSData *data, NSUInteger lineLength = 0)
	{
		return BASE64Encode((const unsigned char *)data.bytes, data.length, lineLength);
	}
	
	// BASE64 encode string
	NS_INLINE NSString *BASE64EncodeString(NSString *string, NSUInteger lineLength = 0)
	{
		return BASE64EncodeData([string dataUsingEncoding:NSUTF8StringEncoding], lineLength);
	}
	
	// BASE64 decode string
	NS_INLINE NSString *BASE64DecodeString(NSString *string)
	{
		NSData *data = BASE64Decode(string);
		return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	}
	
	// Encrypt string use private method
	NS_INLINE NSString *EncryptString(NSString *str)
	{
		return str;
	}

	// Decrypt string use private method
	NS_INLINE NSString *DecryptString(NSString *str)
	{
		return str;
	}
	
public:
	//
	NSDictionary *URLQuery(NSString *query)
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
				[dict setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		return dict;
	}

	//
	NS_INLINE NSString *URLEscape(NSString *string)
	{
		CFStringRef result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																	 (CFStringRef)string,
																	 NULL,
																	 CFSTR("!*'();:@&=+$,/?%#[]"),
																	 kCFStringEncodingUTF8);
		return [(NSString *)result autorelease];
	}
	
	//
	NS_INLINE NSString *URLUnEscape(NSString *string)
	{
		CFStringRef result = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																					 (CFStringRef)string,
																					 CFSTR(""),
																					 kCFStringEncodingUTF8);
		return [(NSString *)result autorelease];
	}
	
	//
	NS_INLINE NSString *TS()
	{
		return [NSString stringWithFormat:@"%ld", time(NULL)];
	}
	
	//
	NS_INLINE NSString *UUID()
	{
		CFUUIDRef uuid = CFUUIDCreate(NULL);
		CFStringRef string = CFUUIDCreateString(NULL, uuid);
		CFRelease(uuid);
		return [(NSString *)string autorelease];
	}
};

// Array count
#ifndef _NumOf
#define _NumOf(a) (sizeof(a) / sizeof(a[0]))
#endif

// Log Helper
#ifdef TEST
#ifdef _LOG_TO_FILE
#define _Log(s, ...)	{NSString *str = [NSString stringWithFormat:s, ##__VA_ARGS__]; FILE *fp = fopen("/tmp/NSUtil.log", "a"); if (fp) {fprintf(fp, "[%s] %s\n", NSProcessInfo.processInfo.processName.UTF8String, str.UTF8String); fclose(fp);}}
#else
#define _Log(s, ...)	NSLog(s, ##__VA_ARGS__)
#endif
#define _ObjLog(o)		if (o) _Log(@"Object Log: %s (%u), %@ (%@)", __FUNCTION__, __LINE__, NSStringFromClass([o class]), o)
#define _LineLog()		_Log(@"Line Log: %s (%u)", __FUNCTION__, __LINE__)
#ifdef __cplusplus
#define _AutoLog()		AutoLog al(__FUNCTION__, __LINE__)
#else
#define _AutoLog()		_LineLog()
#endif
#else
#define _Log(s, ...)	((void) 0)
#define _LineLog()		((void) 0)
#define _AutoLog()		((void) 0)
#define _ObjLog(o)		((void) 0)
#endif

// Auto Log
#ifdef __cplusplus
#import <mach/mach_time.h>
class AutoLog
{
private:
	uint _line;
	uint64_t _start;
	const char *_name;
	
public:
	inline AutoLog(const char *name, unsigned int line): _line(line), _name(name), _start(mach_absolute_time())
	{
		_Log(@"Enter %s:%u", name, line);
	}
	
	inline ~AutoLog()
	{
		_Log(@"Leave %s:%u Elapsed %qu", _name, _line, mach_absolute_time() - _start);
	}
};
#endif
