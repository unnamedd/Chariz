//
//  Preferences.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class Preferences {

	static let rootWindowFrameKey = NSWindow.FrameAutosaveName("RootWindowFrame")

	static let sharedInstance = Preferences()

	let preferences = UserDefaults.standard

	init() {
		preferences.register(defaults: [
			"LastLaunch": Date.distantPast
		])
	}

	var lastLaunch: Date {
		get { return preferences.object(forKey: "LastLaunch") as! Date }
		set { preferences.set(newValue, forKey: "LastLaunch") }
	}

}
