//
//  ChangesViewController.swift
//  Chariz
//
//  Created by Adam Demasi on 15/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa
import CPM

enum RefreshState: UnsignedInteger {
	case idle
	case refreshing
	case offline
}

class ChangesViewController: PackageListViewController {

	var refreshStatusView = RefreshStatusView()

	// MARK: - View Controller

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("CHANGES", "Title of the changes page.")
	}

	// MARK: - Refresh State Management

	var refreshState = RefreshState.idle {
		didSet {
			switch refreshState {
			case .idle:
				// when idle, show a refresh button
				navigationItem.leftBarButtonItem = UXBarButtonItem(image: NSImage(named: NSImageNameRefreshTemplate), style: .bordered, action: #selector(beginRefresh))

			case .refreshing:
				// when refreshing, show the status
				navigationItem.leftBarButtonItem = UXBarButtonItem(customView: refreshStatusView)

			case .offline:
				// when offline, disable the button
				navigationItem.leftBarButtonItem.enabled = false
			}
		}
	}

	func beginRefresh() {
		// TODO: most of this should not be here
		refreshState = .refreshing

		// set up a Progress to monitor things. the KVO observer will update the status label
		let progress = Progress(totalUnitCount: 1)
		progress.addObserver(self, forKeyPath: #selector(Progress.fractionCompleted), options: .initial, context: nil)
		progress.addObserver(self, forKeyPath: #selector(Progress.localizedDescription), options: .initial, context: nil)
		progress.becomeCurrent(withPendingUnitCount: 1)

		// invoke a refresh
		CPMPackageManagerAggregate.sharedInstance().refreshWithCompletion { (errors: [Error]) in
			// we can now remove our observers
			progress.removeObserver(self, forKeyPath: #selector(Progress.fractionCompleted))
			progress.removeObserver(self, forKeyPath: #selector(Progress.localizedDescription))

			// set the state to idle
			self.refreshState = .idle

			// if we have errors
			if errors.count > 0 {
				var errorString = ""
				let title

				if errors.count == 1 {
					errorString = errors[0].localizedDescription
					title = NSLocalizedString("REFRESH_FAILURE_TITLE", "Title of an alert displayed when one source fails to load.")
				} else {
					let lines = errors.map { return "• \(error.localizedDescription)" }
					errorString += lines.join("\n")

					title = NSLocalizedString("REFRESH_FAILURE_TITLE_MULTIPLE", "Title of an alert displayed when multiple sources fail to load.")
				}

				errorString += "\n" + NSLocalizedString("REFRESH_FAILURE_EXPLANATION", "Explanatory text displayed when source(s) fail to load.")

				// construct and display the alert
				let alert = NSAlert()
				alert.messageText = title
				alert.informativeText = errorString
				alert.beginSheetModal(for: view.window)
			}
		}

		// after the refresh method’s initial (synchronous) stuff has happened, we can resign as the current Progress of the thread
		progress.resignCurrent()
	}

	// MARK: - KVO

	func observeValue(for keyPath: String, ofObject object: AnyObject, change: [String: AnyObject], context: AnyObject) {
		guard let progress = object as Progress else {
			// huh? we probably shouldn’t be here
			super.observeValue(for: keyPath, ofObject: object, change: change, context: context)
			return
		}

		if keyPath == #selector(Progress.fractionCompleted) {
			// TODO: implement loading indicator
			HBLogDebug("fraction completed = \(progress.fractionCompleted)")
		} else if keyPath == #selector(Progress.localizedDescription) {
			// set the status label to the current state
			refreshStatusView.statusText = progress.localizedDescription
			HBLogDebug("localized description = \(progress.localizedDescription)")
		}
	}

}
