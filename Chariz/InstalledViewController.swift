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

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("INSTALLED", "Title of the installed page.")
	}

}
