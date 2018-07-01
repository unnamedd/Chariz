//
//  HomeViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa
import WebKit

class HomeViewController: NSViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let webView = view as! WKWebView
		webView.load(URLRequest(url: charizWebsiteURL)) // charizWebUIURL.appendingPathComponent("home/")))
	}

}
