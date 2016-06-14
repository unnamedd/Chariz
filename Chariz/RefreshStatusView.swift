//
//  RefreshStatusView.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class RefreshStatusView: UXView {

	let progressIndicator = NSProgressIndicator(frame: CGRectMake(0, 0, 22, 22))
	let label = UXLabel()

	init() {
		super.init()

		progressIndicator.style = .spinningStyle
		progressIndicator.controlSize = .small
		progressIndicator.startAnimation(nil)
		addSubview(progressIndicator)

		label.text = NSLocalizedString("UPDATING_SOURCES", "Message displayed while sources are being loaded.")
		label.font = NSFont.titleBarFont(ofSize: 0)
		label.centerVertically = true
		label.frame = CGRectMake(progressIndicator.frame.size.width + 4, 0, ceilf(label.sizeThatFits(CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)).width), progressIndicator.frame.size.height)
		addSubview(label)
	}

	override var intrinsicContentSize: NSSize {
		return CGSizeMake(progressIndicator.frame.size.width + label.frame.origin.x + label.frame.size.width, progressIndicator.frame.size.height);
	}

	var statusText: String {
		didSet {
			// set the label text and ask to be redrawn
			label.text = statusText
			needsDisplay = true
		}
	}

}
