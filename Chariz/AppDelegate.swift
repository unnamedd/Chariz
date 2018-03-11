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

	var rootWindowController: UXWindowController!

	func applicationDidFinishLaunching(_ notification: Notification) {
		let rootViewController: UXViewController

		// if this is the first run
		if Preferences.sharedInstance.lastLaunch == .distantPast {
			// display the first run UI
			// TODO: needs to be rewritten and swiftified™
			// rootViewController = UXNavigationController(rootViewController: CHRFirstLaunchViewController())
			rootViewController = UXNavigationController()
		} else {
			// use the usual UI
			rootViewController = RootViewController()
		}

		// set up the root window
		rootWindowController = UXWindowController(rootViewController: rootViewController)

		// set the minimum size and default size
		rootWindowController.window!.minSize = CGSize(width: 1000, height: 500)
		rootWindowController.window!.setContentSize(CGSize(width: 1000, height: 800))

		// center the window by default
		rootWindowController.window!.center()

		// set the autosave preferences key, which remembers the position and size
		rootWindowController.windowFrameAutosaveName = Preferences.rootWindowFrameKey

		// show it!
		rootWindowController.showWindow(self)

		// update the last launch date
		Preferences.sharedInstance.lastLaunch = Date()
	}

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		// when closing the window, quit the app
		return true
	}

}
