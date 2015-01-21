

// App Store URL
#define kStoreUrl(x)	[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", x]
#define kAppStoreID		[NSBundle.mainBundle objectForInfoDictionaryKey:@"AppStoreID"]
#define kAppStoreUrl	kStoreUrl(kAppStoreID)

// Array count
#ifndef _NumOf
#define _NumOf(a)		(sizeof(a) / sizeof(a[0]))
#endif

// Log Helper
#ifndef _Log
#if defined(DEBUG) || defined(TEST)
#ifdef _LOG_TO_FILE
#define _Log(s, ...)	{NSString *str = [NSString stringWithFormat:s, ##__VA_ARGS__]; FILE *fp = fopen("/tmp/NSUtil.log", "a"); if (fp) {fprintf(fp, "[%s] %s\n", NSProcessInfo.processInfo.processName.UTF8String, str.UTF8String); fclose(fp);}}
#else
#define _Log(s, ...)	NSLog(s, ##__VA_ARGS__)
#endif
#define _LogObj(o)		if (o) _Log(@"Object Log: %s (%u), %@ (%@)", __FUNCTION__, __LINE__, NSStringFromClass([o class]), o)
#define _LogLine()		_Log(@"Line Log: %s (%u)", __FUNCTION__, __LINE__)
#import <dlfcn.h>
#define _LogStack()		{Dl_info info = {0}; dladdr(__builtin_return_address(0), &info); _Log(@"Stack Log: fname=%s, fbase=%p, sname=%s, saddr=%p, offset=%#08lx, stack=>\n%@", info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr, (long)info.dli_saddr-(long)info.dli_fbase-0x1000, [NSThread callStackSymbols]);}
#else
#define _Log(s, ...)	((void) 0)
#define _LogLine()		((void) 0)
#define _LogObj(o)		((void) 0)
#define _LogStack()		((void) 0)
#endif
#endif

// Suppress warning
#ifndef _SuppressPerformSelectorLeakWarning
#define _SuppressPerformSelectorLeakWarning(Stuff) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop")
#endif

// Extend an object
#ifndef _EXObject
#define _EXObject(object, ref, type, name)	\
@interface object##_##name : object	\
@property(nonatomic,ref) type name;	\
@end	\
@implementation object##_##name	\
@end
#endif

// Localized String
#undef NSLocalizedString
#ifdef DEBUG
#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:(comment) table:nil]
#else
#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:(key) table:nil]
#endif
