
#import "HookMain.h"

//
MSGHOOK(BOOL, UIApplication_openURL, NSURL *URL)
{
	NSLog(@"UIApplication_openURL: %@", URL);
	return _UIApplication_openURL(self, sel, URL);
	
} ENDHOOK

//
MSGHOOK(BOOL, UIApplication_canOpenURL, NSURL *URL)
{
	NSLog(@"UIApplication_canOpenURL: %@", URL);
	return _UIApplication_canOpenURL(self, sel, URL);
} ENDHOOK


//
void ApplicationPeekInit(NSString *processName)
{
	_HOOKMSG(UIApplication_openURL, UIApplication, openURL:);
	_HOOKMSG(UIApplication_canOpenURL, UIApplication, canOpenURL:);
}
