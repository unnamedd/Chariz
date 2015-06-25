//
//  CHRPreferences.m
//  Chariz
//
//  Created by Adam D on 15/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRPreferences.h"

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

- (id)objectForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (BOOL)boolForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

- (void)setBool:(BOOL)object forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setBool:object forKey:key];
}

#pragma mark - Preferences

- (NSDate *)lastLaunch {
	return [self objectForKey:kCHRPreferencesLastLaunchKey];
}

- (void)setLastLaunch:(NSDate *)lastLaunch {
	[self setObject:lastLaunch forKey:kCHRPreferencesLastLaunchKey];
}

@end
