//
//  HBCNSetupProgressViewController.m
//  Cynthia
//
//  Created by Adam D on 16/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNSetupProgressViewController.h"

@implementation HBCNSetupProgressViewController {
	UXLabel *_detailLabel;
	NSProgressIndicator *_progressIndicator;
}

- (void)loadView {
	[super loadView];
	
	UXView *containerView = [[UXView alloc] init];
	containerView.autoresizingMask = UXViewAutoresizingFlexibleTopMargin | UXViewAutoresizingFlexibleRightMargin | UXViewAutoresizingFlexibleBottomMargin | UXViewAutoresizingFlexibleLeftMargin;
	[self.view addSubview:containerView];
	
	UXLabel *titleLabel = [[UXLabel alloc] init];
	titleLabel.font = [NSFont fontWithName:@"HelveticaNeue-Light" size:24.f];
	titleLabel.text = L18N(@"Setting up…");
	titleLabel.frame = CGRectMake(0, 0, containerView.frame.size.width, [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height);
	[containerView addSubview:titleLabel];
	
	_detailLabel = [[UXLabel alloc] init];
	_detailLabel.font = [NSFont systemFontOfSize:14.f];
	_detailLabel.text = L18N(@"Starting");
	_detailLabel.frame = CGRectMake(0, titleLabel.frame.size.height + 30.f, containerView.frame.size.width, [_detailLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height);
	[containerView addSubview:_detailLabel];
	
	_progressIndicator = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(0, _detailLabel.frame.origin.y + _detailLabel.frame.size.height, containerView.frame.size.width, 0)];
	_progressIndicator.style = NSProgressIndicatorBarStyle;
	_progressIndicator.maxValue = 1; // NSProgressIndicator is weird man
	[containerView addSubview:_progressIndicator];
	
	CGSize size = CGSizeMake(300.f, _progressIndicator.frame.origin.y + _progressIndicator.frame.size.height);
	containerView.frame = CGRectMake((self.view.frame.size.width - size.width) / 2, (self.view.frame.size.height - size.height) / 2, size.width, size.height);
}

@end
