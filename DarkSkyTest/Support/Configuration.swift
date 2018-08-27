//
//  Configuration.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 24/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import Foundation
import LogWrapperKit

struct Configuration {
	// Should probably be a file or something, but guess what, I'm lazy
	static var apiKey: String = {
		if let filepath = Bundle.main.path(forResource: "Config", ofType: "txt") {
			do {
				let contents = try String(contentsOfFile: filepath).trimmed
				log(debug: "APIKey = \(contents)")
				return contents
			} catch let error {
				log(error: "Could not load configuration file - did you forget to create it? - \(error)")
			}
		}
		return ""
	}()
}
