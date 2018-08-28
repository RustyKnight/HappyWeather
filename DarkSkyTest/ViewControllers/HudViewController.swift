//
//  HudViewViewController.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 26/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import UIKit
import ForecastIO
import LogWrapperKit
import AnimatorKit

struct Track {
	let frame: CGRect
	
	init(frame: CGRect) {
		self.frame = frame
	}
	
	init(x: CGFloat, y: CGFloat, radius: CGFloat) {
		self.init(frame: CGRect(x: x, y: y, width: radius * 2, height: radius * 2))
	}
	
	init(origin: CGPoint, size: CGSize) {
		self.init(frame: CGRect(origin: origin, size: size))
	}
	
	init(radius: CGFloat, in area: CGFloat) {
		self.init(x: (area / 2) - radius, y: (area / 2) - radius, radius: radius)
	}
	
	func pointAt(degrees: Double) -> CGPoint {
		return pointAt(degrees: CGFloat(degrees))
	}
	
	func pointAt(degrees: CGFloat) -> CGPoint {
		let rads = Measurement(value: Double(degrees), unit: UnitAngle.degrees).converted(to: UnitAngle.radians).value
		return pointAt(radians: CGFloat(rads))
	}
	
	func pointAt(radians: CGFloat) -> CGPoint {
		let radius = min(frame.size.width, frame.size.height) / 2
		
		let originX = frame.origin.x + radius
		let originY = frame.origin.y + radius
		
		let x = originX + (radius * cos(radians))
		let y = originY + (radius * sin(radians))
		
		return CGPoint(x: x, y: y)
	}
	
	func path() -> CGPath {
		return UIBezierPath(ovalIn: frame).cgPath
	}
}

class HudViewController: UIViewController {
	
	@IBOutlet weak var hudImageView: UIImageView!
	@IBOutlet weak var clockLabel: UILabel!
	@IBOutlet weak var backgroundView: UIView!
	
	var clock: Clock!
	
//	let outerTrackLayer: CAShapeLayer = CAShapeLayer()
	let orbitTrackLayer: CAShapeLayer = CAShapeLayer()
	let weatherTrackLayer: CAShapeLayer = CAShapeLayer()
//	let innerTrackLayer: CAShapeLayer = CAShapeLayer()
	
	var timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm a"
		return formatter
	}()
	
	//let outerTrack: Track = Track(radius: 150, in: 300)
	let orbitTrack: Track = Track(radius: 125, in: 300)
	let weatherTrack: Track = Track(radius: 87.5, in: 300)
	//let innerTrack: Track = Track(radius: 75, in: 300)
	
	var orbitEvents: [DataPoint: UIImageView] = [:]
	var weatherEvents: [DataPoint: UIImageView] = [:]
	
	let weatherIconSize = CGSize(width: 20, height: 20)
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		sun = UIImageView(image: WeatherStyleKit.imageOfWeatherSunny())
//		sun.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//		sun.contentMode = .scaleAspectFit
//
//		weatherView = UIImageView(image: WeatherStyleKit.imageOfWeatherTornado)
//		weatherView.frame = CGRect(x: 0, y: 0, width: 37.5, height: 37.5)
//		weatherView.contentMode = .scaleAspectFit
//
//		backgroundView.insertSubview(sun, at: 0)
//		backgroundView.insertSubview(weatherView, at: 1)
//
		hudImageView.image = WeatherStyleKit.imageOfHorizonHud()
		
		clock = Clock(tick: {
			self.updateTime()
			self.updateEvents()
			self.updateReport()
		})
		
		configure(layer: orbitTrackLayer, with: orbitTrack, outline: UIColor.green)
		configure(layer: weatherTrackLayer, with: weatherTrack, outline: UIColor.blue)

		backgroundView.layer.addSublayer(weatherTrackLayer)
		backgroundView.layer.addSublayer(orbitTrackLayer)
	}
	
	func configure(layer: CAShapeLayer, with track: Track, outline color: UIColor) {
		layer.path = track.path()
		layer.strokeColor = color.cgColor
		layer.lineWidth = 1.0
		layer.fillColor = UIColor.clear.cgColor
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateTime()
		updateEvents()
		updateReport()
		clock.start()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		clock.stop()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	func updateTime() {
		clockLabel.text = timeFormatter.string(from: Date())
	}
	
	func point(on track: Track, at progress: Double, offset: Double = 90) -> CGPoint {
		let angle = (360.0 * progress) + offset
		return track.pointAt(degrees: angle)
	}
	
	func updateEvents() {
		let events = WeatherService.shared.hourlyEvents(round: Date())
		let existingEvents = weatherEvents.keys.map({ $0 })
		
		let remaining = existingEvents.filter({ events.contains($0) })
		let outOfDate = existingEvents.filter({ !remaining.contains($0) })
		
		let toRemove = weatherEvents.filter( { outOfDate.contains($0.key) } )
		for entry in toRemove {
			guard let view = weatherEvents.removeValue(forKey: entry.key) else {
				log(debug: "Missing view for event?")
				continue
			}
			view.removeFromSuperview()
		}
		
		let toAdd = events.filter( { !remaining.contains($0)} )
		for event in toAdd {
			let view = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: weatherIconSize))
			view.contentMode = .scaleAspectFit
			view.image = event.icon?.image
			weatherEvents[event] = view
			log(debug: "Add new view")
			backgroundView.insertSubview(view, at: 0)
		}
	}
	
	func updateReport() {
		// This just gives us a single point in time to work from...
		let now = Date()
		let startTime = now.byAdding(hours: -12)
		let endTime = now.byAdding(hours: 12)
		let range = endTime.timeIntervalSince(startTime)
		
		log(debug: "now = \(now); startTime = \(startTime); endTime = \(endTime)")
		
		let keys = weatherEvents.keys.sorted { (lhs, rhs) -> Bool in
			return lhs.time < rhs.time
		}
		
		for key in keys {
			let view = weatherEvents[key]
			let progress = key.time.timeIntervalSince(startTime) / range
			log(debug: "event \(key.time) @ \(progress)")
			if progress > 1.0 {
				// No longer valid
				view?.removeFromSuperview()
			} else if progress < 0.0 {
				// It's coming, but we don't need to display it
				view?.isHidden = true
			} else {
				view?.isHidden = false
				view?.center = point(on: weatherTrack, at: progress)
			}
		}
	}
	
}
