//
//  LoadingIndicatorView.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class LoadingIndicatorView: NSProgressIndicator {
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)

		frame = CGRect(x: 0, y: 0, width: 22, height: 22)
		style = .spinning
		controlSize = .small

		// funny, the docs say this should already be NO if we're using a spinning indicator. but, here
		// i am having to set it myself…
		isDisplayedWhenStopped = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var intrinsicContentSize: NSSize {
		return frame.size
	}

}
