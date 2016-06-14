//
//  LoadingIndicatorView.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class LoadingIndicatorView: NSProgressIndicator {

	init?(coder: NSCoder) {
		super.init(coder: coder)

		frame = CGRectMake(0, 0, 22, 22)
		style = .spinningStyle
		controlSize = .small

		/*
		 funny, the docs say this should already be NO if we're using a spinning
		 indicator. but, here i am having to set it myself...
		*/
		displayedWhenStopped = false
	}

	override var intrinsicContentSize: NSSize {
		return frame.size
	}

}
