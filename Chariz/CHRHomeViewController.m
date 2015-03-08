//
//  CHRHomeViewController.m
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRHomeViewController.h"

@implementation CHRHomeViewController

- (void)loadView {
	[super loadView];
	
	self.title = L18N(@"Home");
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://chariz.tmnlsthrn.com/ui/osx/1.0/featured/"]]];
}

@end
