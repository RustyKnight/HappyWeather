//
//  PostLaunchViewController.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 24/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import UIKit
import Hydra
import CoreLocation
import AnimatorKit

class PostLaunchViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var statusLabel: UILabel!
	
	let manager = CLLocationManager()
	var animator: LinearAnimator?
	
	var angle: Double = 0
	
	var userLocation: CLLocation?

	override func viewDidLoad() {
		super.viewDidLoad()
		manager.delegate = self
		animator = LinearAnimator()
		animator?.delegate = self
		animator?.start()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		switch CLLocationManager.authorizationStatus() {
		case .notDetermined: manager.requestWhenInUseAuthorization()
		case .authorizedWhenInUse: fallthrough
		case .authorizedAlways: findUserLocation()
		case .restricted: fallthrough
		case .denied: break
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		guard let animator = animator else {
			return
		}
		animator.stop()
		animator.delegate = nil
		self.animator = nil
	}
	
	func findUserLocation() {
		guard CLLocationManager.locationServicesEnabled() else {
			return
		}
		manager.desiredAccuracy = kCLLocationAccuracyKilometer
		manager.startUpdatingLocation()
	}
	
	func found(location: CLLocation) {
		manager.stopUpdatingLocation()
		userLocation = location
		UIView.animate(withDuration: 1.0) {
			self.statusLabel.text = "Looking out the window"
		}
	}
	
}

extension PostLaunchViewController: LinearAnimatorDelegate {
	
	func didTick(animation: LinearAnimator) {
		angle -= 0.5
		imageView.image = WeatherStyleKit.imageOfHappySun(imageSize: CGSize(width: 200, height: 200), sunRays: CGFloat(angle))
	}
	
}

extension PostLaunchViewController: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch CLLocationManager.authorizationStatus() {
		case .notDetermined: break // 😳
		case .authorizedWhenInUse: fallthrough
		case .authorizedAlways: findUserLocation()
		case .restricted: fallthrough
		case .denied: break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else {
			return
		}
		// Within a kilometer (radius)
		guard location.horizontalAccuracy <= 500 else {
			return
		}
		found(location: location)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//		performSegue(withIdentifier: "sad", sender: self)
	}

}
