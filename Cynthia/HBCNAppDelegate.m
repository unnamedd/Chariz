//
//  HBCNAppDelegate.m
//  Cynthia
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNAppDelegate.h"
#import "HBCNRootViewController.h"
#import "HBCNPreferences.h"

static NSString *const kHBCNUserDefaultsRootWindowFrameKey = @"RootWindowFrame";

@implementation HBCNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	CGSize windowSize = CGSizeMake(1000.f, 800.f);
	CGSize screenSize = [NSScreen mainScreen].frame.size;
	
	_rootWindowController = [[UXWindowController alloc] initWithRootViewController:[[UXNavigationController alloc] initWithRootViewController:[[HBCNRootViewController alloc] init]]];
	_rootWindowController.window.minSize = windowSize;
	_rootWindowController.window.contentSize = windowSize;
	_rootWindowController.window.frameOrigin = CGPointMake((screenSize.width - windowSize.width) / 2, (screenSize.height - windowSize.height) / 2);
	_rootWindowController.windowFrameAutosaveName = kHBCNUserDefaultsRootWindowFrameKey;
	[_rootWindowController showWindow:self];
	
	[HBCNPreferences sharedInstance].lastLaunch = [NSDate date];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
