//
//  Icon+Image.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 28/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import Foundation
import UIKit
import ForecastIO

extension Icon {
	
	var image: UIImage {
		switch self {
		case .clearDay: return WeatherStyleKit.imageOfWeatherSunny()
		case .clearNight: return WeatherStyleKit.imageOfWeatherMoon
		case .rain: return WeatherStyleKit.imageOfWeatherModerateRain
		case .snow: return WeatherStyleKit.imageOfWeatherSnow
		case .sleet: return WeatherStyleKit.imageOfWeatherSleet
		case .wind: return WeatherStyleKit.imageOfWeatherWindy
		case .fog: return WeatherStyleKit.imageOfWeatherFog
		case .cloudy: return WeatherStyleKit.imageOfWeatherPartlyCloudyDay
		case .partlyCloudyDay: return WeatherStyleKit.imageOfWeatherPartlyCloudyDay
		case .partlyCloudyNight: return WeatherStyleKit.imageOfWeatherPartlyCloudyNight
		}
	}
	
}
