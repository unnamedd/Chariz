//
//  MainWindowController.swift
//  Chariz
//
//  Created by Adam Demasi on 1/7/18.
//  Copyright © 2018 HASHBANG Productions. All rights reserved.
//

import Cocoa

enum MainWindowToolbarItem: String {
	case back, refreshProgress, tabs, downloads, search
}

class MainWindowController: NSWindowController, NSToolbarItemValidation {
	
	@IBOutlet weak var tabSegmentControl: NSSegmentedControl!
	@IBOutlet weak var progressIndicator: NSProgressIndicator!
	@IBOutlet weak var backButton: NSButton!
	@IBOutlet weak var downloadsButton: NSButton!
	@IBOutlet weak var searchField: NSSearchField!
	
	override func windowDidLoad() {
		super.windowDidLoad()

		tabSegmentControl.selectedSegment = 0
		progressIndicator.startAnimation(self)
		backButton.isHidden = true
		downloadsButton.isHidden = true
	}
	
	@IBAction func tabSelectionDidChange(_ sender: NSSegmentedControl) {
		let viewController = contentViewController as! RootViewController
		viewController.selectedTabViewItemIndex = tabSegmentControl.selectedSegment
	}
	
	override func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
		switch MainWindowToolbarItem(rawValue: item.itemIdentifier.rawValue) {
		case .back?:
			return false
		
		case .refreshProgress?:
			return false
		
		case .downloads?:
			return false
		
		case .tabs?, .search?:
			return true
		
		default:
			// ask super what it thinks of this item
			return super.validateToolbarItem(item)
		}
		
	}
	
}
