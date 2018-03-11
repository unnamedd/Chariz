//
//  SearchField.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import Cocoa

class SearchField: NSSearchField {
	
	override init(frame frameRect: NSRect) {
		super.init(frame: CGRect(x: 0, y: 0, width: 160, height: 22))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var intrinsicContentSize: NSSize {
		return frame.size
	}

}
