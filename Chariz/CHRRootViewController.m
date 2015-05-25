//
//  CHRRootViewController.m
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRRootViewController.h"
#import "CHRHomeViewController.h"
#import "CHRSourcesViewController.h"
#import "CHRChangesViewController.h"
#import "CHRInstalledViewController.h"

@implementation CHRRootViewController

- (void)loadView {
	[super loadView];
	
	self.rootViewControllers = @[
		[[CHRHomeViewController alloc] init],
		[[CHRSourcesViewController alloc] init],
		[[CHRChangesViewController alloc] init],
		[[CHRInstalledViewController alloc] init]
	];
}

@end
