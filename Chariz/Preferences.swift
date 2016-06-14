//
//  Preferences.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class Preferences {

	static let rootWindowFrameKey = "RootWindowFrame"

	static let sharedInstance = Preferences()

	let preferences = NSUserDefaults.standardUserDefaults()

	init() {
		preferences.registerDefaults([
			
		])
	}

	var lastLaunch: Date {
		get { return preferences.objectForKey("LastLaunch") }
		set { preferences.setObject(newValue, forKey: "LastLaunch") }
	}

	var lastLaunch: Date {
		get { return preferences.objectForKey("LastLaunch") }
		set { preferences.setObject(newValue, forKey: "LastLaunch") }
	}

}
