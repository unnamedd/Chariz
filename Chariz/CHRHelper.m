//
//  CHRHelper.m
//  Chariz
//
//  Created by Mustafa Gezen on 15.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRHelper.h"

@implementation CHRHelper
+ (instancetype)sharedInstance {
	static CHRHelper *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self.class alloc] init];
	});
	
	return sharedInstance;
}

- (NSError *)blessService {
	CFErrorRef tError;
	
	if (!self->_authRef) {
		HBLogError(@"Failed to create AuthorizationRef.");
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Authorization failed"];
		[alert runModal];
		exit(0);
	} else {
		SMJobBless(kSMDomainSystemLaunchd, CFSTR("io.chariz.CharizHelper"), self->_authRef, &tError);
	}
	
	return (__bridge NSError *)(tError);
}

- (void)startXPCService {
	xpc_connection_t connection = xpc_connection_create_mach_service("io.chariz.CharizHelper", NULL, XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);
	
	if (!connection) {
		HBLogError(@"Connection could not be established");
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Connection to XPC could not be established"];
		[alert runModal];
		exit(0);
	} else {
		xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
			xpc_type_t type = xpc_get_type(event);
			
			if (type == XPC_TYPE_ERROR) {
				
				if (event == XPC_ERROR_CONNECTION_INTERRUPTED) {
					HBLogError(@"XPC connection interupted.");
					
				} else if (event == XPC_ERROR_CONNECTION_INVALID) {
					HBLogError(@"XPC connection invalid, releasing.");
					
				} else {
					HBLogError(@"Unexpected XPC connection error.");
				}
				
			} else {
				HBLogError(@"Unexpected XPC connection event.");
			}
		});
		
		xpc_connection_resume(connection);
		
		self->con = connection;
	}
}

- (void)sendXPCRequest:(const char *)message completed:(completed)comp {
	if (!self->con) {
		HBLogError(@"Establish XPC connection first");
		return;
	}
	
	xpc_object_t message_request = xpc_dictionary_create(NULL, NULL, 0);
	xpc_dictionary_set_string(message_request, "request", message);
	
	HBLogInfo(@"Sending request: %s", message);
	
	xpc_connection_send_message_with_reply(self->con, message_request, dispatch_get_main_queue(), ^(xpc_object_t event) {
		const char* response = xpc_dictionary_get_string(event, "reply");
		self->last_response = response;
		HBLogInfo(@"Received response: %s.", response);
		comp([NSString stringWithFormat:@"%s", response]);
	});
}

- (NSError *)authorize
{
	OSStatus                    err;
	AuthorizationExternalForm   extForm;
	
	AuthorizationItem authItem		= { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
	AuthorizationRights authRights	= { 1, &authItem };
	AuthorizationFlags flags		=	kAuthorizationFlagDefaults				|
	kAuthorizationFlagInteractionAllowed	|
	kAuthorizationFlagPreAuthorize			|
	kAuthorizationFlagExtendRights;
	
	err = AuthorizationCreate(&authRights, NULL, flags, &self->_authRef);
	if (err == errAuthorizationSuccess) {
		err = AuthorizationMakeExternalForm(self->_authRef, &extForm);
	}
	if (err == errAuthorizationSuccess) {
		self.authorization = [[NSData alloc] initWithBytes:&extForm length:sizeof(extForm)];
	} else if (err == errAuthorizationCanceled) {
		[[NSApplication sharedApplication] terminate:nil];
		return nil;
	}
	assert(err == errAuthorizationSuccess);
	
	return [self blessService];
}

- (NSString *)lastResponse {
	return [NSString stringWithFormat:@"%s", self->last_response];
}

#pragma mark Installation
- (void) check_brew:(completed)comp {
	self->_brew_installed = 0;
	[self _launchBrewTaskWithArguments:@[@"help"] completion:^(NSError *error, id json, NSString *output, NSString *errorOutput) {
		if ([output containsString:@"Example usage:"]) {
			self->_brew_installed = 1;
		}
		comp([NSString stringWithFormat:@"%ld", (long)self->_brew_installed]);
	 }];
}

- (void)install_brew:(completed)comp {
	[self _launchRubyTask:@[@"-e",@"\"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""] find:@"Installation successful!" completion:^(NSError *error, id json, NSString *output, NSString *errorOutput) {
		[self check_brew:^(NSString *lastResponse){
			
		}];
	}];
	
	if (self->_brew_installed == 1) {
		[self _launchBrewTaskWithArguments:@[@"help"] completion:^(NSError *error, id json, NSString *output, NSString *errorOutput) {
			if ([output containsString:@"Example usage:"]) {
				self->_install_status = @"";
			} else {
				self->_install_status = @"error_install_not_successful";
			}
			comp(self->_install_status);
		 }];
	} else {
		self->_install_status = @"error_install_not_started";
	}
}

- (void) check_dpkg:(completed)comp {
	[self _launchBrewTaskWithArguments:@[@"ls", @"--versions", @"dpkg-chariz"] completion:^(NSError *error, id json, NSString *output, NSString *errorOutput) {
		if ([output containsString:@"dpkg-chariz"]) {
			self->_dpkg_installed = 1;
		} else {
			self->_dpkg_installed = 0;
		}
		comp([NSString stringWithFormat:@"%ld", (long)self->_dpkg_installed]);
	}];
}

- (void) install_dpkg:(completed)comp {
	[self _launchBrewTaskWithArguments:@[@"uninstall", @"dpkg"] completion:^(NSError *error, id json, NSString *output, NSString *errorOutput) {
		
	}];
	
	self->_dpkg_installed = 0;
	[self _launchBrewTaskWithArguments:@[@"install", @"CharizTeam/chariz/dpkg-chariz"] completion:^(NSError *error, id json, NSString *output, NSString *errorOutput) {
		[self check_dpkg:^(NSString *lastResponse){
			
		}];
		comp([NSString stringWithFormat:@"%ld", (long)self->_dpkg_installed]);
	 }];
}

- (NSInteger)brew_installed {
	return self->_brew_installed;
}

- (NSString *)install_status {
	return self->_install_status;
}

- (NSInteger)dpkg_installed {
	return self->_dpkg_installed;
}

#pragma mark Tasks

-(void) _launchRubyTask:(NSArray*)args find:(NSString*)find completion:(comp)completion {
	NSTask *task = [[NSTask alloc] init];
	task.launchPath = @"/usr/bin/ruby";
	task.arguments = args;
	task.standardOutput = [NSPipe pipe];
	task.standardError = [NSPipe pipe];

	task.terminationHandler = ^(NSTask *task) {
		NSError *error = nil;
		
		if (task.terminationStatus) {
			error = [NSError errorWithDomain:@"io.chariz.CharizHelper" code:task.terminationStatus userInfo:@{
																										   NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Ruby task failed with error code: %d.", task.terminationStatus]
																										   }];
		}
		
		NSData *outputData = ((NSPipe *)task.standardOutput).fileHandleForReading.readDataToEndOfFile;
		
		NSString *output = nil;
		output = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
		
		NSString *errorOutput = [[NSString alloc] initWithData:((NSPipe *)task.standardError).fileHandleForReading.readDataToEndOfFile encoding:NSUTF8StringEncoding];
		
		if ([output containsString:find]) {
			output = find;
		} else {
			output = @"";
		}
		
		completion(error, nil, output, errorOutput);
		HBLogInfo(@"[Chariz] %@", output);
	};
	
	[task launch];
}

- (void)_launchBrewTaskWithArguments:(NSArray *)arguments completion:(comp)completion {
	NSTask *task = [[NSTask alloc] init];
	task.launchPath = @"/usr/local/bin/brew";
	task.arguments = arguments;
	task.standardOutput = [NSPipe pipe];
	task.standardError = [NSPipe pipe];

	task.terminationHandler = ^(NSTask *task) {
		NSError *error = nil;
		
		if (task.terminationStatus) {
			error = [NSError errorWithDomain:@"io.chariz.CharizHelper" code:task.terminationStatus userInfo:@{
																										   NSLocalizedDescriptionKey: [NSString stringWithFormat:@"The Homebrew package manager returned an error with code %d.", task.terminationStatus]
																										   }];
		}
		
		NSData *outputData = ((NSPipe *)task.standardOutput).fileHandleForReading.readDataToEndOfFile;
		
		NSString *output = nil;
		output = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
		
		NSString *errorOutput = [[NSString alloc] initWithData:((NSPipe *)task.standardError).fileHandleForReading.readDataToEndOfFile encoding:NSUTF8StringEncoding];
		
		completion(error, nil, output, errorOutput);
		HBLogInfo(@"[Chariz] %@", output);
		HBLogError(@"[Chariz] %@", errorOutput);
	};
	
	[task launch];
}

@end
