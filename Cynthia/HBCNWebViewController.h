//
//  HBCNWebViewController.h
//  Cynthia
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "UXKit.h"
#import <WebKit/WebKit.h>

@interface HBCNWebViewController : UXViewController <WKUIDelegate, WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end
