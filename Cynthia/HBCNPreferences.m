//
//  HBCNPreferences.m
//  Cynthia
//
//  Created by Adam D on 15/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNPreferences.h"

static NSString *const kHBCNPreferencesLastLaunchKey = @"LastLaunch";

@implementation HBCNPreferences

+ (instancetype)sharedInstance {
	static HBCNPreferences *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self.class alloc] init];
	});
	
	return sharedInstance;
}

#pragma mark - Convenience methods

- (id)objectForKey:(id)key {
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key {
	[[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

#pragma mark - Preferences

- (NSDate *)lastLaunch {
	return [self objectForKey:kHBCNPreferencesLastLaunchKey];
}

- (void)setLastLaunch:(NSDate *)lastLaunch {
	[self setObject:lastLaunch forKey:kHBCNPreferencesLastLaunchKey];
}

@end
