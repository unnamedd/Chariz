//
//  PackageListViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class PackageListViewController: UXTableViewController {

	static let packageCellReuseIdentifier = "PackageCell"

	var packages: [CHRPackage] = []

	func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("PACKAGES", "Generic title for a list of packages.")

		tableView.registerClass(UXTableViewCell.class, forCellWithReuseIdentifier: PackageListViewController.packageCellReuseIdentifier)
	}

	// MARK: - Table View

	func tableView(_ tableView: UXTableView, numberOfRowsInSection section: Integer) -> UnsignedInteger {
		return packages.count
	}

	func tableView(_ tableView: UXTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UXTableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier(PackageListViewController.packageCellReuseIdentifier, forIndexPath: indexPath)

		if cell == nil {
			cell = UXTableViewCell(style: .default, reuseIdentifier: PackageListViewController.packageCellReuseIdentifier)
		}

		cell.textLabel.text = "hi"
		cell.detailTextLabel.text = "hi"

		return cell
	}

}
