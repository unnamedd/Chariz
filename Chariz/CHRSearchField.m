//
//  CHRSearchFieldView.m
//  Chariz
//
//  Created by Adam D on 25/05/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRSearchField.h"

@implementation CHRSearchField

- (instancetype)init {
	self = [super init];
	
	if (self) {
		self.frame = CGRectMake(0, 0, 160.f, 22.f);
	}
	
	return self;
}

- (CGSize)intrinsicContentSize {
	return self.frame.size;
}

@end
