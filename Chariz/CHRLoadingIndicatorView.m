//
//  CHRLoadingIndicatorView.m
//  Chariz
//
//  Created by Adam D on 25/05/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRLoadingIndicatorView.h"

@implementation CHRLoadingIndicatorView

- (instancetype)init {
	self = [super init];
	
	if (self) {
		self.frame = CGRectMake(0, 0, 22.f, 22.f);
		self.style = NSProgressIndicatorSpinningStyle;
		self.controlSize = NSSmallControlSize;
		
		/*
		 funny, the docs say this should already be NO if we're using a spinning
		 indicator. but, here i am having to set it myself...
		*/
		self.displayedWhenStopped = NO;
	}
	
	return self;
}

- (CGSize)intrinsicContentSize {
	return self.frame.size;
}

@end
