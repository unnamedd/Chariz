//
//  HBCNAppDelegate.h
//  Cynthia
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UXWindowController;

@interface HBCNAppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) UXWindowController *rootWindowController;

@end

