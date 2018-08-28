import UIKit

// DateFormatter
let formatter = DateFormatter()
formatter.dateStyle = .short
formatter.timeStyle = .short
formatter.timeZone = .current

// Sunrise and sunset
let sunCalc = SunCalc()
let now = Date()
let location = SunCalc.Location(latitude: -38.155626, longitude: 145.1174383)
if let riseTime = try? sunCalc.time(ofDate: now, forSolarEvent: .sunrise, atLocation: location) {
	let sunrise = formatter.string(from: riseTime)
	print("Sunrise: \(sunrise)")
}
if let setTime = try? sunCalc.time(ofDate: now, forSolarEvent: .sunset, atLocation: location) {
	let sunset = formatter.string(from: setTime)
	print("Sunset: \(sunset)")
}

// Moon rise and moon set
let moonTimes = try? sunCalc.moonTimes(date: now, location: location)
if let moonTimes = moonTimes {
	print("Moonrise: \(formatter.string(from: moonTimes.moonRiseTime))")
	print("Moonset: \(formatter.string(from: moonTimes.moonSetTime))")
}
