//
//  Weather.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 27/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import Foundation
import ForecastIO

struct Weather {//}: Codable {
//	var latitude: Double
//	var longitude: Double
//	var timezone: String
	
	let forecast: Forecast
	let metaData: RequestMetadata
}

//struct Currently
