//
//  CHRSourcesViewController.m
//  Chariz
//
//  Created by Adam D on 7/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRSourcesViewController.h"
#import "CHRSourcesListViewController.h"

@implementation CHRSourcesViewController

- (void)loadView {
	[super loadView];
	
	self.title = I18N(@"Sources");
	
	NSSplitView *splitView = [[NSSplitView alloc] initWithFrame:self.view.bounds];
	splitView.autoresizingMask = UXViewAutoresizingFlexibleWidth | UXViewAutoresizingFlexibleHeight;
	splitView.dividerStyle = NSSplitViewDividerStyleThin;
	[self.view addSubview:splitView];
	
	NSOutlineView *sidebarOutlineView = [[NSOutlineView alloc] initWithFrame:CGRectMake(0, 0, 220.f, splitView.frame.size.height)];
	sidebarOutlineView.autoresizingMask = UXViewAutoresizingFlexibleHeight | UXViewAutoresizingFlexibleRightMargin;
	sidebarOutlineView.backgroundColor = [NSColor purpleColor];
	[splitView addSubview:sidebarOutlineView];
	
	CHRPackageListViewController *viewController = [[CHRPackageListViewController alloc] init];
	viewController.view.autoresizingMask = UXViewAutoresizingFlexibleHeight;
	viewController.view.frame = CGRectMake(sidebarOutlineView.frame.size.width, 0, splitView.frame.size.width - sidebarOutlineView.frame.size.width, splitView.frame.size.height);
	
	[viewController willMoveToParentViewController:self];
	[self addChildViewController:viewController];
	[splitView addSubview:viewController.view];
	[viewController didMoveToParentViewController:self];
}

@end
