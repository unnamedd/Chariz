//
//  SourcesViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class SourcesViewController: UXViewController {

	override func loadView() {
		super.loadView()

		title = NSLocalizedString("SOURCES", "Title of the sources page.")

		let splitView = NSSplitView(frame: view.bounds)
		splitView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		splitView.dividerStyle = .thin
		view.addSubview(splitView)

		let sidebarOutlineView = NSOutlineView(frame: CGRectMake(0, 0, 220, splitView.frame.size.height))
		sidebarOutlineView.autoresizingMask = [ .flexibleHeight, .flexibleRightMargin ]
		sidebarOutlineView.backgroundColor = .purpleColor()
		splitView.addSubview(sidebarOutlineView)

		let viewController = PackageListViewController()
		viewController.view.autoresizingMask = [ .height ]
		viewController.view.frame = CGRectMake(sidebarOutlineView.frame.size.width, 0, splitView.frame.size.width - sidebarOutlineView.frame.size.width, splitView.frame.size.height)

		viewController.willMoveToParentViewController(self)
		addChildViewController(viewController)
		splitView.addSubview(viewController.view)
		viewController.didMoveToParentViewController(self)
	}

}
