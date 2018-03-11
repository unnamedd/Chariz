//
//  ChangesViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa
import CPM

enum RefreshState {
	case idle, refreshing, offline
}

class ChangesViewController: PackageListViewController {

	var refreshStatusView = RefreshStatusView()

	// MARK: - View Controller
	
	override init() {
		super.init()
		
		title = NSLocalizedString("CHANGES", comment: "Title of the changes page.")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Refresh State Management

	var refreshState = RefreshState.idle {
		didSet {
			switch refreshState {
			case .idle:
				// when idle, show a refresh button
				navigationItem.leftBarButtonItem = UXBarButtonItem(image: NSImage(named: .refreshTemplate), style: .bordered, target: self, action: #selector(self.beginRefresh))

			case .refreshing:
				// when refreshing, show the status
				navigationItem.leftBarButtonItem = UXBarButtonItem(customView: refreshStatusView)

			case .offline:
				// when offline, disable the button
				navigationItem.leftBarButtonItem.isEnabled = false
			}
		}
	}

	@objc func beginRefresh() {
		// TODO: most of this should not be here
		refreshState = .refreshing

		// set up a Progress to monitor things. the KVO observer will update the status label
		let progress = Progress(totalUnitCount: 1)
		progress.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: .initial, context: nil)
		progress.addObserver(self, forKeyPath: #keyPath(Progress.localizedDescription), options: .initial, context: nil)
		progress.becomeCurrent(withPendingUnitCount: 1)

		// invoke a refresh
		_ = CPMPackageManagerAggregate.sharedInstance.refresh { (errors: [Error]) in
			// we can now remove our observers
			progress.removeObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted))
			progress.removeObserver(self, forKeyPath: #keyPath(Progress.localizedDescription))

			// set the state to idle
			self.refreshState = .idle

			// if we have errors
			if errors.count > 0 {
				var errorString = ""
				let title: String

				if errors.count == 1 {
					errorString = errors[0].localizedDescription
					title = NSLocalizedString("REFRESH_FAILURE_TITLE", comment: "Title of an alert displayed when one source fails to load.")
				} else {
					let lines = errors.map { return "• \($0.localizedDescription)" }
					errorString += lines.joined(separator: "\n")

					title = NSLocalizedString("REFRESH_FAILURE_TITLE_MULTIPLE", comment: "Title of an alert displayed when multiple sources fail to load.")
				}

				errorString += "\n" + NSLocalizedString("REFRESH_FAILURE_EXPLANATION", comment: "Explanatory text displayed when source(s) fail to load.")

				// construct and display the alert
				let alert = NSAlert()
				alert.messageText = title
				alert.informativeText = errorString
				alert.beginSheetModal(for: self.view.window!)
			}
		}

		// after the refresh method’s initial (synchronous) stuff has happened, we can resign as the current Progress of the thread
		progress.resignCurrent()
	}

	// MARK: - KVO

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let progress = object as? Progress else {
			// huh? we probably shouldn’t be here
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
			return
		}

		if keyPath == #keyPath(Progress.fractionCompleted) {
			// TODO: implement loading indicator
			log(.debug, "fraction completed = \(progress.fractionCompleted)")
		} else if keyPath == #keyPath(Progress.localizedDescription) {
			// set the status label to the current state
			refreshStatusView.statusText = progress.localizedDescription
			log(.debug, "localized description = \(progress.localizedDescription)")
		}
	}

}
