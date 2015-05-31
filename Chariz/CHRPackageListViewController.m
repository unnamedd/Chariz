//
//  CHRPackageListViewController.m
//  Chariz
//
//  Created by Adam D on 7/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRPackageListViewController.h"

static NSString *const kCHRPackageCellReuseIdentifier = @"PackageCell";

@implementation CHRPackageListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = I18N(@"Packages");
	
	[self.tableView registerClass:UXTableViewCell.class forCellWithReuseIdentifier:kCHRPackageCellReuseIdentifier];
}

#pragma mark - Table View

- (NSUInteger)tableView:(UXTableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
}

- (UXTableViewCell *)tableView:(UXTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UXTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCHRPackageCellReuseIdentifier forIndexPath:indexPath];
	
	if (!cell) {
		cell = [[UXTableViewCell alloc] initWithStyle:UXTableViewCellStyleDefault reuseIdentifier:kCHRPackageCellReuseIdentifier];
	}
	
	cell.textLabel.text = @"hi";
	cell.detailTextLabel.text = @"hi";
	
	return cell;
}

@end
