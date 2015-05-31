//
//  CHRChangesViewController.m
//  Chariz
//
//  Created by Adam D on 20/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRChangesViewController.h"
#import "CHRRefreshStatusView.h"

@implementation CHRChangesViewController {
	CHRRefreshState _refreshState;
	UXView *_refreshStatusView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = I18N(@"Recent");
	self.refreshState = CHRRefreshStateIdle;
	
	_refreshStatusView = [[CHRRefreshStatusView alloc] init];
}

- (CHRRefreshState)refreshState {
	return _refreshState;
}

- (void)setRefreshState:(CHRRefreshState)refreshState {
	_refreshState = refreshState;
	
	switch (refreshState) {
		case CHRRefreshStateIdle:
		{
			self.navigationItem.leftBarButtonItem = [[UXBarButtonItem alloc] initWithImage:[NSImage imageNamed:NSImageNameRefreshTemplate] style:UXBarButtonItemStyleBordered target:self action:@selector(beginRefresh)];
			break;
		}
		
		case CHRRefreshStateRefreshing:
			self.navigationItem.leftBarButtonItem = [[UXBarButtonItem alloc] initWithCustomView:_refreshStatusView];
			break;
		
		case CHRRefreshStateOffline:
			self.navigationItem.leftBarButtonItem.enabled = NO;
			break;
	}
}

- (void)beginRefresh {
	self.refreshState = CHRRefreshStateRefreshing;
}

@end
