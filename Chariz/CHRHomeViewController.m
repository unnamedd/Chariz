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
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"/featured/" relativeToURL:[NSURL URLWithString:kCHRWebUIRootURL]]]];
	
	NSSearchField *searchField = [[NSSearchField alloc] initWithFrame:CGRectMake(0, 0, 150.f, 22.f)];
	// searchField.delegate = self;
	searchField.shadow = [[NSShadow alloc] init];
	
	NSSearchFieldCell *searchCell = searchField.cell;
	searchCell.wraps = NO;
	searchCell.scrollable = YES;
	
	self.navigationItem.rightBarButtonItem = [[UXBarButtonItem alloc] initWithCustomView:searchField];
}

@end
