//
//  ViewController.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 24/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import UIKit
import ForecastIO

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let client = DarkSkyClient(apiKey: Configuration.apiKey)
		client.language = .english
		client.units = .si
	}

}

