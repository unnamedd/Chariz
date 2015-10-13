//
//  CHREmailSendingController.h
//  Chariz
//
//  Created by Adam D on 16/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

@import Foundation;
@import ScriptingBridge;

@interface CHREmailSendingController : NSObject <SBApplicationDelegate>

- (void)handleEmailWithURL:(NSURL *)url window:(NSWindow *)window;

@end
