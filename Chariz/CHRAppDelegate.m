//
//  CHRAppDelegate.m
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRAppDelegate.h"
#import "CHRRootViewController.h"
#import "CHRFirstLaunchViewController.h"
#import "CHRPreferences.h"

@implementation CHRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	UXViewController *rootViewController;
	
	if ([CHRPreferences sharedInstance].lastLaunch) {
		rootViewController = [[CHRRootViewController alloc] init];
	} else {
		rootViewController = [[UXNavigationController alloc] initWithRootViewController:[[CHRFirstLaunchViewController alloc] init]];
	}
	
	_rootWindowController = [[UXWindowController alloc] initWithRootViewController:rootViewController];
	_rootWindowController.window.minSize = CGSizeMake(1000.f, 500.f);
	_rootWindowController.window.contentSize = CGSizeMake(1000.f, 800.f);
	[_rootWindowController.window center];
	_rootWindowController.windowFrameAutosaveName = kCHRPreferencesRootWindowFrameKey;
	[_rootWindowController showWindow:self];
	
	[CHRPreferences sharedInstance].lastLaunch = [NSDate date];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
