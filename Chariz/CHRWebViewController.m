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
#import "CHRCharizWebScriptObject.h"

@implementation CHRWebViewController {
	CHRLoadingIndicatorView *_loadingIndicatorView;
	NSURLRequest *_initialRequest;
}

+ (Class)viewControllerClassForURL:(NSURL *)url {
	// TODO: implement
	HBLogInfo(@"url: %@", url);
	return CHRWebViewController.class;
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
	self = [super init];
	
	if (self) {
		_initialRequest = [request copy];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.title = I18N(@"Untitled");
	
	_webView = [[WebView alloc] initWithFrame:self.view.bounds];
	_webView.autoresizingMask = UXViewAutoresizingFlexibleWidth | UXViewAutoresizingFlexibleHeight;
	_webView.UIDelegate = self;
	_webView.policyDelegate = self;
	_webView.frameLoadDelegate = self;
	[self.view addSubview:_webView];
	
	_loadingIndicatorView = [[CHRLoadingIndicatorView alloc] init];
	self.navigationItem.leftBarButtonItem = [[UXBarButtonItem alloc] initWithCustomView:_loadingIndicatorView];
	
	if (_initialRequest) {
		[_webView.mainFrame loadRequest:_initialRequest];
		_initialRequest = nil;
	}
}

#pragma mark - WebKit

- (void)webView:(WebView *)webView didStartProvisionalLoadForFrame:(WebFrame *)webFrame {
	[_loadingIndicatorView startAnimation:nil];
}

- (void)webView:(WebView *)webView didCommitLoadForFrame:(WebFrame *)webFrame {
	[_loadingIndicatorView stopAnimation:nil];
}

- (WebView *)webView:(WebView *)webView createWebViewWithRequest:(NSURLRequest *)request {
	Class viewControllerClass = [self.class viewControllerClassForURL:request.URL];
	
	CHRWebViewController *viewController = [[viewControllerClass alloc] initWithRequest:request];
	[self.navigationController pushViewController:viewController animated:YES];
	
	return viewController.webView;
}

- (void)webView:(WebView *)webView didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
	[[NSAlert alertWithError:error] beginSheetModalForWindow:self.view.window completionHandler:nil];
}

- (void)webView:(WebView *)webView didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
	[[NSAlert alertWithError:error] beginSheetModalForWindow:self.view.window completionHandler:nil];
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id <WebPolicyDecisionListener>)listener {
	if ([request.URL.scheme isEqualToString:@"mailto"]) {
		[listener ignore];
		
		CHREmailSendingController *emailSendingController = [[CHREmailSendingController alloc] init];
		[emailSendingController handleEmailWithURL:request.URL window:self.view.window];
	} else {
		[listener use];
	}
}

- (void)webView:(WebView *)webView didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
	NSURL *url = frame.dataSource.request.URL;
	
	{//if ([url.scheme isEqualToString:@"https"] && [url.host isEqualToString:[NSURL URLWithString:kCHRWebUIRootURL].host]) {
		// TODO: implement cydia API compatible object
		[windowObject setValue:[[CHRCharizWebScriptObject alloc] init] forKey:@"chariz"];
	}
}

@end
