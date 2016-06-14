//
//  SearchField.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class SearchField: NSSearchField {

	init?(coder: NSCoder) {
		super.init(coder: coder)

		frame = CGRectMake(0, 0, 160, 22)
	}

	override var intrinsicContentSize: NSSize {
		return frame.size
	}

}
