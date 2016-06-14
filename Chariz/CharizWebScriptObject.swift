//
//  CharizScriptingObject.swift
//  Chariz
//
//  Created by Adam Demasi on 14/6/16.
//  Copyright © 2016 HASHBANG Productions. All rights reserved.
//

import CPM
import WebKit

class CHRCharizWebScriptObject: NSObject {

	let packageManagerAggregate = CPMPackageManagerAggregate.sharedInstance()

	// MARK: - WebKit 

	class func webScriptNameForSelector(selector: Selector) {
		// given a method name on this class, return the function name to be
		// exported in javascript

		switch selector {
		case Selector("getPackageById:"):
			return "getPackageById"

		default:
			return nil
		}
	}

	class func isSelectorExcludedFromWebScript(selector: Selector) {
		// if we don’t know about it above, it shouldn’t be included in the object
		return webScriptNameForSelector(selector: selector) == nil
	}

	// MARK: - Functions

	func getPackageById(identifier: String) -> CPMPackage {
		var package: CPMPackage

		let semaphore = DispatchSemaphore(value: 0)

		packageManagerAggregate.packagesForIdentifiers([ identifier ]) { (packages: [String: CPMPackage], error: Error) in
			if error {
				WebScriptObject.throwException(error.description)
				return
			}

			package = packages[identifier]

			semaphore.signal()
		}

		semaphore.wait(2)

		return package
	}

}
