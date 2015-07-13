//
//  CHRFirstLaunchViewController.m
//  Chariz
//
//  Created by Mustafa Gezen on 14.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRFirstLaunchViewController.h"
#import "CHRLoadingIndicatorView.h"
#import "CHRHelper.h"
#import "CHRPreferences.h"

#import <ServiceManagement/ServiceManagement.h>
#import <Security/Authorization.h>

@implementation CHRFirstLaunchViewController

- (void)loadView {
    [super loadView];
	
	self.title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
	
	NSURL *html = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"first_launch" ofType:@"html"] isDirectory:NO];
	[self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:html]];
}

#pragma mark - Web View

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id <WebPolicyDecisionListener>)listener {
	if ([request.URL.scheme isEqualToString:@"startinstall"]) {
		[listener ignore];
		CHRHelper *helper = [CHRHelper sharedInstance];
		NSError *createHelper = [helper authorize];
		if (createHelper) {
			HBLogError(@"Failed to create Helper. Error: %@", createHelper);
			NSAlert *alert = [[NSAlert alloc] init];
			[alert setMessageText:[NSString stringWithFormat:@"Failed to create Helper. Error: %@", createHelper]];
			[alert runModal];
			exit(0);
		} else {
			[helper startXPCService];
			[helper check_brew:^(NSString *lastResponse){
				if ([helper brew_installed] == 0) {
					HBLogInfo(@"Installing Homebrew");
#warning [self.webView.mainFrame evaluateJavaScript:@"window.location.href = '#Installing Homebrew'" completionHandler:nil];
					[helper install_brew:^(NSString *lastResponse){
						if ([[helper install_status] containsString:@"error"]) {
							HBLogError(@"[Chariz] Error: %@", [helper install_status]);
							NSAlert *alert = [[NSAlert alloc] init];
							[alert setMessageText:[NSString stringWithFormat:@"[Chariz] Error: %@", [helper install_status]]];
							[alert runModal];
							exit(0);
						}
					}];
				} else {
#warning [self.webView evaluateJavaScript:@"window.location.href = '#Installing dpkg'" completionHandler:nil];
					[helper check_dpkg:^(NSString *lastResponse){
						if ([helper dpkg_installed] == 0) {
							[helper install_dpkg:^(NSString *lastResponse){
								if ([helper dpkg_installed] == 0) {
									HBLogError(@"[Chariz] Error: DPKG could not be installed");
									NSAlert *alert = [[NSAlert alloc] init];
									[alert setMessageText:[NSString stringWithFormat:@"[Chariz] Error: DPKG could not be installed"]];
									[alert runModal];
									exit(0);
								} else {
#warning [self.webView evaluateJavaScript:@"window.location.href = '#Done! Chariz will now restart!'" completionHandler:nil];
									NSTask *task = [[NSTask alloc] init];
									NSMutableArray *args = [NSMutableArray array];
									[args addObject:@"-c"];
									[args addObject:[NSString stringWithFormat:@"sleep 6; open \"%@\"", [[NSBundle mainBundle] bundlePath]]];
									[task setLaunchPath:@"/bin/sh"];
									[task setArguments:args];
									[task launch];
									
									dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
										[NSApp terminate:nil];
									});
								}
							}];
						} else {
#warning [self.webView evaluateJavaScript:@"window.location.href = '#Done! Chariz will now restart!'" completionHandler:nil];
							NSTask *task = [[NSTask alloc] init];
							NSMutableArray *args = [NSMutableArray array];
							[args addObject:@"-c"];
							[args addObject:[NSString stringWithFormat:@"sleep 6; open \"%@\"", [[NSBundle mainBundle] bundlePath]]];
							[task setLaunchPath:@"/bin/sh"];
							[task setArguments:args];
							[task launch];
							
							dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
								[NSApp terminate:nil];
							});
						}
					}];
				}
			}];
		}
	} else if ([request.URL.scheme isEqualToString:@"chariz"]) {
		[listener ignore];
		
		[[CHRHelper sharedInstance] startXPCService];
		
		NSString * requestURL = [[NSString stringWithFormat:@"%@", request.URL] stringByReplacingOccurrencesOfString:@"chariz://" withString:@""];
		
		NSArray * splitted_request = [requestURL componentsSeparatedByString:@"%7CAction%7C"];
		
		if ([splitted_request[0] isEqual: @"install"]) {
			[[CHRHelper sharedInstance] sendXPCRequest:[[NSString stringWithFormat:@"dpkg download |%@,%@", splitted_request[1], [[NSString stringWithFormat:@"%@", splitted_request[1]] lastPathComponent]] UTF8String] completed:^(NSString *lastResponse){
				
				NSString *resp = @"";
				
				if ([lastResponse isEqualToString:@""]) {
					resp = @"Successful!";
				} else {
					resp = @"Failed!";
				}
				
				NSAlert *alert = [[NSAlert alloc] init];
				[alert setMessageText:[NSString stringWithFormat:@"[Chariz] %@", resp]];
				[alert runModal];
			}];
		}
	} else {
		[super webView:webView decidePolicyForNavigationAction:actionInformation request:request frame:frame decisionListener:listener];
	}
}

@end