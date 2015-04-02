
#import <objc/runtime.h>

//
#define _HOOK_FUNCTION_(MOD, RET, LIB, FUN, ...)		RET $##FUN(__VA_ARGS__);\
														RET (*_##FUN)(__VA_ARGS__);\
														__attribute__((MOD)) void _Init_##FUN() {_HookFunction(#LIB, #FUN, (void *)$##FUN, (void **)&_##FUN);}\
														RET $##FUN(__VA_ARGS__)

#define _HOOK_MESSAGE_(MOD, RET, CLS, MSG, META, ...)	RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__);\
														RET (*_##CLS##_##MSG)(id self, SEL sel, ##__VA_ARGS__);\
														__attribute__((MOD)) void _Init_##CLS##_##MSG() {_HookMessage(objc_get##META##Class(#CLS), #MSG, (void *)$##CLS##_##MSG, (void **)&_##CLS##_##MSG);}\
														RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__)

// 需要手动调用 _Init_*** 初始化 HOOK
#define _HOOK_FUNCTION(RET, LIB, FUN, ...)				_HOOK_FUNCTION_(always_inline, RET, LIB, FUN, ##__VA_ARGS__)
#define _HOOK_MESSAGE(RET, CLS, MSG, ...)				_HOOK_MESSAGE_(always_inline, RET, CLS, MSG, , ##__VA_ARGS__)
#define _HOOK_META(RET, CLS, MSG, ...)					_HOOK_MESSAGE_(always_inline, RET, CLS, MSG, Meta, ##__VA_ARGS__)

// 自动初始化 HOOK
#define HOOK_FUNCTION(RET, LIB, FUN, ...)				_HOOK_FUNCTION_(constructor, RET, LIB, FUN, ##__VA_ARGS__)
#define HOOK_MESSAGE(RET, CLS, MSG, ...)				_HOOK_MESSAGE_(constructor, RET, CLS, MSG, , ##__VA_ARGS__)
#define HOOK_META(RET, CLS, MSG, ...)					_HOOK_MESSAGE_(constructor, RET, CLS, MSG, Meta, ##__VA_ARGS__)

//
#ifdef __cplusplus
extern "C"
#endif
void _HookFunction(const char *lib, const char *fun, void *hook, void **old);

//
#ifdef __cplusplus
extern "C"
#endif
void _HookMessage(Class cls, const char *msg, void *hook, void **old);
