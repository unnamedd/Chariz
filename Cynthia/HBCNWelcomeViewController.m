//
//  HBCNWelcomeViewController.m
//  Cynthia
//
//  Created by Adam D on 15/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNWelcomeViewController.h"
#import "HBCNSetupProgressViewController.h"

static NSString *const kHBCNWelcomeViewControllerBeginSetupKey = @"beginSetup";

@implementation HBCNWelcomeViewController

- (void)loadView {
	[super loadView];
	
	self.title = L18N(@"Welcome");
	
	[self.userContentController addScriptMessageHandler:self name:kHBCNWelcomeViewControllerBeginSetupKey];
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cynthia.tmnlsthrn.com/ui/osx/1.0/welcome/"]]];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
	if ([message.name isEqualToString:kHBCNWelcomeViewControllerBeginSetupKey]) {
		[self.navigationController pushViewController:[[HBCNSetupProgressViewController alloc] init] animated:YES];
	}
}

@end
