//
//  HBCNRootViewController.m
//  Cynthia
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNRootViewController.h"
#import "HBCNHomeViewController.h"
#import "HBCNSourcesViewController.h"
// #import "HBCNChangesViewController.h"
// #import "HBCNInstalledViewController.h"
// #import "HBCNSearchViewController.h"

@implementation HBCNRootViewController

- (void)loadView {
	[super loadView];
	
	self.viewControllers = @[
		[[HBCNHomeViewController alloc] init],
		[[HBCNSourcesViewController alloc] init],
		// [[HBCNChangesViewController alloc] init],
		// [[HBCNInstalledViewController alloc] init],
		// [[HBCNSearchViewController alloc] init]
	];
}

@end
