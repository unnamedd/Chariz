//
//  SourcesListViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class SourcesListViewController: UXTableViewController {

	static let sourceCellReuseIdentifier = "SourceCell"

	var sources: [CHRSource] = []

	func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("SOURCES", "Title of the sources page.")

		tableView.registerClass(UXTableViewCell.class, forCellWithReuseIdentifier: SourcesListViewController.sourceCellReuseIdentifier)
	}

	// MARK: - Table View

	func tableView(_ tableView: UXTableView, numberOfRowsInSection section: Integer) -> UnsignedInteger {
		return sources.count
	}

	func tableView(_ tableView: UXTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UXTableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(SourcesListViewController.sourceCellReuseIdentifier, forIndexPath: indexPath)

		if cell == nil {
			cell = UXTableViewCell(style: .default, reuseIdentifier: SourcesListViewController.sourceCellReuseIdentifier)
		}

		cell.textLabel.text = "hi"
		cell.detailTextLabel.text = "hi"

		return cell
	}
	
}
