//
//  HBCNWebViewController.m
//  Cynthia
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNWebViewController.h"
#import "HBCNEmailSendingController.h"

static NSString *const kHBCNWebViewUserScript = @"(function(window, undefined) {"
	"var handlers = webkit.messageHandlers;"
	"window.cynthia = {};"

	"for (var i in handlers) {"
		"if (handlers.hasOwnProperty(i)) {"
			"window.cynthia[i] = function() {"
				"handlers[i].postMessage.apply(this, arguments.length == 0 ? [ null ] : arguments);"
			"};"
		"}"
	"}"
"})(window, undefined)";

@implementation HBCNWebViewController

- (void)loadView {
	[super loadView];
	
	self.title = L18N(@"Untitled");
	
	WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
	configuration.preferences.plugInsEnabled = NO;
	configuration.preferences.javaEnabled = NO; // probably redundant?
	
	_userContentController = [[WKUserContentController alloc] init];
	[_userContentController addUserScript:[[WKUserScript alloc] initWithSource:kHBCNWebViewUserScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO]];
	configuration.userContentController = _userContentController;
	
	_webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
	_webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	_webView.UIDelegate = self;
	_webView.navigationDelegate = self;
	[self.view addSubview:_webView];
}

#pragma mark - WKUIDelegate

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
		
		HBCNEmailSendingController *emailSendingController = [[HBCNEmailSendingController alloc] init];
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
