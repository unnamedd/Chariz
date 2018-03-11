//
//  InstalledViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class InstalledViewController: PackageListViewController {

	// MARK: - View Controller
	
	override init() {
		super.init()
		
		title = NSLocalizedString("INSTALLED", comment: "Title of the installed page.")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
