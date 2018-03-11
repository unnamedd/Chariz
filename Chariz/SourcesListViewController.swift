//
//  SourcesListViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa
import CPM

class SourcesListViewController: UXTableViewController {

	static let sourceCellReuseIdentifier = "SourceCell"

	// TODO: [Source]
	var sources: [NSObject] = []
	
	convenience init() {
		self.init(style: .plain)

		title = NSLocalizedString("SOURCES", comment: "Title of the sources page.")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UXTableViewCell.self, forCellWithReuseIdentifier: SourcesListViewController.sourceCellReuseIdentifier)
	}

	// MARK: - Table View

	override func tableView(_ tableView: UXTableView, numberOfRowsInSection section: Int) -> UInt {
		return UInt(sources.count)
	}

	override func tableView(_ tableView: UXTableView!, cellForRowAt indexPath: IndexPath!) -> UXTableViewCell! {
		var cell = tableView.dequeueReusableCell(withIdentifier: SourcesListViewController.sourceCellReuseIdentifier, for: indexPath)

		if cell == nil {
			cell = UXTableViewCell(style: .default, reuseIdentifier: SourcesListViewController.sourceCellReuseIdentifier)
		}

		cell!.textLabel.text = "hi"
		cell!.detailTextLabel.text = "hi"

		return cell
	}
	
}
