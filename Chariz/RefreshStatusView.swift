//
//  RefreshStatusView.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class RefreshStatusView: UXView {

	let progressIndicator = NSProgressIndicator(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
	let label = UXLabel()
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)

		progressIndicator.style = .spinning
		progressIndicator.controlSize = .small
		progressIndicator.startAnimation(nil)
		addSubview(progressIndicator)

		label.text = NSLocalizedString("UPDATING_SOURCES", comment: "Message displayed while sources are being loaded.")
		label.font = NSFont.titleBarFont(ofSize: 0)
		label.centerVertically = true
		label.frame = CGRect(x: progressIndicator.frame.size.width + 4, y: 0, width: CGFloat(ceilf(Float(label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width))), height: progressIndicator.frame.size.height)
		addSubview(label)
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var intrinsicContentSize: NSSize {
		return CGSize(width: progressIndicator.frame.size.width + label.frame.origin.x + label.frame.size.width, height: progressIndicator.frame.size.height)
	}

	var statusText: String = "" {
		didSet {
			// set the label text and ask to be redrawn
			label.text = statusText
			needsDisplay = true
		}
	}

}
