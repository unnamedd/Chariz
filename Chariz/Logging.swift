//
//  Logging.swift
//  Chariz
//
//  Created by Adam Demasi on 12/2/18.
//  Copyright © 2018 HASHBANG Productions. All rights reserved.
//

import Foundation
import os

enum LogLevel {
	
	case debug, info, warn, error
	
	@available(OSX 10.12, *)
	var oslogType: OSLogType {
		switch self {
		case .debug:
			return .debug
		case .info:
			return .info
		case .warn:
			return .default
		case .error:
			return .error
		}
	}
	
}

func log(_ level: LogLevel, _ log: String) {
	#if DEBUG
		NSLog("%@", log)
	#else
		if #available(OSX 10.12, *) {
			os_log("%{public}@", log: .default, type: level.oslogType, log)
		} else {
			NSLog("%@", log)
		}
	#endif
}
