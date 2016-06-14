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

	let rootWindowController: UXWindowController?

	func applicationDidFinishLaunching(_ notification: Notification) {
		let rootViewController: UXViewController

		// if this is the first run
		if Preferences.sharedInstance.lastLaunch == nil {
			// display the first run UI
			rootViewController = UXNavigationController(rootViewController: CHRFirstLaunchViewController())
		} else {
			// use the usual UI
			rootViewController = CHRRootViewController()
		}

		// set up the root window
		rootWindowController = UXWindowController(rootViewController: rootViewController)

		// set the minimum size and default size
		rootWindowController.window.minSize = CGSizeMake(width: 1000, height: 500)
		rootWindowController.window.contentSize = CGSizeMake(width: 1000, height: 800)

		// center the window by default
		rootWindowController.window.center()

		// set the autosave preferences key, which remembers the position and size
		rootWindowController.windowFrameAutosaveName = Preferences.rootWindowFrameKey

		// show it!
		rootWindowController.showWindow(self)

		// update the last launch date
		Preferences.sharedInstance.lastLaunch = NSDate()
	}

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		// when closing the window, quit the app
		return true
	}

}
