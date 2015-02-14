//
//  HBCNAppDelegate.m
//  Cynthia
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNAppDelegate.h"
#import "HBCNRootViewController.h"

static NSString *const kHBCNUserDefaultsRootWindowFrameKey = @"RootWindowFrame";

@implementation HBCNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	_rootWindowController = [[UXWindowController alloc] initWithRootViewController:[[UXNavigationController alloc] initWithRootViewController:[[HBCNRootViewController alloc] init]]];
	// _rootWindowController.windowFrameAutosaveName = kHBCNUserDefaultsRootWindowFrameKey; // TODO: fix default positioning
	_rootWindowController.window.contentSize = CGSizeMake(900.f, 800.f);
	[_rootWindowController showWindow:self];
}

@end
