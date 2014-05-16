
#import <mach/mach_host.h>
#import <mach-o/nlist.h>
#import <objc/runtime.h>
#import <dlfcn.h>

//
#define DLSYM(lib, func)				dlsym(dlopen(k##lib.UTF8String, RTLD_LAZY), k##func.UTF8String)
#define _DLSYM(lib, func)				dlsym(dlopen(#lib, RTLD_LAZY), #func)	// Without k- string

#define FUNPTR(ret, func, ...)			ret (*_##func)(__VA_ARGS__)
#define PTRSET(func, val)				*((void **)&_##func) = val
#define PTRFUN(lib, func)				PTRSET(func, DLSYM(lib, func))
#define _PTRFUN(lib, func)				PTRSET(func, _DLSYM(lib, func))

//
#define FUNHOOK(ret, func, ...)			ret (*_##func)(__VA_ARGS__); ret $##func(__VA_ARGS__) {{/*_Log(@"FUNHOAK %s(%s)", #hook, #__VA_ARGS__);*/
#define FUNHOAK(ret, func, ...)			ret (*_##func)(__VA_ARGS__); ret $##func(__VA_ARGS__) {@autoreleasepool{
#define HOOKFUN(lib, func)				_MSHookFunction(DLSYM(lib, func), (void *)$##func, (void **)&_##func)
#define _HOOKFUN(lib, func)				_MSHookFunction(_DLSYM(lib, func), (void *)$##func, (void **)&_##func)	// Without encrypt string
#define MSGHOOK(ret, hook, ...)			ret (*_##hook)(id self, SEL sel, ##__VA_ARGS__); ret $##hook(id self, SEL sel, ##__VA_ARGS__) {{/*_Log(@"MSGHOAK [%@ %@] %s(id self, %s)", NSStringFromClass([self class]), NSStringFromSelector(sel), #hook, #__VA_ARGS__);*/
#define MSGHOAK(ret, hook, ...)			ret (*_##hook)(id self, SEL sel, ##__VA_ARGS__); ret $##hook(id self, SEL sel, ##__VA_ARGS__) {@autoreleasepool{
#define HOOKMSG(hook, cls, sel)			_MSHookMessageEx(NSClassFromString(k##cls), @selector(sel), (IMP)$##hook, (IMP *)&_##hook)
#define _HOOKMSG(hook, cls, sel)		_MSHookMessageEx(NSClassFromString(@#cls), @selector(sel), (IMP)$##hook, (IMP *)&_##hook)	// Without encrypt string
#define HOOKCLS(hook, cls, sel)			_MSHookMessageEx(objc_getMetaClass([k##cls UTF8String]), @selector(sel), (IMP)$##hook, (IMP *)&_##hook)
#define _HOOKCLS(hook, cls, sel)		_MSHookMessageEx(objc_getMetaClass(#cls), @selector(sel), (IMP)$##hook, (IMP *)&_##hook)	// Without encrypt string

#define ENDHOOK							}}

extern FUNPTR(void, MSHookFunction, void *symbol, void *replace, void **result);
extern FUNPTR(void, MSHookMessageEx, Class _class, SEL sel, IMP imp, IMP *result);

//
void LogRequest(NSURLRequest *request, void *returnAddress);
#define _LogRequest(request) LogRequest(request, __builtin_return_address(0))
