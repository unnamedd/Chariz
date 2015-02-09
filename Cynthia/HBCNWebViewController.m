//
//  HBCNWebViewController.m
//  Cynthia
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNWebViewController.h"

@implementation HBCNWebViewController

- (void)loadView {
	[super loadView];
	
	self.title = @"Untitled";
	
	WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
	configuration.preferences.plugInsEnabled = NO;
	configuration.preferences.javaEnabled = NO; // probably redundant?
	
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

@end
