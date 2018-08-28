//
//  DataPoint+Hashable.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 28/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import Foundation
import ForecastIO

extension DataPoint: Hashable {
	
	public static func == (lhs: DataPoint, rhs: DataPoint) -> Bool {
		return lhs.apparentTemperature == rhs.apparentTemperature &&
		lhs.apparentTemperatureHigh == rhs.apparentTemperatureHigh &&
		lhs.apparentTemperatureHighTime == rhs.apparentTemperatureHighTime &&
		lhs.apparentTemperatureLow == rhs.apparentTemperatureLow &&
		lhs.apparentTemperatureLowTime == rhs.apparentTemperatureLowTime &&
		lhs.cloudCover == rhs.cloudCover &&
		lhs.dewPoint == rhs.dewPoint &&
		lhs.humidity == rhs.humidity &&
		lhs.icon == rhs.icon &&
		lhs.moonPhase == rhs.moonPhase &&
		lhs.nearestStormBearing == rhs.nearestStormBearing &&
		lhs.nearestStormDistance == rhs.nearestStormDistance &&
		lhs.ozone == rhs.ozone &&
		lhs.precipitationAccumulation == rhs.precipitationAccumulation &&
		lhs.precipitationIntensity == rhs.precipitationIntensity &&
		lhs.precipitationIntensityMax == rhs.precipitationIntensityMax &&
		lhs.precipitationIntensityMaxTime == rhs.precipitationIntensityMaxTime &&
		lhs.precipitationProbability == rhs.precipitationProbability &&
		lhs.precipitationType == rhs.precipitationType &&
		lhs.pressure == rhs.pressure &&
		lhs.summary == rhs.summary &&
		lhs.sunriseTime == rhs.sunriseTime &&
		lhs.sunsetTime == rhs.sunsetTime &&
		lhs.temperature == rhs.temperature &&
		lhs.temperatureHigh == rhs.temperatureHigh &&
		lhs.temperatureHighTime == rhs.temperatureHighTime &&
		lhs.temperatureLow == rhs.temperatureLow &&
		lhs.temperatureLowTime == rhs.temperatureLowTime &&
		lhs.time == rhs.time &&
		lhs.uvIndex == rhs.uvIndex &&
		lhs.uvIndexTime == rhs.uvIndexTime &&
		lhs.visibility == rhs.visibility &&
		lhs.windBearing == rhs.windBearing &&
		lhs.windGust == rhs.windGust &&
		lhs.windSpeed == rhs.windSpeed
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(apparentTemperature)
		hasher.combine(apparentTemperatureHigh)
		hasher.combine(apparentTemperatureHighTime)
		hasher.combine(apparentTemperatureLow)
		hasher.combine(apparentTemperatureLowTime)
		hasher.combine(cloudCover)
		hasher.combine(dewPoint)
		hasher.combine(humidity)
		hasher.combine(icon)
		hasher.combine(moonPhase)
		hasher.combine(nearestStormBearing)
		hasher.combine(nearestStormDistance)
		hasher.combine(ozone)
		hasher.combine(precipitationAccumulation)
		hasher.combine(precipitationIntensity)
		hasher.combine(precipitationIntensityMax)
		hasher.combine(precipitationIntensityMaxTime)
		hasher.combine(precipitationProbability)
		hasher.combine(precipitationType)
		hasher.combine(pressure)
		hasher.combine(summary)
		hasher.combine(sunriseTime)
		hasher.combine(sunsetTime)
		hasher.combine(temperature)
		hasher.combine(temperatureHigh)
		hasher.combine(temperatureHighTime)
		hasher.combine(temperatureLow)
		hasher.combine(temperatureLowTime)
		hasher.combine(time)
		hasher.combine(uvIndex)
		hasher.combine(uvIndexTime)
		hasher.combine(visibility)
		hasher.combine(windBearing)
		hasher.combine(windGust)
		hasher.combine(windSpeed)
	}
	
}
