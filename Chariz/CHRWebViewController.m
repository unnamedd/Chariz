//
//  CHRWebViewController.m
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRWebViewController.h"
#import "CHREmailSendingController.h"
#import "CHRLoadingIndicatorView.h"

static NSString *const kCHRWebViewUserScript = @"(function(window, undefined) {"
	"var handlers = webkit.messageHandlers;"
	"window.chariz = {};"

	"for (var i in handlers) {"
		"if (handlers.hasOwnProperty(i)) {"
			"window.chariz[i] = function() {"
				"handlers[i].postMessage.apply(this, arguments.length == 0 ? [ null ] : arguments);"
			"};"
		"}"
	"}"
"})(window, undefined)";

@implementation CHRWebViewController {
	CHRLoadingIndicatorView *_loadingIndicatorView;
}

- (void)loadView {
	[super loadView];
	
	self.title = L18N(@"Untitled");
	
	WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
	configuration.preferences.plugInsEnabled = NO;
	configuration.preferences.javaEnabled = NO; // probably redundant?
	
	_userContentController = [[WKUserContentController alloc] init];
	[_userContentController addUserScript:[[WKUserScript alloc] initWithSource:kCHRWebViewUserScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO]];
	configuration.userContentController = _userContentController;
	
	_webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
	_webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	_webView.UIDelegate = self;
	_webView.navigationDelegate = self;
	[self.view addSubview:_webView];
	
	_loadingIndicatorView = [[CHRLoadingIndicatorView alloc] init];
	self.navigationItem.leftBarButtonItem = [[UXBarButtonItem alloc] initWithCustomView:_loadingIndicatorView];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	[_loadingIndicatorView startAnimation:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	[_loadingIndicatorView stopAnimation:nil];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
	// TODO: implement
	return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler {
	// TODO: implement
	NSLog(@"alert: %@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
	// TODO: implement
	NSLog(@"confirm: %@", message);
	completionHandler(NO);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler {
	// TODO: implement
	NSLog(@"prompt: %@", prompt);
	completionHandler(@"");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
	if ([navigationAction.request.URL.scheme isEqualToString:@"mailto"]) {
		decisionHandler(WKNavigationActionPolicyCancel);
		
		CHREmailSendingController *emailSendingController = [[CHREmailSendingController alloc] init];
		[emailSendingController handleEmailWithURL:navigationAction.request.URL window:self.view.window];
	} else {
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
	NSLog(@"unhandled script message: %@", message);
}

@end
