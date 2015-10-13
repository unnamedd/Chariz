//
//  CHRHomeViewController.m
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRHomeViewController.h"
#import "CHRSearchField.h"

@implementation CHRHomeViewController

- (void)loadView {
	[super loadView];
	
	self.title = I18N(@"Home");
	self.navigationItem.rightBarButtonItem = [[UXBarButtonItem alloc] initWithCustomView:[[CHRSearchField alloc] init]];
	
	[self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"file:///tmp/test.html"]]];
	//[self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"featured" relativeToURL:[NSURL URLWithString:kCHRWebUIRootURL]]]];
}

@end
