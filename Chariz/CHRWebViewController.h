//
//  CHRWebViewController.h
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import <UXKit/UXKit.h>
#import <WebKit/WebKit.h>

@interface CHRWebViewController : UXViewController <WebUIDelegate, WebPolicyDelegate, WebFrameLoadDelegate>

@property (strong, nonatomic) WebView *webView;

@end
