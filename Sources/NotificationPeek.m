
//
HOOK_FUNCTION(void, /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFNotificationCenterPostNotification,
			  CFNotificationCenterRef center,
			  CFStringRef name,
			  const void *object,
			  CFDictionaryRef userInfo,
			  Boolean deliverImmediately
			  )
{
	_Log(@"%s: %@, %@, %@, object: %@, userInfo:%@, deliverImmediately:%d", __FUNCTION__, [NSThread callStackSymbols], center, name, object, userInfo, deliverImmediately);
	return _CFNotificationCenterPostNotification(center, name, object, userInfo, deliverImmediately);
}

//
HOOK_FUNCTION(SInt32, /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFMessagePortSendRequest, CFMessagePortRef remote, SInt32 msgid, CFDataRef data, CFTimeInterval sendTimeout, CFTimeInterval rcvTimeout, CFStringRef replyMode, CFDataRef *returnData)
{
	_Log(@"%s: %@", __FUNCTION__, CFMessagePortGetName(remote));
	return _CFMessagePortSendRequest(remote, msgid, data, sendTimeout, rcvTimeout, replyMode, returnData);
}

//
HOOK_MESSAGE(id, CPDistributedMessagingCenter, sendMessageAndReceiveReplyName_userInfo_, id a1, id a2)
{
	_Log(@"%s:%@, %@", __FUNCTION__, a1, a2);
	return _CPDistributedMessagingCenter_sendMessageAndReceiveReplyName_userInfo_(self, sel, a1, a2);
}

//
HOOK_MESSAGE(void, NSNotificationCenter, postNotificationName_object_userInfo_, id a1, id a2, id a3)
{
	_Log(@"%s:%@, %@, %@", __FUNCTION__, a1, a2, a3);
	_NSNotificationCenter_postNotificationName_object_userInfo_(self, sel, a1, a2, a3);
}

//
HOOK_MESSAGE(void, NSNotificationCenter, postNotificationName_object_, id a1, id a2)
{
	_Log(@"%s:%@, %@", __FUNCTION__, a1, a2);
	_NSNotificationCenter_postNotificationName_object_(self, sel, a1, a2);
}

//
HOOK_FUNCTION(void, /System/Library/Frameworks/CoreTelephony.framework/CoreTelephony, _CTCallHandleUSSDSessionStringNotification, CFNotificationCenterRef ref, CFDictionaryRef userInfo)
{
	_Log(@"%s: %@", __FUNCTION__, userInfo);
	return __CTCallHandleUSSDSessionStringNotification(ref, userInfo);
}
