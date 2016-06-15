//
//  HelperController.h
//  Chariz
//
//  Created by Mustafa Gezen on 15.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

@import Foundation;
@import ServiceManagement;
@import Security;

@interface HelperController : NSObject {
	xpc_connection_t con;
	const char* last_response;
	NSInteger _brew_installed;
	NSString *_install_status;
	NSInteger _dpkg_installed;
	AuthorizationRef _authRef;
}
@property (atomic, copy,   readwrite) NSData * authorization;
+ (instancetype)sharedInstance;
- (NSError *)blessService;
- (void)startXPCService;
typedef void(^completed)(NSString *lastResponse);
- (void)sendXPCRequest:(const char *)message completed:(completed)comp;
- (NSError *)authorize;
- (NSString *)lastResponse;
- (void) check_brew:(completed)comp;
- (void)install_brew:(completed)comp;
- (void) check_dpkg:(completed)comp;
- (void) install_dpkg:(completed)comp;
- (NSString *)install_status;
- (NSInteger)dpkg_installed;
- (NSInteger)brew_installed;
typedef void (^comp)(NSError *error, id json, NSString *output, NSString *errorOutput);
@end
