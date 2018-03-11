//
//  SourcesViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class SourcesViewController: UXViewController {
	
	override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		title = NSLocalizedString("SOURCES", comment: "Title of the sources page.")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		super.loadView()

		let splitView = NSSplitView(frame: view.bounds)
		splitView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		splitView.dividerStyle = .thin
		view.addSubview(splitView)

		let sidebarOutlineView = NSOutlineView(frame: CGRect(x: 0, y: 0, width: 220, height: splitView.frame.size.height))
		sidebarOutlineView.autoresizingMask = [ .flexibleHeight, .flexibleRightMargin ]
		sidebarOutlineView.backgroundColor = .purple
		splitView.addSubview(sidebarOutlineView)

		let viewController = PackageListViewController()
		viewController.view.autoresizingMask = [ .height ]
		viewController.view.frame = CGRect(x: sidebarOutlineView.frame.size.width, y: 0, width: splitView.frame.size.width - sidebarOutlineView.frame.size.width, height: splitView.frame.size.height)

		viewController.willMove(toParentViewController: self)
		addChildViewController(viewController)
		splitView.addSubview(viewController.view)
		viewController.didMove(toParentViewController: self)
	}

}
