//
//  PackageListViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa
import CPM

class PackageListViewController: UXCollectionViewController {

	static let packageCellReuseIdentifier = "PackageCell"

	var packages: [CPMPackage] = [CPMPackage]()
	
	init() {
		let collectionViewLayout = UXCollectionViewFlowLayout()
		
		super.init(collectionViewLayout: collectionViewLayout)
		
		title = NSLocalizedString("PACKAGES", comment: "Generic title for a list of packages.")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.register(UXTableViewCell.self, forCellWithReuseIdentifier: PackageListViewController.packageCellReuseIdentifier)
	}

	// MARK: - Collection View
	
	override func collectionView(_ collectionView: UXCollectionView!, numberOfItemsInSection section: Int) -> Int {
		return 100 //packages.count
	}
	
	override func collectionView(_ collectionView: UXCollectionView!, cellForItemAt indexPath: IndexPath!) -> UXCollectionViewCell! {
		var cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageListViewController.packageCellReuseIdentifier, for: indexPath!) as? UXTableViewCell
		
		if cell == nil {
			cell = UXTableViewCell(style: .default, reuseIdentifier: PackageListViewController.packageCellReuseIdentifier)
		}

		cell!.textLabel.text = "hi"
		cell!.detailTextLabel.text = "hi"

		return cell
	}

}
