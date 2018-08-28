//
//  Clock.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 27/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import Foundation
import LogWrapperKit

typealias Tick = () -> Void

// I would be nice to be able to pass in resolution, second, minute, hour
// The intention is to provide a call back every minite on the minute boundry
// It's not intended to be a "high" resolution clock, just a "good enough"
// resolution that it appears to sync with the phones own display
class Clock {
	
	private var timer: Timer?
	
	private let ticker: Tick
	
	// This is really only intended to sync the clock with the next minute, so it will
	// tick more closly on the minute boundry and reduce the need to have a faster
	// timer
	private var nextInterval: TimeInterval {
		let now = Date()
		let then = Date().addingTimeInterval(60.0).withZeroSeconds
		let delay = then.timeIntervalSince(now)
		//log(debug: "delay = \(delay)")
		return delay
	}
	
	init(tick: @escaping Tick) {
		ticker = tick
	}
	
	@objc func ticked() {
		ticker()
		// Should really just set up a "minute" repeating timer
		stop()
		start()
	}
	
	func start() {
		guard timer == nil else {
			return
		}
		self.timer = Timer.scheduledTimer(timeInterval: nextInterval, target: self, selector: #selector(ticked), userInfo: nil, repeats: false)
	}
	
	func stop() {
		guard let timer = timer else {
			return
		}
		timer.invalidate()
		self.timer = nil
	}
	
}
