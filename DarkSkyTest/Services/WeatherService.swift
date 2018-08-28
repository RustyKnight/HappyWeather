//
//  WeatherService.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 28/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import Foundation
import ForecastIO
import CoreLocation
import LogWrapperKit

private struct TestLoadError: Error, CustomStringConvertible {
	var description: String = "Failed to load test data"
}

class WeatherService {
	static let shared: WeatherService = WeatherService()
	
	private	let client: DarkSkyClient = {
		let client = DarkSkyClient(apiKey: Configuration.apiKey)
		client.language = .english
		client.units = .uk
		return client
	}()
	private(set) var current: Forecast?
	
	func getForecast(at location: CLLocationCoordinate2D, then: @escaping (Forecast) -> Void, fail: @escaping (Error) -> Void) {
		getForecast(latitude: location.latitude, longitude: location.longitude, then: then, fail: fail)
	}
	
	func getForecast(latitude lat: Double, longitude lon: Double, then: @escaping (Forecast) -> Void, fail: @escaping (Error) -> Void) {
		#if DEBUG
		loadTestData()
		guard let current = current else {
			fail(TestLoadError())
			return
		}
		then(current)
		#else
		client.getForecast(latitude: lat, longitude: lon) { (result) in
			switch result {
			case .success(let currentForecast, _):
				then(currentForecast)
				break
			case .failure(let error):
				fail(error)
				break
			}
		}
		#endif
	}
	
	func loadTestData() {
		guard let path = Bundle.main.path(forResource: "DarkSky", ofType: "json") else {
			return log(debug: "Could not find path for test data")
		}
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
			guard let json = jsonObject as? NSMutableDictionary else {
				log(error: "Test data could not be seralized as JSON dictionary")
				return
			}
			
			let now = Date()
			log(debug: "Now = \(now)")
			updateCurrent(json, startTime: now)
			updateMinutely(json, startTime: now)
			updateHourly(json, startTime: now)
			updateDaily(json, startTime: now)
			
			// Need to fudge the date data
			let forecast = Forecast(fromJSON: json)
			current = forecast
		} catch let error {
			log(error: "Failed to load test data - \(error)")
		}
	}
	
	func updateCurrent(_ json: NSMutableDictionary, startTime: Date) {
		guard let current = json["currently"] as? NSMutableDictionary else {
			fatalError("Could not modify current time")
		}
		current[time] = startTime.timeIntervalSince1970
	}

	func updateMinutely(_ json: NSMutableDictionary, startTime: Date) {
		guard let minutely = json["minutely"] as? NSMutableDictionary, let data = minutely["data"] as? NSArray else {
			fatalError("Could not modify minutely time")
		}
		var time = startTime
		log(debug: "Starting at \(time)")
		for element in data {
			guard let minuteData = element as? NSMutableDictionary else {
				fatalError("Could not modify minute time")
			}
			minuteData["time"] = time.timeIntervalSince1970
			time = time.byAdding(minutes: 1)
		}
		log(debug: "Ending at \(time)")
	}
	
	func updateHourly(_ json: NSMutableDictionary, startTime: Date) {
		guard let hourly = json["hourly"] as? NSMutableDictionary, let data = hourly["data"] as? NSArray else {
			fatalError("Could not modify hourly time")
		}
		var time = startTime.byAdding(days: -1).startOfDay
		log(debug: "startTime \(startTime)")
		log(debug: "Starting of day \(time)")
		for element in data {
			guard let hourData = element as? NSMutableDictionary else {
				fatalError("Could not modify minute time")
			}
			hourData["time"] = time.timeIntervalSince1970
			time = time.byAdding(hours: 1)
		}
		log(debug: "Ending at \(time)")
	}
	
	func updateDaily(_ json: NSMutableDictionary, startTime: Date) {
		guard let daily = json["daily"] as? NSMutableDictionary, let data = daily["data"] as? NSArray else {
			fatalError("Could not modify hourly time")
		}
		var time = startTime.byAdding(days: -1)
		log(debug: "Starting at \(time)")
		for element in data {
			guard let dayData = element as? NSMutableDictionary else {
				fatalError("Could not modify minute time")
			}
			dayData["time"] = time.timeIntervalSince1970
			
			let sunrise = Date(timeIntervalSince1970: dayData["sunriseTime"] as! Double).withSameDate(as: time)
			let sunset = Date(timeIntervalSince1970: dayData["sunsetTime"] as! Double).withSameDate(as: time)
			let precipIntensityMaxTime = Date(timeIntervalSince1970: dayData["precipIntensityMaxTime"] as! Double).withSameDate(as: time)
			let temperatureHighTime = Date(timeIntervalSince1970: dayData["temperatureHighTime"] as! Double).withSameDate(as: time)
			let apparentTemperatureHighTime = Date(timeIntervalSince1970: dayData["apparentTemperatureHighTime"] as! Double).withSameDate(as: time)
			let apparentTemperatureLowTime = Date(timeIntervalSince1970: dayData["apparentTemperatureLowTime"] as! Double).withSameDate(as: time)
			let windGustTime = Date(timeIntervalSince1970: dayData["windGustTime"] as! Double).withSameDate(as: time)
			let uvIndexTime = Date(timeIntervalSince1970: dayData["uvIndexTime"] as! Double).withSameDate(as: time)
			let temperatureMinTime = Date(timeIntervalSince1970: dayData["temperatureMinTime"] as! Double).withSameDate(as: time)
			let temperatureMaxTime = Date(timeIntervalSince1970: dayData["temperatureMaxTime"] as! Double).withSameDate(as: time)
			let apparentTemperatureMinTime = Date(timeIntervalSince1970: dayData["apparentTemperatureMinTime"] as! Double).withSameDate(as: time)
			let apparentTemperatureMaxTime = Date(timeIntervalSince1970: dayData["apparentTemperatureMaxTime"] as! Double).withSameDate(as: time)

			dayData["sunriseTime"] = sunrise.timeIntervalSince1970
			dayData["sunsetTime"] = sunset.timeIntervalSince1970
			dayData["precipIntensityMaxTime"] = precipIntensityMaxTime.timeIntervalSince1970
			dayData["temperatureHighTime"] = temperatureHighTime.timeIntervalSince1970
			dayData["apparentTemperatureHighTime"] = apparentTemperatureHighTime.timeIntervalSince1970
			dayData["apparentTemperatureLowTime"] = apparentTemperatureLowTime.timeIntervalSince1970
			dayData["windGustTime"] = windGustTime.timeIntervalSince1970
			dayData["uvIndexTime"] = uvIndexTime.timeIntervalSince1970
			dayData["temperatureMinTime"] = temperatureMinTime.timeIntervalSince1970
			dayData["temperatureMaxTime"] = temperatureMaxTime.timeIntervalSince1970
			dayData["apparentTemperatureMinTime"] = apparentTemperatureMinTime.timeIntervalSince1970
			dayData["apparentTemperatureMaxTime"] = apparentTemperatureMaxTime.timeIntervalSince1970

			time = time.byAdding(days: 1)
		}
		log(debug: "Ending at \(time)")
	}
	
	func hourlyEvents(round anchor: Date) -> [DataPoint] {
		guard let current = current, let block = current.hourly else {
			return []
		}
		// Would this need to load a dataset to cover this range?
		// How would you determine this?  The model would need to
		// know it's range of avaliable data, based on the
		// level (ie daily, hourley, weekly)
		let startDate = anchor.byAdding(hours: -12)
		let endDate = anchor.byAdding(hours: 12)
		log(debug: "anchor = \(anchor); startDate = \(startDate); endDate = \(endDate)")
		var events: [DataPoint] = []
		for event in block.data {
			guard event.time >= startDate && event.time <= endDate else {
//				log(debug: "Exclude \(event.time)")
				continue
			}
//			log(debug: "Include \(event.time)")
			events.append(event)
		}
		
		return events
	}

}
