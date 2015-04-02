

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
	NSLog(@"%s: %@, %@, navigationType:%d", __FUNCTION__, webView, [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (int)navigationType);
	id<UIWebViewDelegate> delegate = [_delegates objectForKey:[NSString stringWithFormat:@"%p", webView]];
	return [delegate respondsToSelector:@selector(webView: shouldStartLoadWithRequest: navigationType:)] ? [delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType] : YES;
}

//
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
	NSLog(@"%s: %@", __FUNCTION__, webView);
	id<UIWebViewDelegate> delegate = [_delegates objectForKey:[NSString stringWithFormat:@"%p", webView]];
	if ([delegate respondsToSelector:@selector(webViewDidStartLoad:)]) [delegate webViewDidStartLoad:webView];
}

//
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
	NSLog(@"%s: %@", __FUNCTION__, webView);
	id<UIWebViewDelegate> delegate = [_delegates objectForKey:[NSString stringWithFormat:@"%p", webView]];
	if ([delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) [delegate webViewDidFinishLoad:webView];
}

//
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
	NSLog(@"%s: %@", __FUNCTION__, webView);
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
HOOK_MESSAGE(void, UIWebView, loadData_MIMEType_textEncodingName_baseURL_, NSData * data, NSString *MIMEType, NSString *encodingName, NSURL *baseURL)
{
	NSLog(@"%s: %@", __FUNCTION__, baseURL);
	LogWebView(self);
	_UIWebView_loadData_MIMEType_textEncodingName_baseURL_(self, sel, data, MIMEType, encodingName, baseURL);
}

//
HOOK_MESSAGE(void, UIWebView, loadHTMLString_baseURL_, NSString *string, NSURL *baseURL)
{
	NSLog(@"%s: %@", __FUNCTION__, baseURL);
	LogWebView(self);
	_UIWebView_loadHTMLString_baseURL_(self, sel, string, baseURL);

}

//
HOOK_MESSAGE(void, UIWebView, loadRequest_, NSURLRequest *request)
{
	NSLog(@"%s: %@", __FUNCTION__, request);
	LogWebView(self);
	_UIWebView_loadRequest_(self, sel, request);
}
