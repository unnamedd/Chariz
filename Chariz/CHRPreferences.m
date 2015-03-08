//
//  CHRPreferences.m
//  Chariz
//
//  Created by Adam D on 15/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRPreferences.h"

static NSString *const kCHRPreferencesLastLaunchKey = @"LastLaunch";

@implementation CHRPreferences

+ (instancetype)sharedInstance {
	static CHRPreferences *sharedInstance = nil;
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
	return [self objectForKey:kCHRPreferencesLastLaunchKey];
}

- (void)setLastLaunch:(NSDate *)lastLaunch {
	[self setObject:lastLaunch forKey:kCHRPreferencesLastLaunchKey];
}

@end
