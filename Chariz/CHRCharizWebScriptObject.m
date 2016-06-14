//
//  CHRCharizWebScriptObject.m
//  Chariz
//
//  Created by Adam D on 13/07/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

@import CPM;
@import WebKit;

#import "CHRCharizWebScriptObject.h"

@implementation CHRCharizWebScriptObject

+ (NSString *)webScriptNameForSelector:(SEL)selector {
	if (selector == @selector(getPackageById:)) {
		return @"getPackageById";
	} else {
		return nil;
	}
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
	return ![self webScriptNameForSelector:selector];
}

- (instancetype)init {
	self = [super init];
	
	if (self) {
		_packageManagerAggregate = [CPMPackageManagerAggregate sharedInstance];
	}
	
	return self;
}

- (id <CPMPackage>)getPackageById:(NSString *)identifier {
	__block id <CPMPackage> package = nil;
	
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	
	[_packageManagerAggregate packagesForIdentifiers:@[ identifier ] completion:^(NSDictionary *packages, NSError *error) {
		if (error) {
			[WebScriptObject throwException:nil];
		}
		
		package = packages[identifier];
		
		dispatch_semaphore_signal(semaphore);
	}];
	
	dispatch_semaphore_wait(semaphore, 2);
	return package;
}

@end
