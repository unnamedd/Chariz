//
//  HBCNEmailSendingController.m
//  Cynthia
//
//  Created by Adam D on 16/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "HBCNEmailSendingController.h"
#import "PrivateAPIs.h"
#import "Mail.h"
#include <sys/sysctl.h>

static NSString *const kHBCNEmailSendingControllerDpkgListURL = @"file:///tmp/cynthia_dpkgl.txt";

@implementation HBCNEmailSendingController {
	NSWindow *_window;
}

- (void)handleEmailWithURL:(NSURL *)url window:(NSWindow *)window {
	// oh goody, just over 100 lines to open a mail composer.
	// TODO: email signature doesn't get appended
	
	_window = window;
	
	NSURL *dpkglURL = [NSURL URLWithString:kHBCNEmailSendingControllerDpkgListURL];
	
	[self writeDpkgListToURL:dpkglURL completion:^(NSTask *task, NSError *dpkglError) {
		if (dpkglError) {
			[self displayError:dpkglError];
			return;
		}
	
		NSString *urlString = url.absoluteString;
		NSRange queryRange = [urlString rangeOfString:@"?"];
		NSDictionary *components = @{};
		NSString *address;
		
		if (queryRange.location != NSNotFound) {
			components = [urlString substringWithRange:NSMakeRange(queryRange.location + 1, urlString.length - queryRange.location - 1)].queryToDict;
			address = [url.resourceSpecifier substringToIndex:queryRange.location];
		} else {
			address = url.resourceSpecifier;
		}
		
		NSString *hardwareModel = @"?";
		
		size_t length = 0;
		sysctlbyname("hw.model", NULL, &length, NULL, 0);
		
		if (length) {
			char *hardwareModelChar = malloc(length * sizeof(char));
			sysctlbyname("hw.model", hardwareModelChar, &length, NULL, 0);
			hardwareModel = [NSString stringWithUTF8String:hardwareModelChar];
			free(hardwareModelChar);
		}
		
		MailApplication *mail = [SBApplication applicationWithBundleIdentifier:@"com.apple.Mail"];
		mail.delegate = self;
		
		MailOutgoingMessage *email = [[[mail classForScriptingClass:@"outgoing message"] alloc] initWithProperties:@{
			@"subject": components[@"subject"] ?: @"",
			@"content": [components[@"body"] ?: @"" stringByAppendingFormat:@"\n\n%@: %@, %@\n\n", L18N(@"Device information:"), [NSProcessInfo processInfo].operatingSystemVersionString, hardwareModel]
		}];
		
		[mail.outgoingMessages addObject:email];
		
		if (mail.lastError) {
			[self displayError:mail.lastError];
			return;
		}
		
		[email.toRecipients addObject:[[[mail classForScriptingClass:@"to recipient"] alloc] initWithProperties:@{ @"address": address }]];
		
		if (mail.lastError) {
			[self displayError:mail.lastError];
			return;
		}
		
		[email.content.attachments addObject:[[[mail classForScriptingClass:@"attachment"] alloc] initWithProperties:@{ @"fileName": dpkglURL }]];
		
		if (mail.lastError) {
			[self displayError:mail.lastError];
			return;
		}
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			NSError *removeError = nil;
			[[NSFileManager defaultManager] removeItemAtURL:dpkglURL error:&removeError];
			
			if (removeError) {
				NSLog(@"failed to remove %@: %@", dpkglURL, removeError);
			}
		});
	}];
}

- (void)displayError:(NSError *)error {
	[[NSAlert alertWithError:error] beginSheetModalForWindow:_window completionHandler:nil];
}

- (void)writeDpkgListToURL:(NSURL *)url completion:(void(^)(NSTask *task, NSError *error))completion {
	NSError *writeError = nil;
	[@"" writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
	
	if (writeError) {
		NSLog(@"error writing file: %@", writeError);
		completion(nil, writeError);
		return;
	}
	
	NSError *handleError = nil;
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingToURL:url error:&handleError];
	
	if (handleError) {
		NSLog(@"error creating file handle: %@", handleError);
		completion(nil, handleError);
		return;
	}
	
	NSTask *task = [[NSTask alloc] init];
	task.launchPath = @"/usr/local/bin/dpkg";
	task.arguments = @[ @"--list" ];
	task.standardOutput = fileHandle;
	task.terminationHandler = ^(NSTask *task) {
		completion(task, nil);
	};
	[task launch];
}

#pragma mark - SBApplicationDelegate

- (id)eventDidFail:(const AppleEvent *)event withError:(NSError *)error {
	NSLog(@"apple event failed: %@, %@", event, error);
	[[NSAlert alertWithError:error] beginSheetModalForWindow:_window completionHandler:nil];
	return nil;
}

@end
