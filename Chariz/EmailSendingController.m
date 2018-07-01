//
//  EmailSendingController.m
//  Chariz
//
//  Created by Adam D on 16/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "EmailSendingController.h"
#import "Mail.h"
#include <sys/sysctl.h>

static NSString *const kEmailSendingControllerDpkgListURL = @"file:///tmp/chariz_dpkgl.txt";

@implementation EmailSendingController {
	NSWindow *_window;
}

- (void)handleEmailWithURL:(NSURL *)url window:(NSWindow *)window {
	// oh goody, just over 100 lines to open a mail composer.
	// TODO: email signature doesn't get appended
	
	_window = window;
	
	NSURL *dpkglURL = [NSURL URLWithString:kEmailSendingControllerDpkgListURL];
	
	[self writeDpkgListToURL:dpkglURL completion:^(NSTask *task, NSError *dpkglError) {
		if (dpkglError) {
			[self displayError:dpkglError];
			return;
		}
	
		NSString *urlString = url.absoluteString;
		NSRange queryRange = [urlString rangeOfString:@"?"];
		NSMutableDictionary <NSString *, NSString *> *query = [NSMutableDictionary dictionary];
		NSString *address;
		
		if (queryRange.location != NSNotFound) {
			NSURLComponents *components = [[NSURLComponents alloc] init];
			components.query = [urlString substringWithRange:NSMakeRange(queryRange.location + 1, urlString.length - queryRange.location - 1)];
			
			for (NSURLQueryItem *item in components.queryItems) {
				query[item.name] = item.value;
			}

			address = query[@"to"] ?: [url.resourceSpecifier substringToIndex:queryRange.location];
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
		
		NSString *bodyDeviceInfo = [NSString stringWithFormat:@"\n\n%@: %@, %@\n\n", NSLocalizedString(@"Device information:", @""), [NSProcessInfo processInfo].operatingSystemVersionString, hardwareModel];
		
		MailOutgoingMessage *email = [[[mail classForScriptingClass:@"outgoing message"] alloc] initWithProperties:@{
			@"subject": query[@"subject"] ?: @"",
			@"content": [query[@"body"] ?: @"" stringByAppendingString:bodyDeviceInfo]
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
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			NSError *removeError = nil;
			[[NSFileManager defaultManager] removeItemAtURL:dpkglURL error:&removeError];
			
			if (removeError) {
				HBLogError(@"failed to remove %@: %@", dpkglURL, removeError);
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
		HBLogError(@"error writing file: %@", writeError);
		completion(nil, writeError);
		return;
	}
	
	NSError *handleError = nil;
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingToURL:url error:&handleError];
	
	if (handleError) {
		HBLogError(@"error creating file handle: %@", handleError);
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
	HBLogError(@"apple event failed: %@, %@", event, error);
	[[NSAlert alertWithError:error] beginSheetModalForWindow:_window completionHandler:nil];
	return nil;
}

@end
