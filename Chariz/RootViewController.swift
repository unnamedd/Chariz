//
//  RootViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class RootViewController: UXSourceController {

	func loadView() {
		super.loadView()

		rootViewControllers = [
			HomeViewController(),
			SourcesViewController(),
			ChangesViewController(),
			InstalledViewController()
		];
	}

}
