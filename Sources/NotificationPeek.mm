
//
FUNHOOK(void, CFNotificationCenterPostNotification,
		CFNotificationCenterRef center,
		CFStringRef name,
		const void *object,
		CFDictionaryRef userInfo,
		Boolean deliverImmediately
		)
{
	_Log(@"CFNotificationCenterPostNotification: %@, %@, %@, object: %@, userInfo:%@, deliverImmediately:%d", [NSThread callStackSymbols], center, name, object, userInfo, deliverImmediately);
	return _CFNotificationCenterPostNotification(center, name, object, userInfo, deliverImmediately);
} ENDHOOK

//
FUNHOOK(SInt32, CFMessagePortSendRequest, CFMessagePortRef remote, SInt32 msgid, CFDataRef data, CFTimeInterval sendTimeout, CFTimeInterval rcvTimeout, CFStringRef replyMode, CFDataRef *returnData)
{
	_Log(@"CFMessagePortSendRequest: %@", CFMessagePortGetName(remote));
	return _CFMessagePortSendRequest(remote, msgid, data, sendTimeout, rcvTimeout, replyMode, returnData);
} ENDHOOK

//
MSGHOOK(id, CPDistributedMessagingCenter_sendMessageAndReceiveReplyName_userInfo, id a1, id a2)
{
	_Log(@"CPDistributedMessagingCenter_sendMessageAndReceiveReplyName_userInfo:%@, %@", a1, a2);
	return _CPDistributedMessagingCenter_sendMessageAndReceiveReplyName_userInfo(self, sel, a1, a2);
} ENDHOOK

//
MSGHOOK(void, NSNotificationCenter_postNotificationName_object_userInfo, id a1, id a2, id a3)
{
	_Log(@"NSNotificationCenter_postNotificationName_object_userInfo:%@, %@, %@", a1, a2, a3);
	_NSNotificationCenter_postNotificationName_object_userInfo(self, sel, a1, a2, a3);
} ENDHOOK

//
MSGHOOK(void, NSNotificationCenter_postNotificationName_object, id a1, id a2)
{
	_Log(@"NSNotificationCenter_postNotificationName_object:%@, %@", a1, a2);
	_NSNotificationCenter_postNotificationName_object(self, sel, a1, a2);
} ENDHOOK

//
FUNHOOK(void, _CTCallHandleUSSDSessionStringNotification, CFNotificationCenterRef ref, CFDictionaryRef userInfo)
{
	_Log(@"_CTCallHandleUSSDSessionStringNotification: %@", userInfo);
	return __CTCallHandleUSSDSessionStringNotification(ref, userInfo);
} ENDHOOK

//
void NotificationPeekInit(NSString *processName)
{
	_HOOKFUN(/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFMessagePortSendRequest);
	_HOOKMSG(CPDistributedMessagingCenter_sendMessageAndReceiveReplyName_userInfo, CPDistributedMessagingCenter, sendMessageAndReceiveReplyName:userInfo:);
	
	_HOOKFUN(/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFNotificationCenterPostNotification);
	//_HOOKMSG(NSNotificationCenter_postNotificationName_object_userInfo, NSNotificationCenter, postNotificationName:object:userInfo:);
	//_HOOKMSG(NSNotificationCenter_postNotificationName_object, NSNotificationCenter, postNotificationName:object:);
	_HOOKFUN(/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony, _CTCallHandleUSSDSessionStringNotification);
}
