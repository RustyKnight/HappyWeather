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
	
	var weather: Weather?
	var clock: Clock!
	
	let outerTrackLayer: CAShapeLayer = CAShapeLayer()
	let safeTrackLayer: CAShapeLayer = CAShapeLayer()
	let middleTrackLayer: CAShapeLayer = CAShapeLayer()
	let innerTrackLayer: CAShapeLayer = CAShapeLayer()

	var timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm a"
		return formatter
	}()
	
	let outerTrack: Track = Track(radius: 150, in: 300)
	let safeTrack: Track = Track(radius: 131.25, in: 300)
	let middleTrack: Track = Track(radius: 103.125, in: 300)
	let innerTrack: Track = Track(radius: 75, in: 300)
	
	var sun: UIImageView!
	var weather: UIImageView!
	
	var animator: DurationAnimator = DurationAnimator(duration: 60.0)

	override func viewDidLoad() {
		super.viewDidLoad()
		
		animator.delegate = self
		
		sun = UIImageView(image: WeatherStyleKit.imageOfWeatherSunny())
		sun.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
		sun.contentMode = .scaleAspectFit
		
		weather = UIImageView(image: WeatherStyleKit.imageOfWeatherTornado)
		weather.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
		weather.contentMode = .scaleAspectFit

		backgroundView.addSubview(sun)
		
		hudImageView.image = WeatherStyleKit.imageOfHorizonHud()
		
		clock = Clock(tick: {
			log(debug: "Tick")
			self.updateTime()
		})
		
		configure(layer: outerTrackLayer, with: outerTrack, outline: UIColor.red)
		configure(layer: safeTrackLayer, with: safeTrack, outline: UIColor.green)
		configure(layer: middleTrackLayer, with: middleTrack, outline: UIColor.blue)
		configure(layer: innerTrackLayer, with: innerTrack, outline: UIColor.yellow)

		backgroundView.layer.addSublayer(outerTrackLayer)
		backgroundView.layer.addSublayer(middleTrackLayer)
		backgroundView.layer.addSublayer(innerTrackLayer)
		backgroundView.layer.addSublayer(safeTrackLayer)
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
		clock.start()
		
		updateSun(at: 0)
		animator.start()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		clock.stop()
		animator.stop()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	func updateTime() {
		clockLabel.text = timeFormatter.string(from: Date())
	}
	
	func dump(_ dp: DataPoint?) {
		log(debug: "\(dp.debugDescription)")
	}
	
	func dump(_ db: DataBlock?) {
		log(debug: "\(db.debugDescription)")
	}
	
	func updateSun(at progress: Double) {
		let angle = (360.0 * -progress) + 90
		let point = safeTrack.pointAt(degrees: angle)
		sun.center = point
	}

}

extension DataPoint: CustomStringConvertible {
	public var description: String {
		var properties: [String: String] = [:]
		properties["time"] = time.description
		properties["summary"] = summary ?? "nil"
		properties["icon"] = icon?.rawValue ?? "nil"
		properties["sunriseTime"] = sunriseTime?.description ?? "nil"
		properties["sunsetTime"] = sunsetTime?.description ?? "nil"
		properties["moonPhase"] = moonPhase?.description ?? "nil"
		properties["nearestStormDistance"] = nearestStormDistance?.description ?? "nil"
		properties["nearestStormBearing"] = nearestStormBearing?.description ?? "nil"
		properties["precipitationIntensity"] = precipitationIntensity?.description ?? "nil"
		properties["precipitationIntensityMax"] = precipitationIntensityMax?.description ?? "nil"
		properties["precipitationIntensityMaxTime"] = precipitationIntensityMaxTime?.description ?? "nil"
		properties["precipitationType"] = precipitationType?.rawValue ?? "nil"
		properties["precipitationAccumulation"] = precipitationAccumulation?.description ?? "nil"
		properties["temperature"] = temperature?.description ?? "nil"
		properties["temperatureLow"] = temperatureLow?.description ?? "nil"
		properties["temperatureHigh"] = temperatureHigh?.description ?? "nil"
		properties["temperatureHighTime"] = temperatureHighTime?.description ?? "nil"
		properties["apparentTemperatureLow"] = apparentTemperatureLow?.description ?? "nil"
		properties["apparentTemperatureLowTime"] = apparentTemperatureLowTime?.description ?? "nil"
		properties["apparentTemperatureHigh"] = apparentTemperatureHigh?.description ?? "nil"
		properties["apparentTemperatureHighTime"] = apparentTemperatureHighTime?.description ?? "nil"
		properties["dewPoint"] = dewPoint?.description ?? "nil"
		properties["windGust"] = windGust?.description ?? "nil"
		properties["windSpeed"] = windSpeed?.description ?? "nil"
		properties["windBearing"] = windBearing?.description ?? "nil"
		properties["cloudCover"] = cloudCover?.description ?? "nil"
		properties["humidity"] = humidity?.description ?? "nil"
		properties["pressure"] = pressure?.description ?? "nil"
		properties["visibility"] = visibility?.description ?? "nil"
		properties["ozone"] = ozone?.description ?? "nil"
		properties["uvIndex"] = uvIndex?.description ?? "nil"
		properties["uvIndexTime"] = uvIndexTime?.description ?? "nil"
		
		return "DataPoint: \n\t" + properties.sorted { (lhs, rhs) -> Bool in
				return lhs.key < rhs.key
			}.map { (entry) -> String in
				return "\(entry.key) = \(entry.value)"
			}.joined(separator: "\n\t")
	}

}

extension HudViewController: DurationAnimatorDelegate {
	
	func didTick(animation: DurationAnimator, progress: Double) {
		updateSun(at: progress)
		backgroundView.setNeedsLayout()
		backgroundView.setNeedsDisplay()
	}
	
	func didComplete(animation: DurationAnimator, completed: Bool) {
		guard completed else {
			return
		}
		animation.start()
	}
	
	
}
