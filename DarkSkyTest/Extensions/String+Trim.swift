//
//  String+Tim.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 27/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import Foundation

extension String {
	var trimmed: String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
