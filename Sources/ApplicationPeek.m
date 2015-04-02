

//
HOOK_MESSAGE(BOOL, UIApplication, openURL_, NSURL *URL)
{
	NSLog(@"%s: %@", __FUNCTION__, URL);
	return _UIApplication_openURL_(self, sel, URL);
}

//
HOOK_MESSAGE(BOOL, UIApplication, canOpenURL_, NSURL *URL)
{
	NSLog(@"%s: %@", __FUNCTION__, URL);
	return _UIApplication_canOpenURL_(self, sel, URL);
}
