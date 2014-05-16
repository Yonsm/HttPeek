
#import "HookMain.h"

//
@interface WebViewDelegate : NSObject <UIWebViewDelegate>
@end

NSMutableDictionary *_delegates;
WebViewDelegate *_webViewDelegate;

//
@implementation WebViewDelegate
//
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
	_LogRequest(request);
	NSLog(@"%@ shouldStartLoadWithRequest: %@, navigationType:%d", webView, [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (int)navigationType);
	id<UIWebViewDelegate> delegate = [_delegates objectForKey:[NSString stringWithFormat:@"%p", webView]];
	return [delegate respondsToSelector:@selector(webView: shouldStartLoadWithRequest: navigationType:)] ? [delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType] : YES;
}

//
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
	NSLog(@"%@ webViewDidStartLoad", webView);
	id<UIWebViewDelegate> delegate = [_delegates objectForKey:[NSString stringWithFormat:@"%p", webView]];
	if ([delegate respondsToSelector:@selector(webViewDidStartLoad:)]) [delegate webViewDidStartLoad:webView];
}

//
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
	NSLog(@"%@ webViewDidFinishLoad", webView);
	id<UIWebViewDelegate> delegate = [_delegates objectForKey:[NSString stringWithFormat:@"%p", webView]];
	if ([delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) [delegate webViewDidFinishLoad:webView];
}

//
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
	NSLog(@"%@ didFailLoadWithError", webView);
	id<UIWebViewDelegate> delegate = [_delegates objectForKey:[NSString stringWithFormat:@"%p", webView]];
	if ([delegate respondsToSelector:@selector(webView: didFailLoadWithError:)]) [delegate webView:webView didFailLoadWithError:error];
}

@end

//
NS_INLINE void LogWebView(UIWebView *webView)
{
	[_delegates setValue:webView.delegate forKey:[NSString stringWithFormat:@"%p", webView]];
	webView.delegate = _webViewDelegate;
}

//
MSGHOOK(void, UIWebView_loadData, NSData * data, NSString *MIMEType, NSString *encodingName, NSURL *baseURL)
{
	NSLog(@"UIWebView_loadData: %@", baseURL);
	LogWebView(self);
	_UIWebView_loadData(self, sel, data, MIMEType, encodingName, baseURL);
	
} ENDHOOK

//
MSGHOOK(void, UIWebView_loadHTMLString, NSString *string, NSURL *baseURL)
{
	NSLog(@"UIWebView_loadHTMLString: %@", baseURL);
	LogWebView(self);
	_UIWebView_loadHTMLString(self, sel, string, baseURL);
	
} ENDHOOK

//
MSGHOOK(void, UIWebView_loadRequest, NSURLRequest *request)
{
	NSLog(@"UIWebView_loadRequest: %@", request);
	LogWebView(self);
	_UIWebView_loadRequest(self, sel, request);
} ENDHOOK

//
void WebViewPeekInit(NSString *processName)
{
	_delegates = [[NSMutableDictionary alloc] init];
	_webViewDelegate = [[WebViewDelegate alloc] init];

	_HOOKMSG(UIWebView_loadData, UIWebView, loadData:MIMEType:textEncodingName:baseURL:);
	_HOOKMSG(UIWebView_loadHTMLString, UIWebView, loadHTMLString:baseURL:);
	_HOOKMSG(UIWebView_loadRequest, UIWebView, loadRequest:);
}
