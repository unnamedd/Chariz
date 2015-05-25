//
//  CHRChangesViewController.h
//  Chariz
//
//  Created by Adam D on 20/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRPackageListViewController.h"

typedef NS_ENUM(NSUInteger, CHRRefreshState) {
	CHRRefreshStateIdle,
	CHRRefreshStateRefreshing,
	CHRRefreshStateOffline
};

@interface CHRChangesViewController : CHRPackageListViewController

@property CHRRefreshState refreshState;

@end
