//
//  CHRSourcesListViewController.m
//  Chariz
//
//  Created by Adam D on 8/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRSourcesListViewController.h"

@implementation CHRSourcesListViewController

- (void)loadView {
	[super loadView];
	
	self.title = L18N(@"Sources");
	
	[self.tableView registerClass:UXTableViewCell.class forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Table View

- (NSUInteger)tableView:(UXTableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
}

- (UXTableViewCell *)tableView:(UXTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.tableView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

@end
