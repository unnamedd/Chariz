//
//  HomeViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class HomeViewController: WebViewController {
	
	required init() {
		super.init()
		
		title = NSLocalizedString("HOME", comment: "Title of the home page.")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UXBarButtonItem(customView: SearchField())

		webView.mainFrame.load(URLRequest(url: charizWebsiteURL)) // charizWebUIURL.appendingPathComponent("home/")))
	}

}
