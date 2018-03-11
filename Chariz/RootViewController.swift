//
//  RootViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class RootViewController: UXSourceController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
		style = .tabBar

		rootViewControllers = [
			HomeViewController(),
			SourcesViewController(),
			ChangesViewController(),
			InstalledViewController()
		]
	}

}
