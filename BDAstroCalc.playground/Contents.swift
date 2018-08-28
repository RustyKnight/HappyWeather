import UIKit
import CoreLocation

// https://github.com/braindrizzlestudio/BDAstroCalc

var str = "Hello, playground"

let myDate = Date()
let myLocationCoordinates = CLLocationCoordinate2D(latitude: -38.155626, longitude: 145.1174383)
let moonRiseAndSetTimes = BDAstroCalc.moonRiseAndSet(date: myDate, location: myLocationCoordinates)
print(moonRiseAndSetTimes.rise) // Prints the NSDate of the moon rise
print(moonRiseAndSetTimes.set) // Prints the NSDate of the moon rise
