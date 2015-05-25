//
//  CHRAppDelegate.m
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRAppDelegate.h"
#import "CHRRootViewController.h"
#import "CHRPreferences.h"

static NSString *const kCHRUserDefaultsRootWindowFrameKey = @"RootWindowFrame";

@implementation CHRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	CGSize windowSize = CGSizeMake(1000.f, 800.f);
	CGSize screenSize = [NSScreen mainScreen].frame.size;
	
	_rootWindowController = [[UXWindowController alloc] initWithRootViewController:[[CHRRootViewController alloc] init]];
	_rootWindowController.window.minSize = windowSize;
	_rootWindowController.window.contentSize = windowSize;
	_rootWindowController.window.frameOrigin = CGPointMake((screenSize.width - windowSize.width) / 2, (screenSize.height - windowSize.height) / 2);
	_rootWindowController.windowFrameAutosaveName = kCHRUserDefaultsRootWindowFrameKey;
	[_rootWindowController showWindow:self];
	
	[CHRPreferences sharedInstance].lastLaunch = [NSDate date];
    
	[_rootWindowController.window makeKeyAndOrderFront:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
