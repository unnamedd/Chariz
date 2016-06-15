//
//  HomeViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class HomeViewController: WebViewController {

	func loadView() {
		super.loadView()

		title = NSLocalizedString("HOME", "Title of the home page.")
		navigationItem.rightBarButtonItem = UXBarButtonItem(customView: CHRSearchField())

		webView.mainFrame.loadRequest(NSURLRequest(url: charizWebUIURL.URLByAppendingPathComponent("featured")))
	}

}
