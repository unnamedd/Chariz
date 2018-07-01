//
//  AppDelegate.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ notification: Notification) {
		// if this is the first run
		if Preferences.sharedInstance.lastLaunch == .distantPast {
			// display the first run UI
			let storyboard = NSStoryboard(name: NSStoryboard.Name("FirstRun"), bundle: nil)
			let firstRunWindowController = storyboard.instantiateInitialController() as! NSWindowController
			NSApp.mainWindow!.beginSheet(firstRunWindowController.window!, completionHandler: nil)
		}

		// update the last launch date
		Preferences.sharedInstance.lastLaunch = Date()
	}

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		// when closing the window, quit the app
		return true
	}

}
