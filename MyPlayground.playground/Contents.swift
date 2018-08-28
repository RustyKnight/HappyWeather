import UIKit

extension Date {
	
	var withZeroSeconds: Date {
		get {
			let calender = Calendar.current
			let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: self)
			return calender.date(from: dateComponents)!
		}
	}
	
	var startOfHour: Date {
		get {
			return with(.second, setTo:	0).with(.minute, setTo: 0).with(.nanosecond, setTo: 0)
		}
	}
	
	var startOfMinute: Date {
		get {
			return with(.second, setTo:	0).with(.nanosecond, setTo: 0)
		}
	}
	
	func with(_ component: Calendar.Component, setTo value: Int) -> Date {
		let calender = Calendar.current
		return calender.date(bySetting: component, value: value, of: self)!
	}
	
	func byAdding(_ component: Calendar.Component, value: Int) -> Date {
		let calender = Calendar.current
		return calender.date(byAdding: component, value: value, to: self)!
	}
	
	func byAdding(minutes: Int) -> Date {
		return byAdding(.minute, value: minutes)
	}
	
	func byAdding(hours: Int) -> Date {
		return byAdding(.hour, value: hours)
	}
	
	func byAdding(days: Int) -> Date {
		return byAdding(.day, value: days)
	}
	
	func withSameDate(as date: Date) -> Date {
		let calender = Calendar.current
		let dateComponents = calender.dateComponents([.year, .month, .day], from: date)
		return with(.year, setTo: dateComponents.year!).with(.month, setTo: dateComponents.month!).with(.day, setTo: dateComponents.day!)
	}
	
}

let now = Date()
let startTime = now.byAdding(hours: -12)
let endTime = now.byAdding(hours: 12)

let before = now.byAdding(minutes: 5)
let after = now.byAdding(minutes: -5)

let range = endTime.timeIntervalSince(startTime)

let nowPoint = now.timeIntervalSince(startTime) / range
let beforePoint = before.timeIntervalSince(startTime) / range
let afterPoint = after.timeIntervalSince(startTime) / range
