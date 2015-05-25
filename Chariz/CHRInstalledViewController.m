//
//  CHRInstalledViewController.m
//  Chariz
//
//  Created by Adam D on 20/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRInstalledViewController.h"

@implementation CHRInstalledViewController

- (void)loadView {
	[super loadView];
	
	self.title = L18N(@"Installed");
}

#pragma mark - UXTableView

- (NSUInteger)numberOfSectionsInTableView:(UXTableView *)tableView {
	return 1;
}

- (NSUInteger)tableView:(UXTableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

@end
